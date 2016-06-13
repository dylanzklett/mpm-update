module Admins
  class BaseController < ::ApplicationController
    before_action :check_permissions

    private

    def check_permissions
      return redirect_to root_url unless current_user.admin?
    end
  end
end
