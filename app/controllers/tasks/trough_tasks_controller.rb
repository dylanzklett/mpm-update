module Tasks
  class TroughTasksController < BaseController
    private
    helper_method :task
    def task
      @task ||= project.trough_tasks.where(id: params[:id]).first || project.trough_tasks.build(customer_po: project.customer_number)
    end

    def manufacturer_scope
      :troughs
    end
  end
end
