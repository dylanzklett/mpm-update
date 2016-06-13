require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  let(:admin) { create :admin }
  let!(:customer) { create :customer, sales: admin }

  before do
    sign_in admin
  end

  describe 'Get index' do
    it 'should show json' do
      get :index, format: :json
      expect(response.body).to eql([{label:       customer.name_for_select,
                                     customer_id: customer.id,
                                     sales_id:    admin.id,
                                     sales_data:  admin.name_for_select}].to_json)
    end
  end

  describe 'POST create' do
    it 'should redirect to index' do
      post :create, customer: {email: 'customer@email.com', first_name: 'Foo', last_name: 'Bar'}
      expect(response).to redirect_to(customers_url)
    end

    it 'should render new' do
      post :create, customer: { email: '' }
      expect(response).to render_template('new')
    end
  end

  describe 'PATCH update' do
    it 'should redirect to index' do
      patch :update, id: customer, customer: {email: 'somenormal@email.com'}
      expect(response).to redirect_to(customers_url)
    end

    it 'should render edit' do
      patch :update, id: admin, customer: {email: 'some_invalid_email'}
      expect(response).to render_template('edit')
    end
  end

  describe 'DELETE destroy' do
    before do
      delete :destroy, id: customer
    end

    it { expect(response).to redirect_to(customers_url) }
  end
end
