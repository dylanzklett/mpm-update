class ProfilesController < ApplicationController
  def edit
  end

  def update
    if user.update_attributes(user_params)
      flash[:success] = 'User was successfully updated'
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
    params.require(:user).permit(:email, profile_attributes: [:id, :first_name, :last_name, :first_title, :second_title, :first_address,
                                                              :second_address, :country, :city, :state, :zip, :phone_o, :phone_c])
  end
end
