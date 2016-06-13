require 'rails_helper'

feature 'Dashboard' do
  context 'Users link' do
    let(:dashboard_page) { DashboardPage.new }
    let(:admin){ create :admin }
    let(:user){ create :user }

    it 'show for admin' do
      login_as admin
      dashboard_page.load
      expect(dashboard_page.admin?).to be_truthy
    end

    it 'not show for user' do
      login_as user
      dashboard_page.load
      expect(dashboard_page.admin?).to be_falsey
    end
  end
end
