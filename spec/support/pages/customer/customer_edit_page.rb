require_relative 'customer_new_page'

class CustomerEditPage < CustomerNewPage

  set_url '/customers{/cid}/edit'
end
