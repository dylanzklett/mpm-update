module ManufacturerHelpers
  def create_drype_manufacturer_with_services email, services_array
    click_topic_navbar_link 'Manufacturers'

    manufacturer_title = 'Drapery'
    create_manufacturer email, manufacturer_title
    click_link manufacturer_title if page.has_link? manufacturer_title

    create_services services_array
  end

  def create_trough_manufacturer_with_services email, services_array
    click_topic_navbar_link 'Manufacturers'

    manufacturer_title = 'Trough'
    create_manufacturer email, manufacturer_title
    click_link manufacturer_title if page.has_link? manufacturer_title

    create_services services_array
  end

  def create_service fields
    click_link 'Add service'

    fill_in 'service_name', with: fields[:name]
    fill_in 'service_price', with: fields[:price]
    click_button 'Create Service'
    expect(page).to have_content fields[:name]
  end

  def create_services services_array
    services_array.each { |service_fields| create_service service_fields }
  end

  def create_manufacturer email, type
    expect(current_path).to eq manufacturers_path
    click_link 'New'

    fill_in 'manufacturer_title', with: "#{type} manufacturer"
    fill_in 'manufacturer_email', with: email
    select type, from: 'manufacturer_manufacturer_type'

    click_button 'Create Manufacturer'
    expect(page).to have_content(type)
    expect(page).to have_content(email)
  end
end
