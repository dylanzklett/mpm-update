require_relative '../general_page'

class UserInfoPage < GeneralPage

  set_url '/admin/users{/uid}'

  element :back_usr, :xpath, "//div[@class='col-sm-offset-1 col-sm-10']/a[text()='Back']"
  element :edit_usr, :xpath, "//div[@class='col-sm-offset-1 col-sm-10']/a[text()='Edit']"
  element :delete_usr, :xpath, "//div[@class='col-sm-offset-1 col-sm-10']/a[text()='Delete']"

  element :recent_projects, :xpath, "//table[@class='table table-striped']"
  element :delete_project, :xpath, "//table[@class='table table-striped']//a[contains(text(),'Delete')]"

  def user_buttons_visible?
    all_visible? :back_usr, :edit_usr, :delete_usr
  end
end
