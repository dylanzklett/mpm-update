class Manufacturer < ActiveRecord::Base
  MANUFACTURER_TYPES = { drape: 'Drapery',
                         trough: 'Trough' }

  has_many :tasks, dependent: :nullify
  has_many :services, dependent: :destroy
  has_many :inventory_items, dependent: :destroy

  validates :email, uniqueness: true,
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :title, uniqueness: { presence: true }

  scope :draperies, lambda{ where(manufacturer_type: :drape) }
  scope :troughs, lambda{ where(manufacturer_type: :trough) }

  def get_type
    MANUFACTURER_TYPES[self.manufacturer_type.to_sym]
  end

  def price_for_width
    services.map(&:price).first
  end
end
