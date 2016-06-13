require_relative '../general_page'

class ProjectNewPage < GeneralPage

  set_url '/projects/new'

  # Project create form
  element :customer_fld, '#customer_autocomplete'
  element :sales_fld, '#sales_autocomplete'
  element :discount_fld, '#project_discount'
  element :add_support_items, :xpath, "//a[contains(text(),'Add Item')]"

  # Item form
  element :item_fields, 'div.fields'
  element :item_remove, :xpath, "//a[contains(text(),'remove')]"
  element :item_name, :xpath, "//form[@id='new_project']/div[4]/p/input"
  element :item_unit, :xpath, "//form[@id='new_project']/div[4]/p/input[2]"
  element :item_qty, :xpath, "//form[@id='new_project']/div[4]/p/input[3]"
  element :item_price, :xpath, "//form[@id='new_project']/div[4]/p/input[4]"

  def project_form_visible?
    all_visible? :submit_btn, :cancel_btn, :customer_fld, :sales_fld, :discount_fld, :add_support_items
  end

  def has_item_form?
    exists_on_page? :item_fields, :item_name, :item_unit, :item_qty, :item_price, :item_remove
  end
end
