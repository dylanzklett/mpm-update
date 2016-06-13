require 'rails_helper'

feature 'Manufacturer Inventory', js: true, type: :feature do
  let(:manufacturer_page) { ManufacturerInfoPage.new }
  let(:history_page) { InventoryHistoryPage.new }
  let(:admin){ create :admin }
  let!(:manufacturer){ create :manufacturer }

  before do
    login_as admin
  end

  context '#show' do
    before do
      manufacturer_page.load(mid: manufacturer.id)
    end

    it { expect(manufacturer_page.man_visible?).to be_truthy }
    it { expect(manufacturer_page).to have_add_item }

    context 'inventory' do
      let!(:inventory_item) { create :inventory_item, name: 'fabric Red', amount: 500, manufacturer: manufacturer }

      it 'allow create additionals' do
        manufacturer_page.load(mid: manufacturer.id)
        manufacturer_page.i_add.click
        history_page.amount.set '1683.95'
        history_page.submit_btn.click
        expect(page).to have_content(2183.95)
      end

      it 'allow deduct additionals' do
        manufacturer_page.load(mid: manufacturer.id)
        manufacturer_page.i_deduct.click
        history_page.amount.set '127'
        history_page.submit_btn.click
        expect(page).to have_content(373)
      end

      it 'show errors' do
        manufacturer_page.load(mid: manufacturer.id)
        manufacturer_page.i_add.click
        history_page.amount.set ''
        history_page.submit_btn.click
        expect(history_page.error_block.text).to eq("Amount is not a number")
      end
    end
  end

  context 'destroy' do
    let!(:inventory_item) { create :inventory_item, name: 'fabric Red', amount: 200, manufacturer: manufacturer }

    it 'allow destroy' do
      manufacturer_page.load(mid: manufacturer.id)
      manufacturer_page.i_delete.click
      expect(manufacturer_page).to have_no_i_delete
      expect(manufacturer_page).to have_content("Manufacturer inventory item was successfully destroyed")
    end
  end

  context 'history deletion' do
    let!(:inventory_item) { create :inventory_item, name: 'fabric Red', amount: 200, manufacturer: manufacturer }
    let(:project) { create :project, customer: create(:customer), sales: admin, state: 'in_process',
                           curtains: [
                               create(:curtain, fabric_color: 'Red', width: 508, height: 508)
                           ]
    }
    let!(:drape_task) { create :drape_task, project: project, manufacturer: manufacturer }

    let(:project2) { create :project, customer: create(:customer), sales: admin,
                            curtains: [
                                create(:curtain, fabric_color: 'Red', width: 508, height: 508)
                            ]
    }
    let!(:drape_task2) { create :drape_task, project: project2, manufacturer: manufacturer }

    it 'calculate balance' do
      manufacturer_page.load(mid: manufacturer.id)
      expect(manufacturer_page.inv_adds.text).to eq('200.0')
      expect(manufacturer_page.inv_dels.text).to eq('1.61')
      expect(manufacturer_page.inv_bal.text).to eq('198.39')
    end

    it 'history item' do
      history_page.load(iid: inventory_item.id)
      expect(history_page.his_adds_1.text).to eq('200.0')
      expect(history_page.his_dels_1.text).to eq('0.0')
      expect(history_page.his_adds_2.text).to eq('0.0')
      expect(history_page.his_dels_2.text).to eq('1.61')
      expect(history_page.his_project_2.text).to eq("##{project.id}")
    end
  end

  context '#edit' do
    let(:inventory_edit_page) { InventoryEditPage.new }
    let(:inventory_item) { create :inventory_item, amount: 200, manufacturer: manufacturer }

    before do
      inventory_edit_page.load(mid: manufacturer.id, iid: inventory_item.id)
    end

    it 'should not contain amount' do
      expect(inventory_edit_page).to have_no_amount
    end

    it 'should allow to update' do
      inventory_edit_page.unit.set 'yard'
      inventory_edit_page.submit_btn.click
      expect(page).to have_content("Manufacturer inventory was successfully updated")
      expect(page).to have_no_field('Unit')
    end

    it 'show error message' do
      inventory_edit_page.name.set ''
      inventory_edit_page.submit_btn.click
      expect(page).to have_content("Name can't be blank")
    end
  end

  context '#create' do
    let(:inventory_new_page) { InventoryNewPage.new }
    before do
      inventory_new_page.load(mid: manufacturer.id)
    end

    it { expect(inventory_new_page).to have_submit_btn }
    it { expect(inventory_new_page.form_visible?).to be_truthy }

    it 'show error message' do
      inventory_new_page.submit_btn.click
      expect(inventory_new_page.error_block.text).to eq("Name can't be blank Amount is not a number")
    end

    it 'allow to create new item' do
      inventory_new_page.name.set 'fabric Red'
      inventory_new_page.unit.set 'yards'
      inventory_new_page.amount.set '1683.95'
      inventory_new_page.submit_btn.click
      expect(manufacturer_page).to have_content("fabric red")
      expect(manufacturer_page).to have_content("yards")
      expect(manufacturer_page).to have_content("1683.95", count: 2)
      expect(manufacturer_page).to have_i_history
      expect(manufacturer_page).to have_i_edit
      expect(manufacturer_page).to have_i_add
      expect(manufacturer_page).to have_i_deduct
      expect(manufacturer_page).to have_i_delete
    end

    context 'history' do
      let(:inventory_item) { create :inventory_item, amount: 200, manufacturer: manufacturer }

      it 'create first history item' do
        history_page.load(iid: inventory_item.id)
        expect(history_page.his_adds_1.text).to eq('200.0')
        expect(history_page.his_dels_1.text).to eq('0.0')
      end
    end
  end
end
