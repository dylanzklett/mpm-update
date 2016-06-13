module ProjectHelpers
  def expect_project_has_state state
    expect(page).to have_content "Status: #{state}"
  end

  def have_buttons_within(context, *button_labels)
    within context do
      expect(page).to have_selector '.btn', count: button_labels.count
      button_labels.each { |label| expect(page).to have_selector(:link_or_button, label) }
    end
  end

  def create_project customer_email
    click_topic_navbar_link 'Projects'
    click_link 'New'

    customer = Customer.find_by email: customer_email
    page.execute_script("$('#project_customer_id').val('#{customer.id}')")
    page.execute_script("$('#project_sales_id').val('#{customer.sales_id}')")
    fill_in 'Discount', with: 30
    click_button 'Create Project'

    expect(page).to have_link(customer.email)
    expect_project_has_state 'quotes'
    have_buttons_within '.possible_actions', 'Make propose'
    expect(page).to_not have_selector('table.related-tasks')

    Project.last
  end

  def send_proposal_email project, curtain_data, customer_email
    click_link 'Prepare Email'
    sleep 1
    have_buttons_within '.actions', 'Send Email', 'Cancel'

    within_frame 0 do
      expect(page).to have_content customer_email

      item_lines         = project.items.count
      curtains_lines     = project.curtains.count
      curtain_total_line = 1
      items_header_line  = 1
      project_total_line = 1
      discount_total_line = 1

      total_tr_count = item_lines + curtains_lines + curtain_total_line + project_total_line + items_header_line + discount_total_line

      within 'table.curtains tbody' do
        expect(page).to have_selector 'tr', count: total_tr_count
        expect(page).to have_content "#{curtain_data[:width].to_f} in"
        expect(page).to have_content project.curtains_price
        expect(page).to have_content project.calculated_price
        expect(page).to have_content project.curtains_discounted
        expect(page).to have_content project.curtains_discount
        expect(page).to have_content Setting.installation_price
      end
    end

    click_button 'Send Email'
    expect(page).to have_content 'Proposal has been sent'
  end

  def add_discount_to_project project
    within '.actions' do
      click_link_or_button 'Edit'
    end

    fill_in 'project_discount', with: '50'
    click_link_or_button 'Update Project'
    expect(page).to have_content 'Discount on Product: 50.0 %'
    have_price_with_currency project.reload.calculated_price
  end

  def expect_project_has_second_version
    expect(page).to have_link '2 versions'
    click_link '2 versions'

    expect(page).to have_content 'Previous Versions'
    click_link 'Back'
  end

  def add_manual_support_items project
    within '.actions' do
      click_link_or_button 'Edit'
    end

    click_link 'Add Item'
    within all('p.fields').last do
      fill_in 'Name', with: 'Manual item'
      fill_in 'Unit', with: 'foot'
      fill_in 'Quantity', with: '2'
      fill_in 'Price', with: '10'
    end

    click_button 'Update Project'
    expect(page).to have_content 'Project was successfully updated'

    within 'table.support-items tbody' do
      expect(page).to have_content 'Manual item'
      expect(page).to have_content 'foot'
      expect(page).to have_content '2'
      expect(page).to have_content '10'
    end

    expect(page).to have_content project.reload.calculated_price
  end
end
