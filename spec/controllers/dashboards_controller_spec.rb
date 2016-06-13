require 'rails_helper'

RSpec.describe DashboardsController, type: :controller do
  render_views

  describe 'GET show' do
    let(:admin){ create :admin }

    it 'not authorized' do
      get :show
      expect(response).to redirect_to(new_user_session_url)
    end

    it 'authorized' do
      sign_in admin
      get :show
      expect(response).to render_template('show')
    end
  end
end
