class Customer < ActiveRecord::Base
  belongs_to :sales, class_name: 'User'

  has_one :profile, as: :person, dependent: :destroy
  accepts_nested_attributes_for :profile

  has_many :projects

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  delegate :email, :rep_number, :name_for_select, to: :sales, prefix: true, :allow_nil => true

  delegate :first_name, :last_name, :full_name, :first_title, :second_title, :first_address, :address_for_email,
           :second_address, :country, :city, :state, :zip, :phone_o, :phone_c, :name_for_select, :city_address,
            to: :profile, prefix: false

  after_initialize do |customer|
    customer.build_profile unless customer.profile
  end

  def self.search_by(term)
    query_term = "%#{term}%"
    customers = self.arel_table
    profile = Profile.arel_table
    scoped_customers = self.joins(:profile).where(customers[:email].matches(query_term)\
      .or(profile[:first_name].matches(query_term))\
      .or(profile[:last_name].matches(query_term))\
      .or(profile[:first_title].matches(query_term))\
      .or(profile[:second_title].matches(query_term))\
      .or(profile[:first_address].matches(query_term))\
      .or(profile[:second_address].matches(query_term))\
      .or(profile[:country].matches(query_term))\
      .or(profile[:city].matches(query_term))\
      .or(profile[:state].matches(query_term))\
      .or(profile[:zip].matches(query_term))\
      .or(profile[:phone_o].matches(query_term))\
      .or(profile[:phone_c].matches(query_term))\
    )
  end
end
