require_relative '../general_page'

class CustomersPage < GeneralPage

  set_url '/customers'

  element :customers_table, '.table.table-striped'

  element :edit_cus, :xpath, "//table[@class='table table-striped']//a[contains(text(), 'Edit')]"
  element :delete_cus, :xpath, "//table[@class='table table-striped']//a[contains(text(), 'Delete')]"
end
