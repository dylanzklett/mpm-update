class Item < ActiveRecord::Base
  belongs_to :project

  validates :name, presence: true

  validates :quantity, :price,
            numericality: { greater_than: 0 }

  scope :auto_created, lambda{ where(auto_create: true) }
  scope :non_auto_created, lambda{ where(auto_create: false) }

  def full_price
    quantity.to_f * price.to_f
  end
end
