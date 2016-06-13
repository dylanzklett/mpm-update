require_relative 'user_new_page'

class UserEditPage < UserNewPage

  set_url '/admin/users{/uid}/edit'
end
