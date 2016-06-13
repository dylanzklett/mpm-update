module Tasks
  class BaseController < ::TasksController
    private
    helper_method :project
    def project
      @project = Project.find(params[:project_id])
    end
  end
end
