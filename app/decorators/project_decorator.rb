class ProjectDecorator < Draper::Decorator
  include Rails.application.routes.url_helpers
  delegate_all

  def self.decorate_for(project)
    case project.state
      when 'quotes'
        QuotesDecorator.decorate(project)
      when 'proposals'
        ProposalsDecorator.decorate(project)
      when 'orders'
        OrdersDecorator.decorate(project)
      when 'in_process'
        ProjectInProcessDecorator.decorate(project)
      when 'closed'
        ClosedDecorator.decorate(project)
      else
        raise 'Incorrect state'
    end
  end

  def editable?
    true
  end

  def price_editable?
    true
  end

  def possible_actions
    h.render 'state_actions', project: project
  end

  def extra_inputs(f)
    h.content_tag(:div, class: 'form-group') do
      f.label(:customer_number, class: 'control-label') +
      h.content_tag(:div, class: 'controls') do
        f.text_field(:customer_number, class: 'form-control')
      end
    end +
    h.content_tag(:div, class: 'form-group') do
      f.label(:sales_number, class: 'control-label') +
      h.content_tag(:div, class: 'controls') do
        f.text_field(:sales_number, class: 'form-control')
      end
    end
  end
end
