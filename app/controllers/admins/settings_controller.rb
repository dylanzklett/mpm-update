module Admins
  class SettingsController < BaseController
    def index
    end

    def update
      if setting.update_attributes(setting_params)
        flash[:success] = 'Setiings was successfully updated'
      else
        flash[:error] = setting.errors.full_messages.to_sentence
      end
      redirect_to settings_path
    end

    private

    helper_method :inline_settings
    def inline_settings
      @inline_settings ||= Setting.inline.order(:id)
    end

    helper_method :setting
    def setting
      @setting ||= Setting.find(params[:id])
    end

    def setting_params
      if params.require(setting.class.to_s.underscore.to_sym).fetch(:value, nil).instance_of?(String)
        params.require(setting.class.to_s.underscore.to_sym).permit(:code, :value, items_attributes: [:name, :unit, :quantity, :price, :_destroy])
      else
        all_value_variants = params.require(setting.class.to_s.underscore.to_sym).fetch(:value, nil).try(:permit!).to_json
        params.require(setting.class.to_s.underscore.to_sym).permit(:code, items_attributes: [:name, :unit, :quantity, :price, :_destroy]).merge(value: all_value_variants)
      end
    end
  end
end
