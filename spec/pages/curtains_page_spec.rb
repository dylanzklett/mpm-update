require 'rails_helper'

feature 'Curtains', js: true, type: :feature do
  let(:admin){ create :admin }
  let(:customer){ create :customer, sales: admin }
  let(:project){ create :project, customer: customer, sales: admin }
  let!(:curtain){ create :curtain, project: project,
                         fabric_color: 'Green', trough_color: 'Blue',
                         center_support: 4, end_bracket: 6 }

  before do
    login_as admin
  end

  context '#index' do
    let(:project_page) { ProjectInfoPage.new }

    before do
      project_page.load(pid: project.id)
    end

    it { expect(page).to have_content('Curtains') }
  end


  context '#new' do
    let(:curtain_page) { CurtainNewPage.new }

    before do
      curtain_page.load(pid: project.id)
    end

    it { expect(curtain_page.form_visible?).to be_truthy }
    it { expect(curtain_page.fabric_color.value).to eq(curtain.fabric_color) }
    it { expect(curtain_page.trough_color.value).to eq(curtain.trough_color) }
    it { expect(curtain_page.center_support.value).to eq(curtain.center_support.to_s) }
    it { expect(curtain_page.end_bracket.value).to eq(curtain.end_bracket.to_s) }
  end

  context '#create' do
    let(:curtain_page) { CurtainNewPage.new }
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
      curtain_page.load(pid: project.id)
    end

    it 'allow to change from metric system to imperial' do
      curtain_page.metric_system.set 'Imperial'
      curtain_page.width.set attrs[:width]
      curtain_page.height.set attrs[:height]
      curtain_page.inside.set attrs[:inside]
      curtain_page.quantity.set attrs[:quantity]
      curtain_page.submit_btn.click
      expect(page).to have_content("#{attrs[:width]*2.54} cm")
      expect(page).to have_content("#{attrs[:height]*2.54} cm")
    end

    it 'allow to change from metric system to Metric' do
      curtain_page.metric_system.set 'Metric'
      curtain_page.width.set attrs[:width]
      curtain_page.height.set attrs[:height]
      curtain_page.inside.set attrs[:inside]
      curtain_page.quantity.set attrs[:quantity]
      curtain_page.submit_btn.click
      expect(page).to have_content("#{attrs[:width]}.0 cm")
      expect(page).to have_content("#{attrs[:height]}.0 cm")
    end

    it 'imperial system if default' do
      expect(curtain_page.metric_system.value).to eq('Imperial')
    end

    it 'allow to create curtain' do
      curtain_page.building_number.set attrs[:building_number]
      curtain_page.room.set attrs[:room]
      curtain_page.width.set attrs[:width]
      curtain_page.height.set attrs[:height]
      curtain_page.inside.set attrs[:inside]
      curtain_page.wall_type.set attrs[:wall_type]
      curtain_page.fabric_color.set attrs[:fabric_color]
      curtain_page.trough_color.set attrs[:trough_color]
      curtain_page.center_support.set attrs[:center_support]
      curtain_page.end_bracket.set attrs[:end_bracket]
      curtain_page.quantity.set attrs[:quantity]
      curtain_page.submit_btn.click
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
      curtain_page.quantity.set ''
      curtain_page.submit_btn.click
      expect(curtain_page.has_errors?).to be_truthy
    end
  end

  context '#edit' do
    let(:edit_page) { CurtainEditPage.new }

    before do
      edit_page.load(pid: project.id, cid: curtain.id)
    end

    it { expect(edit_page.form_visible?).to be_truthy }
  end

  context '#update' do
    let(:project_page) { ProjectInfoPage.new }
    let(:edit_page) { CurtainEditPage.new }
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
      project_page.load(pid: project.id)
      project_page.curtain_edit_btn.click
    end

    it 'show validation error' do
      edit_page.quantity.set ''
      edit_page.submit_btn.click
      expect(edit_page.has_errors?).to be_truthy
    end

    it 'allow to update curtain' do
      edit_page.building_number.set attrs[:building_number]
      edit_page.room.set attrs[:room]
      edit_page.width.set attrs[:width]
      edit_page.height.set attrs[:height]
      edit_page.inside.select attrs[:inside]
      edit_page.wall_type.set attrs[:wall_type]
      edit_page.fabric_color.set attrs[:fabric_color]
      edit_page.trough_color.set attrs[:trough_color]
      edit_page.center_support.set attrs[:center_support]
      edit_page.end_bracket.set attrs[:end_bracket]
      edit_page.quantity.set attrs[:quantity]
      edit_page.submit_btn.click
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
    let(:project_page) { ProjectInfoPage.new }

    before do
      project_page.load(pid: project.id)
    end

    it 'allow to destroy curtain' do
      project_page.curtain_delete_btn.click
      expect(page).to have_css("table.curtains tr", count: 2)
    end
  end
end
