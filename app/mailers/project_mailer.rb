class ProjectMailer < ApplicationMailer
  default from: "craig.schwartz@mitigationtechnologies.com"

  def prepare_proposal_for(project)
    @project = project
    mail(to: project.customer.email, subject: 'New Proposal')
  end

  def proposal_for(project, email_params)
    @project = project
    @content = email_params[:content]
    params = {
      from: email_params[:from],
      to: email_params[:to],
      cc: email_params[:cc],
      subject: email_params[:subject] || 'New Proposal'
    }.delete_if { |k, v| v.nil? }
    mail(params)
  end
end
