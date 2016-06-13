class TaskMailer < ApplicationMailer
  default from: "craig.schwartz@mitigationtechnologies.com"

  def prepare_worksheet_for(task)
    @task = task
    mail(to: task.manufacturer_email, subject: 'Worksheet from MitiTech')
  end

  def worksheet_for(task, email_params)
    @task = task
    @content = email_params[:content]
    params = {
      from: email_params[:from],
      to: email_params[:to],
      cc: email_params[:cc],
      subject: email_params[:subject] || 'Worksheet from MitiTech'
    }.delete_if { |k, v| v.nil? }
    mail(params)
  end
end
