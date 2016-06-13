require 'errors/unprocessable_entity'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_filter :set_current_user

  before_action :authenticate_user!

  rescue_from Errors::UnprocessableEntity do |exception|
    render file: "#{Rails.root}/public/422", formats: [:html], status: 422, layout: false
  end

  # Add current user to AuthorizationData module
  def set_current_user
    AuthorizationData.current_user = current_user
    yield
  ensure
    AuthorizationData.current_user = nil
  end
end
