require_relative '../general_page'

class UsersPage < GeneralPage

  set_url '/admin/users'

  element :users_table, '.table.table-striped'

  element :edit_user, :xpath, "//table[@class='table table-striped']//a[contains(text(), 'Edit')]"
  element :delete_user, :xpath, "//table[@class='table table-striped']//a[contains(text(), 'Delete')]"
end
