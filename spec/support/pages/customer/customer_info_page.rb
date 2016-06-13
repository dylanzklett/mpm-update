require_relative '../general_page'

class CustomerInfoPage < GeneralPage

  set_url '/customers{/cid}'

  element :back_cus, :xpath, "//div[@class='col-sm-offset-1 col-sm-10']/a[text()='Back']"
  element :edit_cus, :xpath, "//div[@class='col-sm-offset-1 col-sm-10']/a[text()='Edit']"
  element :delete_cus, :xpath, "//div[@class='col-sm-offset-1 col-sm-10']/a[text()='Delete']"
  element :add_new_project, :xpath, "//form[@id='new_project']/input[@value='add new project']"

  element :recent_projects, :xpath, "//table[@class='table table-striped']"
  element :delete_project, :xpath, "//table[@class='table table-striped']//a[contains(text(),'Delete')]"

  def customer_buttons_visible?
    all_visible? :back_cus, :edit_cus, :delete_cus, :add_new_project
  end
end
