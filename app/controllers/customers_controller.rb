class CustomersController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: autocomplete_customers}
    end
  end

  def new
  end

  def create
    if customer.update_attributes(customer_params)
      flash[:success] = 'Customer was successfully created'
      if params.has_key? :with_project
        customer.projects.create!(sales_id: customer.sales_id)
        redirect_to project_url(customer.projects.last)
      else
        redirect_to customers_url
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if customer.update_attributes(customer_params)
      flash[:success] = 'Customer was successfully updated'
      redirect_to customers_url
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    customer.destroy
    flash[:success] = 'Customer was successfully deleted'
    redirect_to customers_url
  end

  private

  helper_method :customers
  def customers
    @customers ||= Customer.search_by(params[:term])
  end

  helper_method :sales
  def sales
    @sales ||= User.all
  end

  helper_method :customer
  def customer
    @customer ||= Customer.where(id: params[:id]).first || Customer.new
  end

  def autocomplete_customers
    customers.map do |customer|
      {
          label: customer.name_for_select,
          customer_id: customer.id,
          sales_id: customer.sales_id,
          sales_data: customer.sales_name_for_select
      }
    end
  end

  def customer_params
    params.require(:customer).permit(:email, :sales_id,
                                     profile_attributes: [:id, :first_name, :last_name, :first_title, :second_title, :first_address,
                                                          :second_address, :country, :city, :state, :zip, :phone_o, :phone_c])
  end

end
