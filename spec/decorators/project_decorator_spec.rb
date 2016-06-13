require 'rails_helper'

RSpec.describe ProjectDecorator, :type => :decorator do
  let!(:project) { create :project, customer: create(:customer), sales: create(:admin) }

  context '#decorate_for' do
    it 'generate error' do
      project.update_columns(state: 'invalid')

      expect{ProjectDecorator.decorate_for(project)}.to raise_error('Incorrect state')
    end
  end
end
