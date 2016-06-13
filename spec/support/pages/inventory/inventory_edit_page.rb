require_relative 'inventory_new_page'

class InventoryEditPage < InventoryNewPage

  set_url '/manufacturers{/mid}/inventory_items{/iid}/edit'

end
