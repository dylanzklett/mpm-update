require_relative 'general_page'

class LoginPage < GeneralPage

  set_url '/users/sign_in'

    #login_form
    element :email, '#user_email'
    element :password, '#user_password'
    element :remember, '#user_remember_me'
    element :forgot_password, :xpath, "//a[contains(@href, '/users/password/new')]"

  def login_with(email, password)
    self.email.set(email)
    self.password.set(password)
    submit_btn.click
  end

  def login_form_visible?
    all_visible? :email, :password, :submit_btn, :remember, :remember, :forgot_password
  end
end
