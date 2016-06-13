require 'rails_helper'

feature 'Tasks', js: true, type: :feature do
  let(:admin){ create :admin }
  let(:service) { create :service, price: 15.99 }
  let(:manufacturer) { create :manufacturer, services: [ service ] }
  let!(:task){ create :task, manufacturer: manufacturer }

  before do
    login_as admin
  end

  context '#index' do
    before do
      visit tasks_path
    end

    it { expect(page).to have_content(task.ship_to) }
    it { expect(page).to have_content(manufacturer.title) }
  end

  context '#create' do
    let(:attrs) {{
        ship_to: 'Name',
        date_wanted: Date.current + 3.days
    }}


    before do
      visit new_task_path
    end

    it 'allow to create task' do
      fill_in 'task_ship_to', with: attrs[:ship_to]
      fill_in 'task_date_wanted', with: attrs[:date_wanted]
      click_button 'Create Task'
      expect(page).to have_content(I18n.l(attrs[:date_wanted], format: :short))
    end
  end

  context "create project's task" do
    let(:project) { create :project, customer: create(:customer), sales: admin }
    let(:attrs) {{
      ship_to: 'Name',
      date_wanted: Date.current + 3.days
    }}

    before do
      visit new_project_drape_task_path(project)
    end

    it "redirect back to order for project's task" do
      fill_in 'Ship to', with: attrs[:ship_to]
      fill_in 'Date wanted', with: attrs[:date_wanted]
      click_button 'Create Drape task'
      expect(page).to have_content('Manufacturer')
      expect(page).to have_content('Ship to')
    end
  end

  context '#edit' do
    before do
      visit edit_task_path(task)
    end

    it { expect(page).to have_field('task_ship_to', with: task.ship_to) }
  end

  context '#update' do
    let!(:task) { create :task }

    let(:attrs) {{
        ship_to: 'Name',
        date_wanted: Date.current + 3.days
    }}

    before do
      visit edit_task_path(task)
    end

    it 'allow to update task' do
      fill_in 'Date wanted', with: attrs[:date_wanted]
      fill_in 'Ship to', with: attrs[:ship_to]
      click_button 'Update Task'
      expect(page).to have_content(I18n.l(attrs[:date_wanted], format: :short))
    end
  end

  context "update project's task" do
    let(:project) { create :project, customer: create(:customer), sales: admin }
    let!(:task) { create :task, project: project, type: 'DrapeTask' }

    before do
      visit edit_task_path(task)
    end

    it "redirect back to order for project's task" do
      click_button 'Update Drape task'
      expect(page).to have_content('Manufacturer')
      expect(page).to have_content('Ship to')
    end
  end

  context '#show' do
    before do
      visit task_path(task)
    end

    it { expect(page).to have_content(task.ship_to) }
    it { expect(page).to have_content(task.manufacturer_title) }
  end

  context '#destroy' do
    before do
      visit task_path(task)
    end

    it 'allow to destroy task' do
      click_link 'Delete'
      expect(page).to have_no_content(task.manufacturer_title)
    end
  end

  context "destroy project's task" do
    let(:project) { create :project, customer: create(:customer), sales: admin }
    let!(:task) { create :task, project: project, type: 'DrapeTask' }

    before do
      visit task_path(task)
    end

    it "redirect back to order for project's task" do
      click_link 'Delete'
      expect(page).to have_content('Project')
      expect(page).to have_content('Curtains')
      expect(page).to have_no_content('Related tasks')
    end
  end

  context 'Mailers' do
    let(:project) { create :project, customer: create(:customer), sales: admin }

    context 'Drape' do
      let!(:task) { create :drape_task, project: project, manufacturer: manufacturer }

      before do
        visit project_drape_task_path(project, task)
      end

      it { expect(page).to have_link('Prepare Email') }
      it 'contain header' do
        click_link 'Prepare Email'
        sleep 1
        within_frame 0 do
          expect(page).to have_content(task.worksheet_name)
          expect(page).to have_css('.miti-tech-logo')
          expect(page).to have_content(task.manufacturer_title)
        end
      end
    end

    context 'Trough' do
      let!(:task) { create :trough_task, project: project, manufacturer: manufacturer }

      before do
        visit project_trough_task_path(project, task)
      end

      it { expect(page).to have_link('Prepare Email') }
      it 'contain header' do
        click_link 'Prepare Email'
        sleep 1
        within_frame 0 do
          expect(page).to have_content(task.worksheet_name)
          expect(page).to have_css('.miti-tech-logo')
          expect(page).to have_content(task.manufacturer_title)
        end
      end
    end
  end

  context 'emails' do
    let(:project){ create :project, customer: create(:customer), sales: admin }
    let!(:drape_task) { create :drape_task, project: project, manufacturer: manufacturer  }
    let!(:trough_task) { create :trough_task, project: project, manufacturer: manufacturer  }
    let!(:orderless_task) { create :task, manufacturer: manufacturer }

    it 'allow send email' do
      visit new_task_email_path(drape_task)
      click_button 'Send Email'
      expect(page).to have_content('Email has been sent')
    end

    it 'allow send email' do
      visit new_task_email_path(trough_task)
      click_button 'Send Email'
      expect(page).to have_content('Email has been sent')
    end

    it 'allow send email' do
      visit new_task_email_path(orderless_task)
      click_button 'Send Email'
      expect(page).to have_content('Email has been sent')
    end
  end

  context 'inventory calculation' do
    let(:project){ create :project, customer: create(:customer), sales: admin,
                          curtains: [
                            create(:curtain, room: 15, width: 508, height: 2540)
                          ]
                  }
    let(:drape_task) { create :drape_task, project: project, manufacturer: manufacturer  }

    before do
      visit project_drape_task_path(project, drape_task)
    end

    it 'allow send email' do
      expect(page).to have_content(6.06)
      expect(page).to have_content(1.67, count: 2)
      expect(page).to have_content(12.11)
      click_link 'Manage task items'
      fill_in 'drape_task_drape_task_items_attributes_0_width_per_curt', with: 2
      click_button 'Update Task items List'
      expect(page).to have_content(12.11)
      expect(page).to have_content(3.33, count: 2)
      expect(page).to have_content(18.17)
    end

    it 'reject empty support items' do
      click_link 'Manage inventory'
      within '.manage-support-items' do
        click_link 'Add Item'
      end
      within all('tr.fields').last do
        fill_in 'Name', with: 'Empty Support Item'
        fill_in 'Unit', with: ''
        fill_in 'Qty', with: ''
      end
      click_button 'Update Support items List'
      expect(page).to have_no_content('Empty Support Item')
    end
  end

end
