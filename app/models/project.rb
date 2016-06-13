class Project < ActiveRecord::Base
  include AASM

  STEP_FORWARD_STATE = {
    'quotes'     => :propose,
    'proposals'  => :ordered,
    'orders'     => :active,
    'in_process' => :close
  }

  STEP_BACK_STATE = {
    'proposals'  => :quoted,
    'orders'     => :propose,
    'in_process' => :ordered,
    'closed'     => :active
  }

  belongs_to :customer
  belongs_to :sales, class_name: 'User'

  has_many :curtains, dependent: :destroy
  has_many :versions, class_name: 'ProjectVersion', dependent: :destroy

  has_many :tasks, dependent: :destroy
  has_many :drape_tasks, class_name: 'DrapeTask', dependent: :destroy
  has_many :trough_tasks, class_name: 'TroughTask', dependent: :destroy

  has_many :items, dependent: :destroy
  accepts_nested_attributes_for :items, :allow_destroy => true

  delegate :email, :first_name, :full_name, :city_address, :name_for_select,
           :contry_address, :address_for_email, :phone_o,
           to: :customer, prefix: true, :allow_nil => true

  delegate :name_for_select, :address_for_email, :email, :city_address, :full_name, :rep_number, :first_title,
           to: :sales, prefix: true, :allow_nil => true

  validates :customer, :sales, presence: true

  attr_accessor :update_event

  after_save :fix_price

  aasm column: :state do
    state :quotes,  initial: true
    state :proposals, after_enter: :create_init_version
    state :orders, enter: :set_date
    state :in_process
    state :closed

    event :quoted do
      transitions from: :proposals, to: :quotes
    end

    event :propose do
      transitions from: [:quotes, :orders], to: :proposals
    end

    event :ordered do
      transitions from: [:proposals, :in_process], to: :orders
    end

    event :active do
      transitions from: [:orders, :closed], to: :in_process
    end

    event :close do
      transitions from: :in_process, to: :closed
    end
  end

  def create_init_version
    ProjectVersion.create_init_version_for(self, self.versions.any? ? 'Make propose' : 'initialize')
  end

  def populate_default_items
    Project.transaction do
      length = 0
      self.items.auto_created.destroy_all
      self.reload
      self.curtains.each do |curtain|
        length += curtain.quantity *  Unit("#{curtain.width} mm").convert_to('ft').scalar.ceil
        if Setting.multiplicity_items.present?
          Setting.multiplicity_items.items.map(&:attributes).each do |attrs|
            base = Setting.width_multiplicity.to_f
            new_quantity = attrs["quantity"] * (curtain.width / base).ceil * curtain.quantity
            exist = self.items.select{|item| item.name == attrs['name'] && item.auto_create?}.first
            if exist
              exist.quantity += new_quantity
            else
              attrs["quantity"] = new_quantity
              self.items.build attrs.merge(auto_create: true)
            end
          end
        end
      end
      calculate_instalation(length)
      self.update_event = 'Curtains Updated'
      self.save
    end
  end

  def calculate_instalation(length)
    if length > 0
      self.items.build name: 'Installation',
                       unit: 'foot',
                       quantity: length,
                       price: Setting.installation_price,
                       auto_create: true
    end
  end

  def items_price
    items.inject(0){|acc, item| acc + item.full_price }
  end

  def curtains_price
    curtains.inject(0){|acc, curtains| acc + curtains.full_price }
  end

  def calculated_price
    items_price + curtains_discounted
  end

  def discount_as_float
    (100 - discount.to_f)/100
  end

  def curtains_discount
    (curtains_price * (1 - discount_as_float)).round(2)
  end

  def curtains_discounted
    (curtains_price * discount_as_float).round(2)
  end

  def set_date
    self.start_at = Date.current
  end

  def versioned_name
    if versions.any?
      versions.last.name_for_email
    else
      self.id
    end
  end

  def restore(version)
    curtains_data = version.object.extract!('curtains')['curtains']
    items_data = version.object.extract!('items')['items']
    self.update_attributes(
      version.object.merge(
        update_event: "restore #{version.name}",
        curtains: self.curtains.build(curtains_data),
        items: self.items.build(items_data)
      )
    )
  end

  def self.search_by(term)
    conditions = nil
    term.split(' ').map do |item|
      "%#{item.strip}%"
    end.map do |query_term|
      if conditions.present?
        conditions = conditions.or(build_query_term(query_term))
      else
        conditions = build_query_term(query_term)
      end
    end
    self.joins('LEFT JOIN customers ON projects.customer_id = customers.id').
         joins("LEFT JOIN profiles ON profiles.person_id = customers.id AND profiles.person_type = 'Customer'").
         where(conditions)
  end

  def self.build_query_term query_term
    projects = self.arel_table
    customers = Customer.arel_table
    profile = Profile.arel_table
    project_id = Arel::Nodes::NamedFunction.new "CAST", [ projects[:id].as("varchar") ]

    project_id.matches(query_term).
    or(customers[:email].matches(query_term)).
    or(profile[:first_name].matches(query_term)).
    or(profile[:last_name].matches(query_term)).
    or(profile[:first_title].matches(query_term)).
    or(profile[:second_title].matches(query_term)).
    or(profile[:first_address].matches(query_term)).
    or(profile[:second_address].matches(query_term)).
    or(profile[:country].matches(query_term)).
    or(profile[:city].matches(query_term)).
    or(profile[:state].matches(query_term)).
    or(profile[:zip].matches(query_term)).
    or(profile[:phone_o].matches(query_term)).
    or(profile[:phone_c].matches(query_term))
  end

  def fix_price_with event
    self.update_event = event
    self.fix_price
  end

  def fix_price
    if self.price.to_f != self.calculated_price.to_f || self.update_event.to_s.match(/\Arestore #/)
      self.update_event ||= "Price change"
      self.price = self.calculated_price
      self.update_column(:price, self.calculated_price)
      if self.state != 'quotes' && self.changed.include?('price')
        ProjectVersion.create_version_for(self, self.update_event)
      end
    end
  end

  def step_forward
    STEP_FORWARD_STATE[self.state]
  end

  def step_back
    STEP_BACK_STATE[self.state]
  end
end
