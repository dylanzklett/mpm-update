class ProjectsController < ApplicationController
  def index
  end

  def new
  end

  def create
    if project.update_attributes(project_params)
      flash[:success] = 'Project was successfully created'
      redirect_to project_url(project)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if project.update_attributes(project_params)
      flash[:success] = 'Project was successfully updated'
      redirect_to project_url(project)
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    project.destroy
    flash[:success] = 'Project was successfully deleted'
    redirect_to projects_url
  end

  private

  helper_method :term
  def term
    @term ||= params[:term]
  end

  helper_method :projects
  def projects
    @projects ||= Project.all
  end

  helper_method :project
  def project
    @project ||= ProjectDecorator.decorate_for(Project.where(id: params[:id]).first || Project.new)
  end

  def project_params
    params.require(:project).permit(:customer_number, :sales_number, :sales_id, :customer_id, :discount, :price,
                                    items_attributes: [:id, :name, :unit, :quantity, :price, :_destroy])
  end
end
