class TasksController < ApplicationController
  def index
  end

  def new
  end

  def create
    task.update_attributes(task_params)
    flash[:success] = 'Task was successfully created'
    if task.project
      redirect_to url_for([task.project, task])
    else
      redirect_to task_url(task)
    end
  end

  def edit
  end

  def update
    task.update_attributes(task_params)
    flash[:success] = 'Task was successfully updated'
    if task.project
      redirect_to url_for([task.project, task])
    else
      redirect_to task_url(task)
    end
  end

  def show
  end

  def destroy
    task.destroy
    flash[:success] = 'Task was successfully deleted'
    if task.project
      redirect_to project_path(task.project)
    else
      redirect_to tasks_url
    end
  end

  private

  helper_method :tasks
  def tasks
    @tasks ||= Task.all.order("#{sort_column} #{sort_direction}").page(params[:page]).per(50)
  end

  helper_method :manufacturers_for_select
  def manufacturers_for_select
    @manufacturers_for_select ||= manufacturers.map{ |manufacturer| [manufacturer.title, manufacturer.id] }
  end

  helper_method :task
  def task
    @task ||= Task.where(id: params[:id]).first || Task.new
  end

  def task_params
    params.require(task.class.to_s.underscore.to_sym).permit(
      :ship_via, :ship_to, :instructions, :mitech_po, :date_wanted,
      :mitech_rec_date, :pref_ship_method, :customer_po,
      :manufacturer_id, :status, :support_update,
      drape_task_items_attributes: [:id, :quantity, :width_per_curt, :finished_length_in, :pattern_color, :room, :width_in, :height_in, :_destroy],
      trough_task_items_attributes: [:id, :quantity, :trough_size, :trough_color, :room,  :width_in, :height_in, :_destroy],
      support_items_attributes: [:id, :name, :unit, :quantity, :_destroy])
  end

  def manufacturer_scope
    :all
  end

  def manufacturers
    Manufacturer.send(manufacturer_scope)
  end

  helper_method :sort_column
  def sort_column
    params[:sort] || "mitech_rec_date"
  end

  helper_method :sort_direction
  def sort_direction
    params[:direction] || "asc"
  end
end
