require 'rails_helper'

RSpec.describe StatesController, type: :controller do
  let(:admin){ create :admin }
  let!(:project){ create :project, customer: create(:customer), sales: admin }

  before do
    sign_in admin
  end

  describe 'PATCH update' do
    it 'should show 422' do
      patch :update, project_id: project, project: { event: 'invalid_event' }
      expect(response.status).to eql(422)
    end

    it 'should redirect' do
      patch :update, project_id: project, project: { event: 'propose' }
      expect(response.status).to eql(302)
    end
  end
end
