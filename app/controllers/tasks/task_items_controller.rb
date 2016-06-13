module Tasks
  class TaskItemsController < ApplicationController
    def edit
    end

    private
    helper_method :task
    def task
      @task = Task.find(params[:task_id])
    end
  end
end
