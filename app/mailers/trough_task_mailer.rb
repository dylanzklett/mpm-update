class TroughTaskMailer < TaskMailer
  def prepare_worksheet_for(task)
    @task = task
    mail(to: task.manufacturer_email, subject: 'Worksheet from MitiTech')
  end
end
