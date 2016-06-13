require_relative '../general_page'

class ManufacturersPage < GeneralPage

  set_url '/manufacturers'

  element :man_table, '.table.table-striped'

  element :edit_man, :xpath, "//a[contains(text(), 'Edit')]"
  element :delete_man, :xpath, "//a[contains(text(), 'Delete')]"
end
