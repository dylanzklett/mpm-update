require_relative '../general_page'

class ManufacturerNewPage < GeneralPage

  set_url '/manufacturers/new'

  element :man_title,   '#manufacturer_title'
  element :man_type,    '#manufacturer_manufacturer_type' # select
  element :dr_man,      'option[value="trough"]'
  element :tr_man,      'option[value="drape"]'
  element :man_email,   '#manufacturer_email'
  element :man_phone,   '#manufacturer_phone'
  element :man_address, '#manufacturer_address'

  def form_visible?
    all_visible? :man_title, :man_type, :man_email, :man_phone, :man_address
  end
end
