require_relative '../general_page'

class UserChangePasswordPage < GeneralPage

  set_url '/users{/uid}/change_password/edit'

  element :password, '#user_password'
  element :password_confirmation, '#user_password_confirmation'

  def change_password_to(password, confirmation)
    self.password.set(password)
    self.password_confirmation.set(confirmation)
    submit_btn.click
  end
end
