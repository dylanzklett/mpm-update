module Projects
  class BaseController < ::ApplicationController
    private

    helper_method :project
    def project
      @project ||= Project.find(params[:project_id])
    end

    helper_method :versions
    def versions
      @versions ||= project.versions.order('created_at ASC')
    end
  end
end
