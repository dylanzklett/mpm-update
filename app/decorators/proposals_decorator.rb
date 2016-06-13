class ProposalsDecorator < ProjectDecorator
  decorates Project

  def possible_actions
    super() +
    h.content_tag(:div, class: 'inline') do
      h.link_to 'Prepare Email', new_project_email_path(project), class: 'btn btn-warning'
    end
  end

  def extra_inputs(f)
  end
end
