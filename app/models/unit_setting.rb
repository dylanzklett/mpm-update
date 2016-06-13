class UnitSetting < Setting
  before_save :convert_for_save

  validates :value, format: { with: /\A\d+((\.|,)\d+)?\s*[a-zA-z]+\z/ }

  def convert_for_save
    self.value = Unit(self.value).convert_to('mm')
  end

  def convert_for_show
    num = Unit(self.value).convert_to('in').scalar.to_f.round(2)
    "#{num} in"
  end
end
