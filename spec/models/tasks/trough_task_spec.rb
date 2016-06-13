require 'rails_helper'

RSpec.describe TroughTask, :type => :model do
  let!(:setting) { create :unit_setting, :width_multiplicity }
  let!(:setting2) { create :setting, :price_matrix }
  let!(:setting3) { create :setting, :trough_step }
  let!(:setting4) { create :setting, :trough_matrix }

  let(:project) { create :project, customer: create(:customer), sales: create(:admin) }
  let(:service) { create :service, name: 'A9-15', price: 15.99 }
  let(:service2) { create :service, name: 'B10-15', price: 20.58 }
  let!(:manufacturer) { create :manufacturer, services: [service, service2] }

  let(:task_item1) { create(:task_item, quantity: 5, width_in: 10, height_in: 20, trough_size: 'A9-15') }
  let(:task_item2) { create(:task_item, quantity: 6, width_in: 10, height_in: 40, trough_size: 'B10-15') }
  let(:task_item3) { create(:task_item, quantity: 6, width_in: 10, height_in: 20, trough_size: 'A9-15') }
  let(:task_item4) { create(:task_item, quantity: 4, width_in: 20, height_in: 40, trough_size: 'B9-15') }

  let(:trough_task) { create :trough_task, project: project, manufacturer: manufacturer, task_items: [task_item1, task_item2, task_item3, task_item4] }

  it { expect(trough_task.task_items_partial_name).to eql('trough_task_item') }
  it { expect(trough_task.task_type).to eql(:trough_task_items) }
  it { expect(trough_task.get_box_label_pdf.class).to eql(TroughLabelGenerator) }
  it { expect(trough_task.get_box_label_pdf.generate.class).to eql(Prawn::Document) }
  it { expect(trough_task.worksheet_name).to eql('Trough Worksheet') }
  it { expect(trough_task.mailer).to eql(TroughTaskMailer) }

  context '#summary_items' do
    it { expect(trough_task.summary_items.size).to eql(3) }
    it { expect(trough_task.summary_items.map { |_, item| item[:name] }).to eql %w(A9-15 B10-15 B9-15) }
    it { expect(trough_task.summary_items.map { |_, item| item[:quantity] }).to eql [11, 6, 4] }
    it { expect(trough_task.summary_items.map { |_, item| item[:price_per].to_f }).to eql [15.99, 20.58, 0.0] }
    it { expect(trough_task.summary_items.map { |_, item| item[:price_total].to_f }).to eql [175.89, 123.48, 0.0] }
    it { expect(trough_task.full_price).to eql(service.price * 11 + service2.price * 6) }
  end

  context 'populate instalation item' do
    let!(:curtain) { create :curtain, project: project, width: 76.2, height: 76.2, quantity: 3 }
    let(:trough_task) { create :trough_task, project: project, manufacturer: manufacturer }

    it 'add item for instalation' do
      project.reload
      expect(trough_task.task_items.size).to eql(project.curtains.count)
    end
  end

  context '#support_items' do
    context 'box' do
      it 'should contain one 9-15 Box' do
        items = trough_task.support_items.where(name: '9-15 Box')
        expect(items.count).to eql(1)

        expect(items.first.quantity).to eql (task_item1.quantity + task_item3.quantity + task_item4.quantity).to_f
        expect(items.first.unit).to eql 'each'
      end

      it 'should contain one 10-15 Box' do
        items = trough_task.support_items.where(name: '10-15 Box')
        expect(items.count).to eql(1)

        expect(items.first.quantity).to eql task_item2.quantity.to_f
        expect(items.first.unit).to eql 'each'
      end
    end

    context 'foam' do
      it 'should contain one foam for all boxes' do
        items = trough_task.support_items.where(name: 'Foam')
        expect(items.count).to eql(1)

        expect(items.first.unit).to eql 'each'
        expect(items.first.quantity).to eq((task_item1.quantity + task_item3.quantity + task_item4.quantity)*TroughTask::FOAM_FACTOR_BY_SIZE['9-15'] + task_item2.quantity*0)
      end
    end

    context 'end cups' do
      it 'should contain one A type end cap' do
        items = trough_task.support_items.where(name: 'A end cups')
        expect(items.count).to eql(1)

        expect(items.first.quantity).to eql (task_item1.quantity + task_item3.quantity).to_f
        expect(items.first.unit).to eql 'Pair'
      end

      it 'should contain one B type end cap' do
        items = trough_task.support_items.where(name: 'B end cups')
        expect(items.count).to eql(1)

        expect(items.first.quantity).to eql (task_item2.quantity + task_item4.quantity).to_f
        expect(items.first.unit).to eql 'Pair'
      end
    end
  end
end
