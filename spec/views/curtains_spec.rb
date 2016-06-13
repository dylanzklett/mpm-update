require 'rails_helper'

feature 'Curtains', js: true, type: :feature do
  let(:admin){ create :admin }
  let(:customer){ create :customer, sales: admin }
  let(:project){ create :project, customer: customer, sales: admin }
  let!(:curtain){ create :curtain, project: project, metric: 'Imperial',
                         fabric_color: 'Green', trough_color: 'Blue',
                         center_support: 4, end_bracket: 6 }

  before do
    login_as admin
  end

  context '#index' do
    before do
      visit project_path(project)
    end

    it { expect(page).to have_content('Curtains') }
  end


  context '#new' do
    before do
      visit new_project_curtain_path(project)
    end

    it{ expect(page).to have_select('curtain_metric', selected: 'Imperial') }
    it{ expect(page).to have_field('curtain_building_number', with: curtain.building_number) }
    it{ expect(page).to have_field('curtain_room', with: curtain.room) }
    it{ expect(page).to have_field('curtain_width', with: curtain.width_in('in')) }
    it{ expect(page).to have_field('curtain_height', with: curtain.height_in('in')) }
    it{ expect(page).to have_select('curtain_inside', selected: 'Inside') }
    it{ expect(page).to have_field('curtain_wall_type', with: curtain.wall_type) }
    it{ expect(page).to have_select('curtain_fabric_color', selected: curtain.fabric_color) }
    it{ expect(page).to have_select('curtain_trough_color', selected: curtain.trough_color) }
    it{ expect(page).to have_select('curtain_center_support', selected: curtain.center_support.to_s) }
    it{ expect(page).to have_select('curtain_end_bracket', selected: curtain.end_bracket.to_s) }
    it{ expect(page).to have_field('curtain_quantity', with: curtain.quantity) }
  end

  context '#create' do
    let(:attrs) {{
      building_number: 20,
      room: 15,
      width: 70,
      height: 70,
      inside: 'Outside',
      wall_type: 'Brick',
      fabric_color: 'Green',
      trough_color: 'Red',
      center_support: 4,
      end_bracket: 2,
      quantity: 2
    }}


    before do
      visit new_project_curtain_path(project)
    end

    it 'allow to change from metric system to imperial' do
      select 'Imperial', :from => 'curtain_metric'

      fill_in 'curtain_width', with: attrs[:width]
      fill_in 'curtain_height', with: attrs[:height]
      select attrs[:inside], :from => 'curtain_inside'
      fill_in 'curtain_quantity', with: attrs[:quantity]
      click_button 'Create Curtain'
      expect(page).to have_content("#{attrs[:width]*2.54} cm")
      expect(page).to have_content("#{attrs[:height]*2.54} cm")
    end

    it 'allow to change from metric system to Metric' do
      select 'Metric', :from => 'curtain_metric'

      fill_in 'curtain_width', with: attrs[:width]
      fill_in 'curtain_height', with: attrs[:height]
      select attrs[:inside], :from => 'curtain_inside'
      fill_in 'curtain_quantity', with: attrs[:quantity]
      click_button 'Create Curtain'
      expect(page).to have_content("#{attrs[:width]}.0 cm")
      expect(page).to have_content("#{attrs[:height]}.0 cm")
    end

    it 'imperial system if default' do
      expect(page).to have_select('curtain_metric', selected: 'Imperial')
    end

    it 'allow to create curtain' do
      fill_in 'curtain_building_number', with: attrs[:building_number]
      fill_in 'curtain_room', with: attrs[:room]
      fill_in 'curtain_width', with: attrs[:width]
      fill_in 'curtain_height', with: attrs[:height]
      select attrs[:inside], :from => 'curtain_inside'
      fill_in 'curtain_wall_type', with: attrs[:wall_type]
      select attrs[:fabric_color], from: 'curtain_fabric_color'
      select attrs[:trough_color], from: 'curtain_trough_color'
      select attrs[:center_support], from: 'curtain_center_support'
      select attrs[:end_bracket], from: 'curtain_end_bracket'
      fill_in 'curtain_quantity', with: attrs[:quantity]
      click_button 'Create Curtain'
      within 'table.curtains' do
        expect(page).to have_content(attrs[:building_number])
        expect(page).to have_content(attrs[:room])
        expect(page).to have_content(attrs[:width])
        expect(page).to have_content(attrs[:height])
        expect(page).to have_content(attrs[:inside])
        expect(page).to have_content(attrs[:wall_type])
        expect(page).to have_content(attrs[:fabric_color])
        expect(page).to have_content(attrs[:trough_color])
        expect(page).to have_content(attrs[:center_support])
        expect(page).to have_content(attrs[:end_bracket])
        expect(page).to have_content(attrs[:quantity])
      end
    end

    it 'show validation error' do
      fill_in 'curtain_quantity', with: ''
      click_button 'Create Curtain'
      expect(page).to have_content("Quantity can't be blank")
    end
  end

  context '#edit' do
    before do
      visit project_path(project)
    end

    it { expect(page).to have_content(curtain.room) }
  end

  context '#update' do
    let(:attrs) {{
        building_number: 20,
        room: 15,
        width: 70,
        height: 70,
        inside: 'Outside',
        wall_type: 'Brick',
        fabric_color: 'Green',
        trough_color: 'Red',
        center_support: 4,
        end_bracket: 2,
        quantity: 2
    }}

    before do
      visit project_path(project)

      within 'table.curtains' do
        click_link 'Edit'
      end
    end

    it 'show validation error' do
      fill_in 'curtain_quantity', with: ''
      click_button 'Update Curtain'
      expect(page).to have_content("Quantity can't be blank")
    end

    it 'allow to update curtain' do
      fill_in 'curtain_building_number', with: attrs[:building_number]
      fill_in 'curtain_room', with: attrs[:room]
      fill_in 'curtain_width', with: attrs[:width]
      fill_in 'curtain_height', with: attrs[:height]
      select attrs[:inside], :from => 'curtain_inside'
      fill_in 'curtain_wall_type', with: attrs[:wall_type]
      select attrs[:fabric_color], from: 'curtain_fabric_color'
      select attrs[:trough_color], from: 'curtain_trough_color'
      select attrs[:center_support], from: 'curtain_center_support'
      select attrs[:end_bracket], from: 'curtain_end_bracket'
      fill_in 'curtain_quantity', with: attrs[:quantity]
      click_button 'Update Curtain'
      within 'table.curtains' do
        expect(page).to have_content(attrs[:building_number])
        expect(page).to have_content(attrs[:room])
        expect(page).to have_content(attrs[:width])
        expect(page).to have_content(attrs[:height])
        expect(page).to have_content(attrs[:inside])
        expect(page).to have_content(attrs[:wall_type])
        expect(page).to have_content(attrs[:fabric_color])
        expect(page).to have_content(attrs[:trough_color])
        expect(page).to have_content(attrs[:center_support])
        expect(page).to have_content(attrs[:end_bracket])
        expect(page).to have_content(attrs[:quantity])
      end
    end
  end

  context '#destroy' do
    before do
      visit project_path(project)
    end

    it 'allow to destroy curtain' do
      within 'table.curtains' do
        click_link 'Delete'
      end
      expect(page).to have_css("table.curtains tr", count: 2)
    end
  end
end
