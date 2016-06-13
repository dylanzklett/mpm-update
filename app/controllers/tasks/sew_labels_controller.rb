module Tasks
  class SewLabelsController < ApplicationController
    def new
      pdf = task.get_sew_label_pdf.generate
      send_data pdf.render, filename: 'sew labels.pdf', type: 'application/pdf', disposition: :inline
    end

    private
    def task
      @task ||= Task.find(params[:task_id])
    end
  end
end
