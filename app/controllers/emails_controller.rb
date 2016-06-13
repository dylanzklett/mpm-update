class EmailsController < ApplicationController
  def new
  end

  def create
    ProjectMailer.proposal_for(project, email_params).deliver_later
    flash[:success] = 'Proposal has been sent'
    redirect_to project_url(project)
  end

  private
  helper_method :project
  def project
    @project ||= Project.find(params[:project_id])
  end

  helper_method :content
  def content
    @content ||= ProjectMailer.prepare_proposal_for(project).body
  end

  helper_method :email_params
  def email_params
    return unless params[:email].present?
    params.require(:email).permit(:content, :from, :to, :cc, :subject)
    @email_params ||= params[:email].delete_if { |k, v| v.presence.nil? }
  end
end
