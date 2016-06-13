module Projects
  class VersionsController < BaseController
    def index
    end

    def show
    end

    def update
    end

    private

    helper_method :project_version
    def project_version
      @project_version ||= version.object
    end

    helper_method :version
    def version
      @version ||= versions.find(params[:id])
    end
  end
end
