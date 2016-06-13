class Service < ActiveRecord::Base
  belongs_to :manufacturer
  validates :price, numericality: { greater_than: 0 }
end
