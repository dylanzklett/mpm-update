module Admins
  class UsersController < BaseController
    before_action :check_permissions

    def index
    end

    def show
    end

    def new
    end

    def create
      if user.update_attributes(user_params)
        flash[:success] = 'User was successfully created'
        redirect_to users_url
      else
        render :new
      end
    end

    def edit
    end

    def update
      if user.update_attributes(user_params)
        flash[:success] = 'User was successfully updated'
        redirect_to users_url
      else
        render :edit
      end
    end

    def destroy
      user.destroy
      flash[:success] = 'User was successfully deleted'
      redirect_to users_url
    end

    private

    helper_method :users
    def users
      @users ||= User.all
    end

    helper_method :user
    def user
      @user ||= User.where(id: params[:id]).first || User.new
    end

    def user_params
      params.require(:user).permit(:email, :rep_number, :admin, :password, :password_confirmation,
                                   profile_attributes: [:id, :first_name, :last_name, :first_title, :second_title, :first_address,
                                                        :second_address, :country, :city, :state, :zip, :phone_o, :phone_c])
    end
  end
end
