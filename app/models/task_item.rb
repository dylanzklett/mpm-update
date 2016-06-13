class TaskItem < ActiveRecord::Base
  include UnitConverter
  belongs_to :task

  validates :width, presence: true
  validates :height, presence: true
  validates :quantity, presence: true

  before_validation :populate_calculated_fields

  attr_accessor :height_in, :width_in, :finished_length_in

  def width_in=(width_in)
    attribute_will_change!(:width)
    @width_in = width_in
    self.width  = converting(width_in, 'in', 'mm') if width_in
  end

  def height_in=(height_in)
    attribute_will_change!(:height)
    @height_in = height_in
    self.height = converting(height_in, 'in', 'mm') if height_in
  end

  def finished_length_in=(finished_length_in)
    attribute_will_change!(:finished_length)
    @finished_length_in = finished_length_in

    if finished_length_in
      self.finished_length = converting(finished_length_in, 'in', 'mm')
    else
      self.finished_length = converting(height_in, 'in', 'mm') * 2 if height_in
    end
  end


  def model_code
    row = (height/Setting.get_devider).ceil
    col = (width/Setting.get_devider).ceil

    first_num = (col * Unit(Setting.width_multiplicity).convert_to('in').scalar).to_i
    second_num = (row * Unit(Setting.width_multiplicity).convert_to('in').scalar).to_i

    "SDCW#{first_num}#{second_num}"
  end

  def populate_calculated_fields
    finished_length_in = converting(self.finished_length.to_f, 'mm', 'in')

    self.calculated_fabric   = ((finished_length_in + 18)/36) * self.width_per_curt.to_f * quantity
    self.calculated_weight   = 60/36 * self.width_per_curt.to_f * quantity
    self.calculated_labor    = self.width_per_curt.to_f * quantity
    self.calculated_shirring = self.calculated_weight
    self.calculated_tape     = ((finished_length_in + 18)/36) * (self.width_per_curt.to_f + 1) * quantity
  end
end
