class ItemsController < ApplicationController
  def edit
  end

  def update
    if item.update_attributes(item_params)
      project.fix_price_with 'Item list changed'
      flash[:success] = 'Item was successfully updated'
      redirect_to project_url(project)
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    item.destroy
    project.fix_price_with 'Item list changed'
    flash[:success] = 'Item was successfully deleted'
    redirect_to project_url(project)
  end

  private
  helper_method :project
  def project
    @project ||= Project.find(params[:project_id])
  end

  helper_method :item
  def item
    @item ||= project.items.where(id: params[:id]).first ||
              project.items.build()
  end

  def item_params
    params.require(:item).permit(:name, :quantity, :price)
  end
end
