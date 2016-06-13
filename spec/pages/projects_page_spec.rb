require 'rails_helper'

feature 'Project', js: true, type: :feature do
  let(:admin) { create :admin }
  let(:customer){ create :customer, sales: admin }
  let(:project){ create :project, customer: customer, sales: admin }

  before do
    login_as admin
  end

  context '#index' do
    let(:projects_page) { ProjectsPage.new }

    before do
      projects_page.load
    end

    it { expect(projects_page.search_area_visible?).to be_truthy }
    it { expect(projects_page.status_links_visible?).to be_truthy }
    it { expect(projects_page.has_projects_area?).to be_falsey }
  end

  context '#create' do
    let(:new_project_page) { ProjectNewPage.new }

    before do
      new_project_page.load
    end

    it { expect(new_project_page.project_form_visible?).to be_truthy }

    it 'item form verify' do
      new_project_page.add_support_items.click
      expect(new_project_page.has_item_form?).to be_truthy
    end

    it 'allow to create project' do
      page.execute_script("$('#project_customer_id').val('#{customer.id}')")
      page.execute_script("$('#project_sales_id').val('#{customer.sales_id}')")
      new_project_page.submit_btn.click
      expect(page).to have_link(customer.email)
    end

    it 'show validation error' do
      new_project_page.submit_btn.click
      expect(new_project_page.has_errors?).to be_truthy
    end
  end

  context '#edit' do
    let(:customer2){ create :customer, sales: admin }
    let(:project_edit_page) { ProjectEditPage.new }
    before do
      project_edit_page.load(pid: project.id)
    end

    it { expect(project_edit_page.project_form_visible?).to be_truthy }
    it 'allow to update project' do
      page.execute_script("$('#project_customer_id').val('#{customer2.id}')")
      project_edit_page.submit_btn.click
      expect(page).to have_link(customer2.email)
    end
  end

  context '#page' do
    let(:project_page) { ProjectInfoPage.new }

    it 'validate' do
      project_page.load(pid: project.id)
      expect(project_page).to have_link(customer.email)
      expect(project_page.nav_btn_visible?).to be_truthy
    end

    it 'delete' do
      project_page.load(pid: project.id)
      project_page.delete_btn.click
      expect(page).to have_no_content(project.customer_email)
    end

    context '#versions' do
      context 'quote -> proposal' do
        let(:quote){ create :project, customer: customer, sales: admin }

        it 'create' do
          project_page.load(pid: quote.id)
          project_page.make_propose_btn.click
          expect(project_page.project_version.text).to eq('(1 version)')
        end
      end

      context 'restore' do
        let!(:setting) { create :unit_setting, :width_multiplicity }
        let!(:setting2) { create :setting, :price_matrix }
        let!(:quote){ create :project, customer: customer, sales: admin,
                              curtains: [create(:curtain, quantity: 1)] }
        it 'create' do
          project_page.load(pid: quote.id)
          project_page.make_propose_btn.click
          project_page.edit_btn.click
          fill_in 'project_discount', with: 99
          click_button 'Update Project'
          expect(page).to have_link('(2 versions)')
          project_page.edit_btn.click
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
      let(:order){ create :project, customer: customer, sales: admin, state: 'orders' }
      let(:in_process){ create :project, customer: customer, sales: admin, state: 'in_process' }
      let(:closed){ create :project, customer: customer, sales: admin, state: 'closed' }

      it 'quotes' do
        project_page.load(pid: quote.id)
        expect(project_page.state.text).to eq('Status: quotes')
        expect(page).to have_button('Make propose')
        expect(project_page.has_edit_btn?).to be_truthy
        project_page.edit_btn.click
        expect(page).to have_no_content('Calculated price')
      end

      it 'propose' do
        project_page.load(pid: propose.id)
        expect(project_page.state.text).to eq('Status: proposals')
        expect(page).to have_button('Make ordered')
        expect(page).to have_button('Make quoted')
        expect(project_page.has_prepare_email_btn?).to be_truthy
        expect(project_page.has_edit_btn?).to be_truthy
        project_page.edit_btn.click
        expect(page).to have_content('Calculated price')
      end

      it 'ordered' do
        project_page.load(pid: order.id)
        expect(project_page.state.text).to eq('Status: orders')
        expect(page).to have_button('Make active')
        expect(project_page.has_prepare_email_btn?).to be_falsey
        expect(page).to have_content('Support items')
        expect(page).to have_link('Create Drapery Task')
        expect(page).to have_link('Create Trough Task')
        expect(page).to have_content(order.customer_number)
        expect(page).to have_content(order.sales_number)
        expect(project_page.has_edit_btn?).to be_truthy
        project_page.edit_btn.click
        expect(page).to have_content('Calculated price')
      end

      it 'in process' do
        project_page.load(pid: in_process.id)
        expect(project_page.state.text).to eq('Status: in_process')
        expect(page).to have_button('Make close')
        expect(project_page.has_prepare_email_btn?).to be_falsey
        expect(page).to have_content('Support items')
        expect(page).to have_content(in_process.customer_number)
        expect(page).to have_content(in_process.sales_number)
        expect(project_page.has_edit_btn?).to be_falsey
      end

      it 'closed' do
        project_page.load(pid: closed.id)
        expect(project_page.state.text).to eq('Status: closed')
        expect(project_page.has_prepare_email_btn?).to be_falsey
        expect(page).to have_content('Support items')
        expect(page).to have_content(closed.customer_number)
        expect(page).to have_content(closed.sales_number)
        expect(project_page.has_edit_btn?).to be_falsey
      end
    end

    context '#proposal email' do
      let(:proposal){ create :project, customer: customer, sales: admin, state: 'proposals' }
      let(:curtain) { create :curtain, project: project, room: 15  }
      let(:project_email_page) { ProjectEmailPage.new }

      it 'allow to prepare email' do
        project_page.load(pid: proposal.id)
        expect(project_page.has_prepare_email_btn?).to be_truthy
      end

      it 'show email body' do
        project_email_page.load(pid: proposal.id)
        sleep 1
        within_frame 0 do
          expect(project_email_page.has_curtains_table?).to be_truthy
          expect(page).to have_content(curtain.room)
        end
      end

      it 'allow send email' do
        project_email_page.load(pid: proposal.id)
        project_email_page.submit_btn.click
        expect(project_email_page.has_alert_success?).to be_truthy
      end
    end
  end

  context 'Tasks' do
    let(:ordered){ create :project, customer: customer, sales: admin, state: 'orders' }
    let!(:curtain) { create :curtain, project: ordered, room: 'curtain1', width: 30, height: 30, metric: 'Imperial' }
    let!(:curtain2) { create :curtain, project: ordered, room: 'curtain2', width: 60, height: 40, metric: 'Imperial' }
    let(:project_page) { ProjectInfoPage.new }

    before do
      project_page.load(pid: ordered.id)
    end

    it 'create worksheet for drapery' do
      project_page.create_drapery_task_btn.click
      project_page.submit_btn.click
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
