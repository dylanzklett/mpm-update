require 'rails_helper'

feature 'Manufacturer Inventory', js: true, type: :feature do
  let(:admin){ create :admin }
  let!(:manufacturer){ create :manufacturer }

  before do
    login_as admin
  end

  context '#show' do
    before do
      visit manufacturer_path(manufacturer)
    end

    it { expect(page).to have_content('Inventory') }
    it { expect(page).to have_link('Add Item', href: new_manufacturer_inventory_item_path(manufacturer)) }

    context 'inventory' do
      let!(:inventory_item) { create :inventory_item, name: 'fabric Red', amount: 200, manufacturer: manufacturer }

      it 'allow create additionals' do
        visit manufacturer_path(manufacturer)
        within :xpath, '//tbody/tr[1]' do
          click_link 'Add items'
        end
        fill_in 'Amount', with: 1683.95
        click_button 'Change inventory'
        expect(page).to have_content(1883.95)
      end

      it 'allow deduct additionals' do
        visit manufacturer_path(manufacturer)
        within :xpath, '//tbody/tr[1]' do
          click_link 'Deduct items'
        end
        fill_in 'Amount', with: 73
        click_button 'Change inventory'
        expect(page).to have_content(127)
      end

      it 'show errors' do
        visit manufacturer_path(manufacturer)
        within :xpath, '//tbody/tr[1]' do
          click_link 'Add items'
        end
        fill_in 'Amount', with: ''
        click_button 'Change inventory'
        expect(page).to have_content("Amount is not a number")
      end
    end
  end

  context 'destroy' do
    let!(:inventory_item) { create :inventory_item, name: 'fabric Red', amount: 200, manufacturer: manufacturer }

    it 'allow destroy' do
      visit manufacturer_path(manufacturer)
      within 'table.inventory-items' do
        click_link 'Delete'
      end
      within 'table.inventory-items' do
        expect(page).to have_no_link("Delete")
      end
      expect(page).to have_content("Manufacturer inventory item was successfully destroyed")
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
      visit manufacturer_path(manufacturer)
      within :xpath, '//table[1]/tbody/tr[1]/td[4]' do
        expect(page).to have_content(200.0)
      end
      within :xpath, '//table[1]/tbody/tr[1]/td[5]' do
        expect(page).to have_content(1.61)
      end
      within :xpath, '//table[1]/tbody/tr[1]/td[6]' do
        expect(page).to have_content(200.0 - 1.61)
      end
    end

    it 'history item' do
      visit inventory_item_inventory_history_items_path(inventory_item)

      within :xpath, '//tbody/tr[1]/td[3]' do
        expect(page).to have_content(200.0)
      end
      within :xpath, '//tbody/tr[1]/td[4]' do
        expect(page).to have_content(0.0)
      end
      within :xpath, '//tbody/tr[2]/td[3]' do
        expect(page).to have_content(0.0)
      end
      within :xpath, '//tbody/tr[2]/td[4]' do
        expect(page).to have_content(1.61)
      end
      within :xpath, '//tbody/tr[2]/td[5]' do
        expect(page).to have_link("##{project.id}", href: project_path(project))
      end
    end

  end

  context '#edit' do
    let(:inventory_item) { create :inventory_item, amount: 200, manufacturer: manufacturer }

    before do
      visit edit_manufacturer_inventory_item_path(manufacturer, inventory_item)
    end

    it 'should not contain amount' do
      expect(page).to have_no_field("Amount")
    end

    it 'should alow to update' do
      fill_in 'Unit', with: 'yard'
      click_button 'Update Inventory item'
      expect(page).to have_content("Manufacturer inventory was successfully updated")
      expect(page).to have_no_field("Unit")
    end

    it 'show error message' do
      fill_in 'Name', with: ''
      click_button 'Update Inventory item'
      expect(page).to have_content("Name can't be blank")
    end
  end

  context '#create' do
    before do
      visit new_manufacturer_inventory_item_path(manufacturer)
    end

    it { expect(page).to have_button('Create Inventory item') }

    it 'show error message' do
      click_button 'Create Inventory item'
      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Amount is not a number")
    end

    it 'allow to create new item' do
      fill_in 'Name', with: 'fabric Red'
      fill_in 'Unit', with: 'yards'
      fill_in 'Amount', with: 1683.95
      click_button 'Create Inventory item'
      within 'table.inventory-items' do
        expect(page).to have_content("fabric red")
        expect(page).to have_content("yards")
        expect(page).to have_content("1683.95", count: 2)
        expect(page).to have_link("History")
        expect(page).to have_link("Edit")
        expect(page).to have_link("Add items")
        expect(page).to have_link("Deduct items")
        expect(page).to have_link("Delete")
      end
    end

    context 'history' do
      let(:inventory_item) { create :inventory_item, amount: 200, manufacturer: manufacturer }

      it 'create first history item' do
        visit inventory_item_inventory_history_items_path(inventory_item)
        within :xpath, '//tbody/tr[1]/td[3]' do
          expect(page).to have_content(200.0)
        end
        within :xpath, '//tbody/tr[1]/td[4]' do
          expect(page).to have_content(0.0)
        end
      end
    end
  end
end
