require 'rails_helper'

feature 'User', js: true, type: :feature do
  let(:admin){ create :admin }
  let!(:user){ create :user }

  before do
    login_as admin
  end

  context '#index' do
    let(:users_page) { UsersPage.new }

    before do
      users_page.load
    end

    it { expect(page).to have_content(admin.email) }
    it { expect(page).to have_content(user.email) }
    it { expect(users_page.has_users_table?).to be_truthy }
  end

  context '#create' do
    let(:user_new_page) { UserNewPage.new }
    let(:attrs) {{
        email: 'valid@email.com',
        pass: 'password'
    }}

    before do
      user_new_page.load
    end

    it 'allow to create user' do
      expect(user_new_page.user_form_visible?).to be_truthy
      user_new_page.user_email.set attrs[:email]
      user_new_page.password.set attrs[:pass]
      user_new_page.password_confirmation.set attrs[:pass]
      user_new_page.submit_btn.click
      expect(page).to have_content(attrs[:email])
    end

    it 'show validation error' do
      user_new_page.user_email.set attrs[:email]
      user_new_page.password.set attrs[:pass]
      user_new_page.password_confirmation.set 'wrong_pass'
      user_new_page.submit_btn.click
      expect(user_new_page.user_email.value).to eq(attrs[:email])
      expect(user_new_page.has_errors?).to be_truthy
    end
  end

  context '#show' do
    let(:user_info_page) { UserInfoPage.new }

    before do
      user_info_page.load(uid: user.id)
    end

    it { expect(page).to have_content(user.email) }
    it { expect(user_info_page.user_buttons_visible?).to be_truthy }
    it { expect(user_info_page.recent_projects.visible?).to be_truthy }
    it { expect(user_info_page.has_delete_project?).to be_falsey }
  end

  context '#edit' do
    let(:user_edit_page) { UserEditPage.new }

    before do
      user_edit_page.load(uid: user.id)
    end

    it { expect(user_edit_page.user_email.value).to eq(user.email)}
    it { expect(user_edit_page.user_form_visible?).to be_truthy }
    it { expect(user_edit_page.admin_fields_visible?).to be_truthy }
  end

  context '#update' do
    let(:user_edit_page) { UserEditPage.new }

    before do
      user_edit_page.load(uid: user.id)
    end

    it 'allow to change email' do
      new_email = 'valid@email.com'
      user_edit_page.user_email.set new_email
      user_edit_page.submit_btn.click
      expect(page).to have_content(new_email)
    end

    it 'show validation error' do
      user_edit_page.user_email.set 'invalid_email'
      user_edit_page.submit_btn.click
      expect(user_edit_page.has_errors?).to be_truthy
    end
  end

  context '#destroy' do
    let(:user_info_page) { UserInfoPage.new }

    before do
      user_info_page.load(uid: user.id)
    end

    it 'allow to destroy user email' do
      user_info_page.delete_usr.click
      expect(page).to have_no_content(user.email)
    end
  end
end
