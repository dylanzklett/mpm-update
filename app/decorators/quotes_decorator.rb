class QuotesDecorator < ProjectDecorator
  decorates Project

  def price_editable?
    false
  end

  def extra_inputs(f)
  end
end
