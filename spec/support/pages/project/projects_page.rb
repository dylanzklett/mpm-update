require_relative '../general_page'

class ProjectsPage < GeneralPage

  set_url '/projects'

  element :new_project, :xpath, "//a[contains(text(),'New')]"

  # search_area
  element :search_field, '#term'
  element :search_button, :xpath, "//input[@value='Search']"

  # links
  element :quotes_link, :xpath, "//a[contains(text(),'Quotes')]"
  element :proposals_link, :xpath, "//a[contains(text(),'Proposals')]"
  element :orders_link, :xpath, "//a[contains(text(),'Orders')]"
  element :in_process_link, :xpath, "//a[contains(text(),'In process')]"
  element :closed_link, :xpath, "//a[contains(text(),'Closed')]"

  # projects_area
  element :project_id_link, 'td > a'
  element :project_customer_link, 'div.email'
  element :project_value, :xpath, "//div[@id='quotes']/table/tbody/tr/td[3]"
  element :project_delete_link, :xpath, "//a[contains(text(),'Delete')]"

  def search_area_visible?
    all_visible? :search_field, :search_button
  end

  def status_links_visible?
    all_visible? :quotes_link, :proposals_link, :orders_link, :in_process_link, :closed_link
  end

  def has_projects_area?
    exists_on_page? :project_id_link, :project_customer_link, :project_value, :project_delete_link
  end
end
