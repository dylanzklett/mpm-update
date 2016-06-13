module Projects
  class RestoresController < BaseController
    def create
      project.restore(version)
      redirect_to project_url(project)
    end

    private

    helper_method :version
    def version
      @version ||= versions.find(params[:version_id])
    end
  end
end
