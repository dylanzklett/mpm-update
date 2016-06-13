module Tasks
  class EmailsController < ApplicationController
    def new
    end

    def create
      task.mailer.worksheet_for(task, email_params).deliver_later
      flash[:success] = 'Email has been sent'
      if task.project
        redirect_to url_for([task.project, task])
      else
        redirect_to url_for(task)
      end
    end

    private
    helper_method :task
    def task
      @task ||= Task.find(params[:task_id])
    end

    helper_method :content
    def content
      @content ||= task.mailer.prepare_worksheet_for(task).body
    end

    helper_method :email_params
    def email_params
      return unless params[:email].present?
      params.require(:email).permit(:content, :from, :to, :cc, :subject)
      @email_params ||= params[:email].delete_if { |k, v| v.presence.nil? }
    end
  end
end
