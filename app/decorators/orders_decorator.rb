class OrdersDecorator < ProjectDecorator
  decorates Project

  def possible_actions
    super() +
    h.content_tag(:div, class: 'inline') do
      if project.drape_tasks.empty?
        h.link_to 'Create Drapery Task', new_project_drape_task_path(project), class: 'btn btn-warning'
      else
        h.link_to 'Create Drapery Task', '#', class: 'btn btn-warning show-task-dialog', data: {
          new_path: new_project_drape_task_path(project),
          open_path: project_drape_task_path(project, project.drape_tasks.last)
        }
      end
    end +
    h.content_tag(:div, class: 'inline') do
      if project.trough_tasks.empty?
        h.link_to 'Create Trough Task', new_project_trough_task_path(project), class: 'btn btn-warning'
      else
        h.link_to 'Create Trough Task', '#', class: 'btn btn-warning show-task-dialog', data: {
          new_path: new_project_trough_task_path(project),
          open_path: project_trough_task_path(project, project.trough_tasks.last)
        }
      end
    end
  end
end
