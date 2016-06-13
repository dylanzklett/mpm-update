require_relative '../general_page'

class CustomerNewPage < GeneralPage

  set_url '/customers/new'

  #buttons
  element :with_project_btn, 'input[name="with_project"]'

  # customer create form
  element :customer_email, '#customer_email'
  element :first_name, '#customer_profile_attributes_first_name'
  element :last_name, '#customer_profile_attributes_last_name'
  element :first_title, '#customer_profile_attributes_first_title'
  element :second_title, '#customer_profile_attributes_second_title'
  element :first_address, '#customer_profile_attributes_first_address'
  element :second_address, '#customer_profile_attributes_second_address'
  element :city, '#customer_profile_attributes_city'
  element :state, '#customer_profile_attributes_state'
  element :zip, '#customer_profile_attributes_zip'
  element :phone_o, '#customer_profile_attributes_phone_o'
  element :phone_c, '#customer_profile_attributes_phone_c'

  # Dropdown!
  element :sales_dropdown, '#customer_sales_id'

  def customer_form_visible?
    all_visible? :customer_email, :first_name, :last_name, :first_title, :second_title, :first_address,
                 :second_address, :city, :state, :zip, :phone_o, :phone_c, :sales_dropdown
  end
end
