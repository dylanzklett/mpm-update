require 'rails_helper'

feature 'Projects', js: true, type: :feature do
  let(:admin){ create :admin }
  let(:customer){ create :customer, sales: admin }
  let!(:customer2){ create :customer, sales: admin }
  let(:project){ create :project, customer: customer, sales: admin, customer_number: 12345, sales_number: 54321 }
  let!(:curtain) { create :curtain, project: project, room: 15  }

  before do
    login_as admin
  end

  context '#index' do
    before do
      visit projects_path
    end

    it { expect(page).to have_content('Projects') }
    it { expect(page).to have_content(curtain.room) }
    it { expect(page).to have_content(project.customer_email) }
  end

  context '#create' do
    before do
      visit new_project_path
    end

    it 'allow to create project' do
      page.execute_script("$('#project_customer_id').val('#{customer.id}')")
      page.execute_script("$('#project_sales_id').val('#{customer.sales_id}')")
      click_button 'Create Project'
      expect(page).to have_link(customer.email)
    end

    it 'show validation error' do
      click_button 'Create Project'
      expect(page).to have_content('Customer can\'t be blank')
    end
  end

  context '#edit' do
    before do
      visit edit_project_path(project)
    end

    it { expect(page).to have_field('customer_autocomplete') }
  end

  context '#update' do
    before do
      visit edit_project_path(project)
    end

    it 'allow to update project' do
      page.execute_script("$('#project_customer_id').val('#{customer2.id}')")
      click_button 'Update Project'
      expect(page).to have_link(customer2.email)
    end

    it 'show validation error' do
      page.execute_script("$('#project_customer_id').val('')")
      click_button 'Update Project'
      expect(page).to have_content('Customer can\'t be blank')
    end
  end

  context '#show' do
    before do
      visit project_path(project)
    end

    it { expect(page).to have_content(curtain.room) }
  end

  context '#versions' do
    context 'quote -> proposal' do
      let(:quote){ create :project, customer: customer, sales: admin }

      it 'create' do
        visit project_path(quote)
        click_button('Make propose')
        expect(page).to have_link('(1 version)')
      end
    end

    context 'restore' do
      let!(:setting) { create :unit_setting, :width_multiplicity }
      let!(:setting2) { create :setting, :price_matrix }
      let(:quote){ create :project, customer: customer, sales: admin,
                          curtains: [
                            create(:curtain, quantity: 20)
                          ]
                  }
      it 'create' do
        visit project_path(quote)
        click_button('Make propose')
        within 'div.actions' do
          click_link 'Edit'
        end
        fill_in 'project_discount', with: 99
        click_button 'Update Project'
        expect(page).to have_link('(2 versions)')
        within 'div.actions' do
          click_link 'Edit'
        end
        fill_in 'project_discount', with: 50
        click_button 'Update Project'
        click_link('(3 versions)')
        click_link("##{quote.id}A")
        click_link('Restore')
        expect(page).to have_content('99.0 %')
        expect(page).to have_no_content('50.0 %')
        click_link('(4 versions)')
        expect(page).to have_content("Restore ##{quote.id}a")
      end
    end
  end

  context '#state' do
    let(:quote){ create :project, customer: customer, sales: admin }
    let(:propose){ create :project, customer: customer, sales: admin, state: 'proposals' }
    let(:order){ create :project, customer: customer, sales: admin, state: 'orders', customer_number: 12345, sales_number: 54321 }
    let(:in_process){ create :project, customer: customer, sales: admin, state: 'in_process', customer_number: 12345, sales_number: 54321 }
    let(:closed){ create :project, customer: customer, sales: admin, state: 'closed', customer_number: 12345, sales_number: 54321 }

    it 'quote' do
      visit project_path(quote)
      expect(page).to have_button('Make propose')
      within 'div.actions' do
        expect(page).to have_link('Edit')
        click_link 'Edit'
      end
      expect(page).to have_no_content('Calculated price')
    end

    it 'propose' do
      visit project_path(propose)
      expect(page).to have_button('Make ordered')
      within 'div.actions' do
        expect(page).to have_link('Edit')
        click_link 'Edit'
      end
      expect(page).to have_content('Calculated price')
    end

    it 'order' do
      visit project_path(order)
      expect(page).to have_button('Make active')
      expect(page).to have_no_link('Send Email')
      expect(page).to have_content('Support items')
      expect(page).to have_link('Create Drapery Task')
      expect(page).to have_link('Create Trough Task')
      expect(page).to have_content(order.customer_number)
      expect(page).to have_content(order.sales_number)
      within 'div.actions' do
        expect(page).to have_link('Edit')
        click_link 'Edit'
      end
      expect(page).to have_content('Calculated price')
    end

    it 'in_process' do
      visit project_path(in_process)
      expect(page).to have_button('Make close')
      expect(page).to have_no_link('Send Email')
      expect(page).to have_content('Support items')
      expect(page).to have_content(in_process.customer_number)
      expect(page).to have_content(in_process.sales_number)
      within 'div.actions' do
        expect(page).to have_no_link('Edit')
      end
    end

    it 'closed' do
      visit project_path(closed)
      expect(page).to have_no_link('Send Email')
      expect(page).to have_content('Support items')
      expect(page).to have_content(closed.customer_number)
      expect(page).to have_content(closed.sales_number)
      within 'div.actions' do
        expect(page).to have_no_link('Edit')
      end
    end
  end

  context '#proposal email' do
    let(:project){ create :project, customer: customer, sales: admin, state: 'proposals' }
    let!(:curtain) { create :curtain, project: project, room: 15  }

    before do
      visit project_path(project)
    end

    it 'allow to prepare email' do
      expect(page).to have_link('Prepare Email')
    end

    it 'show email body' do
      visit new_project_email_path(project)
      sleep 1
      within_frame 0 do
        expect(page).to have_css('.curtains')
        expect(page).to have_content(curtain.room)
      end
    end

    it 'allow send email' do
      visit new_project_email_path(project)
      click_button 'Send Email'
      expect(page).to have_content('Proposal has been sent')
    end
  end

  context '#destroy' do
    before do
      visit project_path(project)
    end

    it 'allow to destroy project' do
      within '.actions' do
        click_link 'Delete'
      end
      expect(page).to have_no_content(project.customer_email)
    end
  end

  context 'Tasks' do
    let(:project){ create :project, customer: customer, sales: admin, state: 'orders' }
    let!(:curtain) { create :curtain, project: project, room: 'curtain1', width: 30, height: 30, metric: 'Imperial' }
    let!(:curtain2) { create :curtain, project: project, room: 'curtain2', width: 60, height: 40, metric: 'Imperial' }

    before do
      visit project_path(project)
    end

    it 'create worksheet for drapery' do
      click_link 'Create Drapery Task'
      click_button 'Create Drape task'
      expect(page).to have_link('Labels')
      expect(page).to have_content(curtain.room)
      expect(page).to have_content(curtain2.room)
    end

    it 'create worksheet for trough' do
      click_link 'Create Trough Task'
      click_button 'Create Trough task'
      expect(page).to have_link('Labels')
      expect(page).to have_content(curtain.room)
      expect(page).to have_content(curtain2.room)
    end
  end
end
