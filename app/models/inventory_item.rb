class InventoryItem < ActiveRecord::Base
  belongs_to :manufacturer
  has_many :inventory_history_items, dependent: :destroy

  before_create :set_first_adition

  validates :name, presence: true, uniqueness: { scope: :manufacturer_id }
  validates :amount, on: :create, numericality: { greater_than: 0 }

  before_validation :prepare_name

  attr_accessor :amount

  def set_first_adition
    return if self.amount.to_f <= 0
    self.inventory_history_items.build event: 'addition',
                                       whodunnit: AuthorizationData.current_user.try(:id),
                                       amount: self.amount
  end

  def additions
    self.inventory_history_items.additions.select('SUM(amount) as amount')[0].amount.to_f
  end

  def deletions
    self.inventory_history_items.deletions.select('SUM(amount) as amount')[0].amount.to_f
  end

  def balance
    (additions - deletions).round(2)
  end

  private
  def prepare_name
    self.name = self.name.downcase
  end
end
