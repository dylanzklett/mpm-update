class InventoryHistoryItemsController < ApplicationController
  def new
  end

  def create
    if item.update_attributes(item_params)
      flash[:success] = 'Manufacturer was successfully created'
      redirect_to manufacturer_url(inventory_item.manufacturer)
    else
      render :new
    end
  end

  def index
  end

  private

  helper_method :inventory_item
  def inventory_item
    @inventory_item ||= InventoryItem.find(params[:inventory_item_id])
  end

  helper_method :item
  def item
    @item ||= inventory_item.inventory_history_items.build event: params[:event], whodunnit: current_user.id
  end

  helper_method :items
  def items
    @items ||= inventory_item.inventory_history_items.balances.order('created_at ASC')
  end

  def item_params
    params.require(:inventory_history_item).permit(:amount, :event)
  end
end
