module Tasks
  class DrapeTasksController < BaseController
    private
    helper_method :task
    def task
      @task ||= project.drape_tasks.where(id: params[:id]).first || project.drape_tasks.build(customer_po: project.customer_number)
    end

    def manufacturer_scope
      :draperies
    end
  end
end
