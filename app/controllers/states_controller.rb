class StatesController < ApplicationController
  def update
    update_project_event
    project.save
    redirect_to project_url(project)
  end

  private

  helper_method :project
  def project
    @project ||= Project.find(params[:project_id])
  end

  def update_project_event
    method_event = ([project_params[:event].to_sym] & project.aasm.events.map(&:name)).first
    if method_event
      project.send(method_event)
    else
      raise Errors::UnprocessableEntity
    end
  end

  def project_params
    params.require(:project).permit(:event)
  end

end
