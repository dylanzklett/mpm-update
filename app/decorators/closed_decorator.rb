class ClosedDecorator < ProjectDecorator
  decorates Project

  def editable?
    false
  end
end
