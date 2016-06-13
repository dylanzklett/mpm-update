require_relative '../general_page'

class InventoryNewPage < GeneralPage

  set_url '/manufacturers{/mid}/inventory_items/new'

  element :name, '#inventory_item_name'
  element :description, '#inventory_item_description'
  element :unit, '#inventory_item_unit'
  element :amount, '#inventory_item_amount'

  def form_visible?
    all_visible? :name, :description, :unit
  end
end
