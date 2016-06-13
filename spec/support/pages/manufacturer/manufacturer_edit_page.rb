require_relative 'manufacturer_new_page'

class ManufacturerEditPage < ManufacturerNewPage

  set_url '/manufacturers{/mid}/edit'
end
