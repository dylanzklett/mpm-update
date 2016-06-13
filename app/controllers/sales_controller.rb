class SalesController < ApplicationController
  def index
    respond_to do |format|
      format.json { render json: autocomplete_sales}
    end
  end

  private

  def sales
    @sales ||= User.search_by(params[:term])
  end

  def autocomplete_sales
    sales.map do |sale|
      {
        label: sale.name_for_select,
        sales_id: sale.id
      }
    end
  end
end
