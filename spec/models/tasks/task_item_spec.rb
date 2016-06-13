require 'rails_helper'

RSpec.describe TaskItem, :type => :model do
  let!(:setting) { create :unit_setting, :width_multiplicity }
  let!(:setting2) { create :setting, :price_matrix }
  let!(:setting3) { create :setting, :trough_step }
  let!(:setting4) { create :setting, :trough_matrix }
  let(:task_item) { create :task_item, width_in: 15, height_in: 17 }
  let(:task_item2) { create :task_item, width_in: 56, height_in: 50 }

  context '#model_code' do
    it { expect(task_item.model_code).to eql('SDCW2020') }
    it { expect(task_item2.model_code).to eql('SDCW6060') }
  end

  context '#finished_length_in' do
    it 'set finished_length in mm' do
      task_item.finished_length_in = 10
      expect(task_item.finished_length).to eql(254.0)
    end
    it 'set finished_length ass doubled height_in as mm' do
      task_item.finished_length_in = nil
      expect(task_item.finished_length).to eql(task_item.height*2)
    end
  end
end
