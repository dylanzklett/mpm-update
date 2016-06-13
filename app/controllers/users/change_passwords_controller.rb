module Users
  class ChangePasswordsController < ApplicationController
    def edit
    end

    def update
      if user.update_attributes(user_params)
        flash[:success] = 'User was successfully updated'
        sign_in user, bypass: true
        redirect_to root_url
      else
        render :edit
      end
    end

    private

    helper_method :user
    def user
      @user ||= current_user
    end

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end
end
