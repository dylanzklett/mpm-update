class Curtain < ActiveRecord::Base
  include UnitConverter

  METRICS = %w(Imperial Metric)

  belongs_to :project

  validates :width, presence: true
  validates :height, presence: true
  validates :quantity, presence: true

  before_validation :convert_from_imperial

  before_save :calculate_price

  def inout
    inside ? 'Inside' : 'Outside'
  end

  def full_price
    (price * quantity)
  end

  def width_in(type)
    convert(:width, type)
  end

  def height_in(type)
    convert(:height, type)
  end

  def calculate_price
    self.price = Setting.price_for(self.width, self.height)
  end

  private
  def convert_from_imperial
    if self.metric == 'Imperial'
      self.width = converting(self.width, 'in', 'mm')
      self.height = converting(self.height, 'in', 'mm')
    end
    if self.metric == 'Metric'
      self.width = converting(self.width, 'cm', 'mm')
      self.height = converting(self.height, 'cm', 'mm')
    end
  end
end
