require_relative 'general_page'

class ProfilePage < GeneralPage

  set_url '/profile/edit'

  element :change_password, :xpath, "//a[contains(text(),'Change password')]"

  #User info form
  element :user_email, '#user_email'
  element :first_name, '#user_profile_attributes_first_name'
  element :last_name, '#user_profile_attributes_last_name'
  element :title, '#user_profile_attributes_first_title'
  element :company_name, '#user_profile_attributes_second_title'
  element :first_address, '#user_profile_attributes_first_address'
  element :second_address, '#user_profile_attributes_second_address'
  element :country, '#user_profile_attributes_country' #default == 'USA'
  element :city, '#user_profile_attributes_city'
  element :state, '#user_profile_attributes_state'
  element :zip, '#user_profile_attributes_zip'
  element :office_phone, '#user_profile_attributes_phone_o'
  element :cell_phone, '#user_profile_attributes_phone_c'

  def user_form_visible?
    all_visible? :user_email, :first_name, :last_name, :title, :company_name, :first_address,
                 :second_address, :country, :city, :state, :zip, :office_phone, :cell_phone
  end
end
