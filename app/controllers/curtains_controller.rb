class CurtainsController < ApplicationController
  def new
  end

  def create
    if curtain.update_attributes(curtain_params)
      project.populate_default_items
      flash[:success] = 'Curtain was successfully created'
      redirect_to project_url(project)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if curtain.update_attributes(curtain_params)
      project.populate_default_items
      flash[:success] = 'Curtain was successfully updated'
      redirect_to project_url(project)
    else
      render :edit
    end
  end

  def show
  end

  def destroy
    curtain.destroy
    project.populate_default_items
    flash[:success] = 'Curtain was successfully deleted'
    redirect_to project_url(project)
  end

  private
  helper_method :project
  def project
    @project ||= Project.find(params[:project_id])
  end

  helper_method :curtain
  def curtain
    @curtain ||= project.curtains.where(id: params[:id]).first ||
                 project.curtains.build(metric:          project.curtains.last.try(:metric),
                                        building_number: project.curtains.last.try(:building_number),
                                        room:            project.curtains.last.try(:room),
                                        width:           project.curtains.last.try(:width),
                                        height:          project.curtains.last.try(:height),
                                        inside:          project.curtains.last.try(:inside),
                                        wall_type:       project.curtains.last.try(:wall_type),
                                        fabric_color:    project.curtains.last.try(:fabric_color),
                                        trough_color:    project.curtains.last.try(:trough_color),
                                        center_support:  project.curtains.last.try(:center_support),
                                        end_bracket:     project.curtains.last.try(:end_bracket),
                                        quantity:        project.curtains.last.try(:quantity)
                                        )
  end

  def curtain_params
    params.require(:curtain).permit( :metric, :building_number, :room, :width, :height, :inside,
                                     :wall_type, :fabric_color, :trough_color, :center_support,
                                     :end_bracket, :quantity, :created_at, :updated_at, :price )
  end
end
