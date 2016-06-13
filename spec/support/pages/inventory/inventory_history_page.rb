require_relative '../general_page'

class InventoryHistoryPage < GeneralPage

  set_url '/inventory_items{/iid}/inventory_history_items'

  element :history_table, '.inventory-history-items'
    element :his_adds_1, :xpath, "//tbody/tr[1]/td[3]"
    element :his_dels_1, :xpath, "//tbody/tr[1]/td[4]"
    element :his_adds_2, :xpath, "//tbody/tr[2]/td[3]"
    element :his_dels_2, :xpath, "//tbody/tr[2]/td[4]"
    element :his_project_2, :xpath, "//tbody/tr[2]/td[5]"


  element :amount, '#inventory_history_item_amount' # Only 'event' pages
end
