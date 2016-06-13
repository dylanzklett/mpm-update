class InventoryItemsController < ApplicationController
  def new
  end

  def create
    if item.update_attributes(item_params)
      flash[:success] = 'Manufacturer inventory was successfully created'
      redirect_to manufacturer_url(manufacturer)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if item.update_attributes(item_params)
      flash[:success] = 'Manufacturer inventory was successfully updated'
      redirect_to manufacturer_url(manufacturer)
    else
      render :edit
    end
  end

  def destroy
    item.destroy
    flash[:success] = 'Manufacturer inventory item was successfully destroyed'
    redirect_to manufacturer_url(manufacturer)
  end

  private

  helper_method :manufacturer
  def manufacturer
    @manufacturer ||= Manufacturer.find(params[:manufacturer_id])
  end

  helper_method :item
  def item
    @item ||= manufacturer.inventory_items.where(id: params[:id]).first || manufacturer.inventory_items.build
  end

  def item_params
    params.require(:inventory_item).permit(:name, :description, :unit, :amount )
  end
end
