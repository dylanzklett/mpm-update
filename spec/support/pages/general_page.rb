class GeneralPage < SitePrism::Page

  # header
  element :projects, :xpath, "//a[contains(@href, '/projects')]" #'Projects'
  element :customers, :xpath, "//a[contains(@href, '/customers')]" #'Customers'
  element :manufacturers, :xpath, "//a[contains(@href, '/manufacturers')]" #'Manufacturers'
  element :tasks, :xpath, "//a[contains(@href, '/tasks')]" #'Outsourced tasks'
  element :profile, :xpath, "//a[contains(@href, '/profile/edit')]" #'Profile'
  element :logout, :xpath, "//a[contains(@href, '/sign_out')]" #'Logout'

  # admin
  element :admin_area, 'a.dropdown-toggle' #'Admins area'

  # layout
  element :logo, 'a.navbar-brand' #'MPM III'
  element :footer, 'p.text-muted'

  # alerts
  element :alert_success, '.alert.alert-success'
  element :alert_error, '.alert.alert-danger'
  element :alert_close, 'button.close'

  # buttons
  element :submit_btn, "input[name='commit']"
  element :cancel_btn, :xpath, "//a[contains(text(),'Cancel')]"

  element :back_btn, :xpath, "//div[@class='actions']/a[text()='Back']"
  element :edit_btn, :xpath, "//div[@class='actions']/a[text()='Edit']"
  element :delete_btn, :xpath, "//div[@class='actions']/a[text()='Delete']"
  element :prepare_email_btn, :xpath, "//a[contains(text(),'Prepare Email')]"

  element :error_block, 'div.has-error'

  def header_visible?
    header_items = [:projects, :customers, :manufacturers, :tasks, :profile, :logout]
    header_items.all? {|item| self.send(item).visible? }
  end

  def layout_visible?
    layout_item = [:logo, :footer]
    layout_item.all? { |item| self.send(item).visible? }
  end

  def admin?
    has_admin_area?
  end

  def has_errors?
    has_error_block?
  end

  private
  def all_visible?(*item_list)
    item_list.all? { |item| self.send(item).visible? }
  end

  def exists_on_page?(*items)
    items.all? {|item| self.send("has_#{item}?") }
  end
end
