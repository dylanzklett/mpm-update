class Setting < ActiveRecord::Base
  INLINE = %w[fabric_color trough_color center_support end_bracket width_multiplicity installation_price trough_step]

  scope :inline, lambda{ where(code: INLINE) }

  has_many :items, dependent: :destroy
  accepts_nested_attributes_for :items

  def items
    JSON.parse(value).map do |item_attrs|
      Item.new item_attrs
    end
  end

  def items_attributes=(attrs)
    self.value = attrs.reject{|_, val| val['_destroy'] == '1' }.values.
                       map{|val| val.permit(:name, :quantity, :price, :unit,) }.to_json
  end

  def convert_for_show
    self.value
  end

  def convert_to(to)
    Unit(self.value).convert_to(to).scalar.to_f
  end

  class << self
    def fabric_color
      get_array_vals 'fabric_color'
    end

    def trough_color
      get_array_vals 'trough_color'
    end

    def center_support
      get_array_vals 'center_support'
    end

    def end_bracket
      get_array_vals 'end_bracket'
    end

    def width_multiplicity
      get_val 'width_multiplicity'
    end

    def installation_price
      get_val('installation_price').to_f
    end

    def trough_step
      get_val('trough_step')
    end

    def multiplicity_items
      find_by_code('multiplicity_items')
    end

    def price_matrix
      find_by_code('price_matrix')
    end

    def trough_matrix
      find_by_code('trough_matrix')
    end

    def get_by(code)
      find_by_code code
    end

    def price_for(width, height)
      devider = get_devider
      row = (height/devider).ceil
      col = (width/devider).ceil

      JSON.parse(self.price_matrix.value)["#{row},#{col}"].to_s.gsub(',', '.').to_f.round(2)
    end

    def trough_for(width, height)
      row = (height/get_devider).ceil
      col = self.trough_step.split(',').index{|step| step.strip.to_f >= Unit("#{width} mm").convert_to('in').scalar.to_f }.to_i + 1

      JSON.parse(self.trough_matrix.value)["#{row},#{col}"].to_s
    end

    def get_devider
      Unit(self.width_multiplicity).convert_to('mm').scalar.to_f
    end
  end

  private

  def self.get_array_vals(code)
    find_by_code(code).value.split(',').map(&:strip)
  end

  def self.get_val(code)
    find_by_code(code).value.strip
  end

end
