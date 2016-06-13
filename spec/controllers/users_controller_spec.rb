require 'rails_helper'

RSpec.describe Admins::UsersController, type: :controller do
  render_views
  let(:admin){ create :admin }

  before do
    sign_in admin
  end

  describe 'GET index' do
    before do
      get :index
    end

    it { expect(response).to render_template('index') }
  end

  describe 'GET show' do
    before do
      get :show, id: admin
    end

    it { expect(response).to render_template('show') }
  end

  describe 'GET new' do
    before do
      get :new
    end

    it { expect(response).to render_template('new') }
  end

  describe 'GET edit' do
    before do
      get :edit, id: admin
    end

    it { expect(response).to render_template('edit') }
  end

  describe 'POST create' do
    it 'should redirect to index' do
      post :create, user: { email: 'somenormal@email.com', password: 'password', password_confirmation: 'password' }
      expect(response).to redirect_to(users_url)
    end

    it 'should render new' do
      post :create, user: { email: 'some_invalid_email' }
      expect(response).to render_template('new')
    end
  end

  describe 'PATCH update' do
    let(:user){ create :user }

    it 'should redirect to index' do
      patch :update, id: user, user: { email: 'somenormal@email.com' }
      expect(response).to redirect_to(users_url)
    end

    it 'should render edit' do
      patch :update, id: admin, user: { email: 'some_invalid_email' }
      expect(response).to render_template('edit')
    end
  end

  describe 'DELETE destroy' do
    let(:user){ create :user }
    before do
      delete :destroy, id: user
    end

    it { expect(response).to redirect_to(users_url) }
  end
end
