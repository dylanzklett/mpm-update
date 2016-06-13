class ManufacturersController < ApplicationController
  def index
  end

  def new
  end

  def create
    if manufacturer.update_attributes(manufacturer_params)
      flash[:success] = 'Manufacturer was successfully created'
      redirect_to manufacturers_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if manufacturer.update_attributes(manufacturer_params)
      flash[:success] = 'Manufacturer was successfully updated'
      redirect_to manufacturers_url
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    manufacturer.destroy
    flash[:success] = 'Manufacturer was successfully destroyed'
    redirect_to manufacturers_url
  end

  private

  helper_method :manufacturers
  def manufacturers
    @manufacturers ||= Manufacturer.all
  end

  helper_method :manufacturer
  def manufacturer
    @manufacturer ||= Manufacturer.where(id: params[:id]).first || Manufacturer.new(manufacturer_type: :drape)
  end

  def manufacturer_params
    params.require(:manufacturer).permit(:email, :title, :manufacturer_type, :phone, :address)
  end
end
