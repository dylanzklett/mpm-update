require 'rails_helper'

RSpec.describe DrapeTask, :type => :model do
  let!(:setting) { create :unit_setting, :width_multiplicity }
  let!(:setting2) { create :setting, :price_matrix }
  let!(:setting3) { create :setting, :trough_step }
  let!(:setting4) { create :setting, :trough_matrix }

  let(:project) { create :project, customer: create(:customer), sales: create(:admin)}
  let(:drape_task) { create :drape_task, project: project, task_items: [create(:task_item), create(:task_item)] }

  it { expect(drape_task.task_items_partial_name).to eql('drape_task_item') }
  it { expect(drape_task.task_type).to eql(:drape_task_items) }

  it { expect(drape_task.get_box_label_pdf.class).to eql(DrapeLabelGenerator) }
  it { expect(drape_task.get_sew_label_pdf.class).to eql(DrapeSewLabelGenerator) }

  it { expect(drape_task.get_box_label_pdf.generate.class).to eql(Prawn::Document) }
  it { expect(drape_task.get_sew_label_pdf.generate.class).to eql(Prawn::Document) }

  it { expect(drape_task.mailer).to eql(DrapeTaskMailer) }
  it { expect(drape_task.worksheet_name).to eql('Drape Worksheet') }

  context '#Drape task' do
    let(:service) { create :service, price: 15.99 }
    let(:manufacturer) { create :manufacturer, services: [ service ] }
    let(:drape_task) { create :drape_task,
                              project: project,
                              manufacturer: manufacturer,
                              task_items: [ create(:task_item, quantity: 5, width_per_curt: 3, width_in: 60, height_in: 20),
                                            create(:task_item, quantity: 6, width_per_curt: 6, width_in: 120, height_in: 20) ]
    }

    it { expect(drape_task.price_for_width).to eql(service.price) }
    it { expect(drape_task.full_width_count).to eql((5 * 3 + 6 * 6).to_f) }
    it { expect(drape_task.full_price).to eql(service.price * drape_task.full_width_count) }
  end

  context 'populate instalation item' do
    let!(:curtain) { create :curtain, project: project, width: 76.2, height: 76.2, quantity: 3 }
    let(:drape_task) { create :trough_task, project: project }

    it 'add item for instalation' do
      project.reload
      expect(drape_task.task_items.size).to eql(project.curtains.count)
    end
  end

  context '#support items' do
    context '#individual' do
      let(:project) { create :project, customer: create(:customer), sales: create(:admin),
                              curtains: [
                                create(:curtain, quantity: 1, width: 508, height: 508, fabric_color: 'Blue')
                              ]
                    }
      let(:drape_task) { create :drape_task, project: project }

      it ' should contain box' do
        items = drape_task.support_items.where(name: 'box')
        expect(items.count).to eql(1)
        expect(items.last.quantity).to eql(1.0)
      end

      it ' should contain fabric line' do
        items = drape_task.support_items.where("name like '%fabric%'")
        expect(items.count).to eql(1)
        expect(items.last.quantity.round(2)).to eql(((project.curtains.last.height_in('in')*2+18)/36).round(2))
      end

      it ' should contain Weight line' do
        items = drape_task.support_items.where(name: 'Weight')
        expect(items.count).to eql(1)
        expect(items.last.quantity.round(2)).to eql((60/36).to_f.round(2))
      end

      it ' should contain shirring line' do
        items = drape_task.support_items.where(name: 'shirring')
        expect(items.count).to eql(1)
        expect(items.last.quantity.round(2)).to eql((60/36).to_f.round(2))
      end

      it ' should contain 1/4 tape line' do
        items = drape_task.support_items.where(name: '1/4" tape')
        expect(items.count).to eql(1)
        expect(items.last.quantity.round(2)).to eql((((project.curtains.last.height_in('in')*2+18)/36)*2).round(2))
      end
    end

    context '#multiple' do
      let(:project2) { create :project, customer: create(:customer), sales: create(:admin),
                              curtains: [
                                create(:curtain, quantity: 3, width: 508, height: 508, fabric_color: 'Green'),
                                create(:curtain, quantity: 3, width: 1016, height: 1016, fabric_color: 'Blue')
                              ]
                      }
      let(:curtain2) { project2.curtains.first }
      let(:curtain3) { project2.curtains.last }
      let(:drape_task2) { create :drape_task, project: project2 }

      it ' should contain box' do
        items = drape_task2.support_items.where(name: 'box')
        expect(items.count).to eql(1)
        expect(items.last.quantity).to eql(6.0)
      end

      it ' should contain fabric lines' do
        items = drape_task2.support_items.where("name like '%fabric%'")
        item_first = items.where("name like '%Green%'").first
        item_last = items.where("name like '%Blue%'").first
        expect(items.count).to eql(2)
        expect(item_first.quantity).to eql((((curtain2.height_in('in')*2+18)/36)*3).round(2))
        expect(item_last.quantity).to  eql(((curtain3.height_in('in')*2+18)/36*3*2).round(2))
      end

      it ' should contain Weight line' do
        items = drape_task2.support_items.where(name: 'Weight')
        expect(items.count).to eql(1)
        expect(items.last.quantity.to_f).to eql((60/36*3)+(60/36*2*3).to_f)
      end

      it ' should contain shirring line' do
        items = drape_task2.support_items.where(name: 'shirring')
        expect(items.count).to eql(1)
        expect(items.last.quantity.to_f).to eql((60/36*3)+(60/36*2*3).to_f)
      end

      it ' should contain 1/4 tape line' do
        items = drape_task2.support_items.where(name: '1/4" tape')
        expect(items.count).to eql(1)
        expect(items.last.quantity.round(2)).to eql( ((((curtain2.height_in('in')*2+18)/36)*2*3) + (((curtain3.height_in('in')*2+18)/36)*3*3)).round(2) )
      end
    end
  end
end
