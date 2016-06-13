require_relative '../profile_page'

class UserNewPage < ProfilePage

  set_url '/admin/users/new'

  element :password, '#user_password'
  element :password_confirmation, '#user_password_confirmation'
  element :rep_number, '#user_rep_number'
  element :admin_box, '#user_admin'

  def admin_fields_visible?
    all_visible? :rep_number, :admin_box
  end
end
