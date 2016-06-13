require_relative 'general_page'

class SettingsPage < GeneralPage

  set_url '/admin/settings'

  element :fabric_color,        '.fabric_color'
    element :fc_update,         :xpath, "//form[@id='edit_setting_1']//input[@name='commit']"

  element :trough_color,        '.trough_color'
   element :tc_update,          :xpath, "//form[@id='edit_setting_2']//input[@name='commit']"

  element :center_support,      '.center_support'
   element :cs_update,          :xpath, "//form[@id='edit_setting_3']//input[@name='commit']"

  element :end_bracket,         '.end_bracket'
    element :eb_update,         :xpath, "//form[@id='edit_setting_4']//input[@name='commit']"

  element :multiplicity,        '.width_multiplicity'
    element :m_update,          :xpath, "//form[@id='edit_unit_setting_5']//input[@name='commit']"

  element :installation_price,  '.installation_price'
    element :ip_update,         :xpath, "//form[@id='edit_setting_7']//input[@name='commit']"

  element :trough_step,         '.trough_step'
   element :ts_update,          :xpath, "//form[@id='edit_setting_9']//input[@name='commit']"

  element :add_item,    :xpath, "//a[contains(text(),'Add Item')]"
  element :i_name, :xpath, "//*[@placeholder='Name']"
  element :i_unit, :xpath, "//*[@placeholder='Unit']"
  element :i_qty,  :xpath, "//*[@placeholder='Quantity']"
  element :i_price, :xpath, "//*[@placeholder='Price']"
  element :i_remove, :xpath, "//a[contains(text(),'remove')]"
  element :i_update, :xpath, "//form[@id='edit_setting_6']//input[@name='commit']"

  def setting_values_visible?
    all_visible? :fabric_color, :trough_color, :center_support, :end_bracket,
                 :multiplicity, :installation_price, :trough_step
  end
end
