module FillFormsHelpers
  include ManufacturerHelpers
  include ProjectHelpers
  include TaskHelpers

  def click_topic_navbar_link link_title
    within '.navbar-static-top' do
      click_link link_title
    end
  end

  def have_price_with_currency price, currency = '$'
    expect(page).to have_content "#{currency}#{price}"
  end

  def create_customer email
    visit new_customer_path

    fill_in 'customer_email', with: email
    click_button 'Create Customer'
    expect(page).to have_content(email)
  end

  def add_curtains project, options
    have_buttons_within '.possible_actions', 'Make propose'
    click_link 'Add curtain'
    fill_in 'curtain_width', with: options[:width]
    fill_in 'curtain_height', with: options[:height]
    fill_in 'curtain_quantity', with: options[:quantity]
    click_button 'Create Curtain'

    within 'table.curtains tbody' do
      expect(page).to have_selector 'tr', count: 2
      expect(page).to have_content "#{options[:width].to_f} in"
      expect(page).to have_content "#{options[:width] * 2.54} cm"
      expect(page).to have_content options[:quantity]
      have_price_with_currency project.curtains_price
    end

    have_price_with_currency project.calculated_price
    installation_item = project.items.auto_created.first

    within all('table.support-items tr:nth-last-child(2)').last do
      expect(page).to have_selector('td', count: 6)

      expect(page).to have_content installation_item.name
      expect(page).to have_content installation_item.unit
      expect(page).to have_content installation_item.quantity
      expect(page).to have_content installation_item.price
      expect(page).to have_content installation_item.price * installation_item.quantity
      expect(installation_item.price).to eql(Setting.installation_price)

      have_price_with_currency installation_item.price
    end
  end
end
