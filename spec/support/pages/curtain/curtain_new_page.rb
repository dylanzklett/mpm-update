require_relative '../general_page'

class CurtainNewPage < GeneralPage

  set_url '/projects{/pid}/curtains/new'

  element :metric_system, '#curtain_metric'
  element :building_number, '#curtain_building_number'
  element :room, '#curtain_room'
  element :width, '#curtain_width'
  element :height, '#curtain_height'
  element :inside, '#curtain_inside'
  element :wall_type, '#curtain_wall_type'
  element :fabric_color, '#curtain_fabric_color'
  element :trough_color, '#curtain_trough_color'
  element :center_support, '#curtain_center_support'
  element :end_bracket, '#curtain_end_bracket'
  element :quantity, '#curtain_quantity'

  def form_visible?
    all_visible? :metric_system, :building_number, :room, :width, :height, :inside, :wall_type,
                 :fabric_color, :trough_color, :center_support, :end_bracket, :quantity
  end
end
