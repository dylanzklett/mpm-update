module Tasks
  class LabelsController < ApplicationController
    def new
      pdf = task.get_box_label_pdf.generate
      send_data pdf.render, filename: 'box labels.pdf', type: 'application/pdf', disposition: :inline
    end

    private
    def task
      @task ||= Task.find(params[:task_id])
    end
  end
end
