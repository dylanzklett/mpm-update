require 'rails_helper'

feature 'User Flow', js: true, type: :feature do
  let!(:admin) { create :admin }

  before do
    login_as admin
  end

  context 'full user flow' do
    it 'should works correctly' do
      customer_email = 'customer@email.com'
      create_customer customer_email

      create_drype_manufacturer_with_services 'drapery@email.com', [{name: 'Drapery service', price: 20}]
      create_trough_manufacturer_with_services 'trough@email.com', [{name: 'A9-15', price: 12}, {name: 'A10-15', price: 17}]

      project = create_project customer_email

      curtain_data = { width: 15, height: 25, quantity: 2 }
      add_curtains project, curtain_data
      add_manual_support_items project

      click_button 'Make propose'
      expect_project_has_state 'proposals'
      have_buttons_within '.possible_actions', 'Make ordered', 'Make quoted', 'Prepare Email'
      send_proposal_email project, curtain_data, customer_email

      add_discount_to_project project
      expect_project_has_second_version

      click_button 'Make ordered'
      expect_project_has_state 'orders'
      have_buttons_within '.possible_actions', 'Make propose', 'Make active', 'Create Drapery Task', 'Create Trough Task'
      have_buttons_within '.actions', 'Back', 'Edit', 'Delete'

      create_through_task_for_project project, curtain_data
      create_drapery_task_for_project project, curtain_data

      click_button 'Make active'
      expect_project_has_state 'in_process'
      have_buttons_within '.possible_actions', 'Make ordered', 'Make close'
      have_buttons_within '.actions', 'Back', 'Delete'

      click_button 'Make close'
      expect_project_has_state 'closed'
      have_buttons_within '.actions', 'Back', 'Delete'
      have_buttons_within '.possible_actions', 'Make active'
    end
  end
end
