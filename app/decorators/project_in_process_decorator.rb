class ProjectInProcessDecorator < ProjectDecorator
  decorates Project

  def editable?
    false
  end
end
