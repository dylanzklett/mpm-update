require_relative '../general_page'

class ManufacturerInfoPage < GeneralPage

  set_url '/manufacturers{/mid}'

  # inventory
  element :inventory_table, :xpath, "//table[@class='table table-striped inventory-items']"
    element :inv_adds, :xpath, "//table[1]/tbody/tr[1]/td[4]"
    element :inv_dels, :xpath, "//table[1]/tbody/tr[1]/td[5]"
    element :inv_bal, :xpath, "//table[1]/tbody/tr[1]/td[6]"
  element :add_item, :xpath, "//h1/a[contains(text(),'Add Item')]"

    # item history buttons
  element :i_history, :xpath, "//table[@class='table table-striped inventory-items']//a[contains(text(),'History')]"
  element :i_edit, :xpath, "//table[@class='table table-striped inventory-items']//a[contains(text(),'Edit')]"
  element :i_add, :xpath, "//table[@class='table table-striped inventory-items']//a[contains(text(),'Add items')]"
  element :i_deduct, :xpath, "//table[@class='table table-striped inventory-items']//a[contains(text(),'Deduct items')]"
  element :i_delete, :xpath, "//table[@class='table table-striped inventory-items']//a[contains(text(),'Delete')]"

  # services
  element :service_table, :xpath, "//table[@class='table table-striped services']"
  element :add_service, :xpath, "//h1/a[contains(text(),'Add service')]"

  element :s_edit, :xpath, "//table[@class='table table-striped services']//a[contains(text(),'Edit')]"
  element :s_edit, :xpath, "//table[@class='table table-striped services']//a[contains(text(),'Delete')]"

  element :back_man, :xpath, "html/body/div[2]/div/div/a[1]"
  element :edit_man, :xpath, "html/body/div[2]/div/div/a[2]"
  element :delete_man, :xpath, "html/body/div[2]/div/div/a[3]"

  def man_visible?
    all_visible? :inventory_table, :add_item, :service_table, :add_service, :back_man, :edit_man, :delete_man
  end
end
