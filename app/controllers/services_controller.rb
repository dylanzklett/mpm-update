class ServicesController < ApplicationController
  def new
  end

  def create
    service.update_attributes(service_params)
    flash[:success] = 'Manufacturer service was successfully created'
    redirect_to manufacturer_url(manufacturer)
  end

  def edit
  end

  def update
    service.update_attributes(service_params)
    flash[:success] = 'Manufacturer service was successfully updated'
    redirect_to manufacturer_url(manufacturer)
  end

  def destroy
    service.destroy
    flash[:success] = 'Manufacturer service was successfully destroyed'
    redirect_to manufacturer_url(manufacturer)
  end

  private

  helper_method :manufacturer
  def manufacturer
    @manufacturer ||= Manufacturer.find(params[:manufacturer_id])
  end

  helper_method :service
  def service
    @service ||= manufacturer.services.where(id: params[:id]).first || manufacturer.services.build
  end

  def service_params
    params.require(:service).permit(:name, :price)
  end
end
