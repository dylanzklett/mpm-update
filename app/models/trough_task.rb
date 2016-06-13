class TroughTask < Task
  FOAM_FACTOR_BY_SIZE = {
      '9-15' => 2,
      '16-25' => 2,
      '26-45' => 3,
      '46-80' => 3,
      '81-150' => 4,
      '151-230' => 4
  }

  def populate_task_items
    project.curtains.each do |curtain|
      task_items.create quantity: curtain.quantity,
                        trough_color: curtain.trough_color,
                        room: curtain.room,
                        width: curtain.width,
                        height: curtain.height,
                        trough_size: Setting.trough_for(curtain.width, curtain.height)
    end
  end

  def populate_support_items
    support_items.destroy_all
    add_boxes
    add_foam_for_boxes
    add_end_cups_for_boxes
  end

  def mailer
    TroughTaskMailer
  end

  def worksheet_name
    'Trough Worksheet'
  end

  def task_items_partial_name
    'trough_task_item'
  end

  def task_type
    :trough_task_items
  end

  def get_box_label_pdf
    TroughLabelGenerator.new(self)
  end

  def summary_items
    items ||= {}
    return items unless manufacturer
    task_items.each do |task_item|
      if items[task_item.trough_size].present?
        items[task_item.trough_size][:quantity] += task_item.quantity
        items[task_item.trough_size][:price_total] = items[task_item.trough_size][:quantity] * items[task_item.trough_size][:price_per]
      else
        price_per = manufacturer.services.where(name: task_item.trough_size).first.try(:price) || 0
        items[task_item.trough_size] = {
          name: task_item.trough_size,
          quantity: task_item.quantity,
          price_per: price_per,
          price_total: price_per * task_item.quantity
        }
      end
    end
    items
  end

  def full_price
    summary_items.values.sum{|item| item[:price_total]}
  end

  private

  def add_boxes
    task_items.select('SUM(quantity) as box_quantity, substring(trough_size from \'[\d\-]+$\') as box_size').group(:box_size).each do |item|
      support_items.create name: "#{item.box_size} Box", unit: 'each', quantity: item.box_quantity
    end
  end

  def add_foam_for_boxes
    foam_quantity = support_items.where("name like '%Box%'").inject(0) do |sum, box_item|
      size = box_item.name.split(' ').first
      sum + (box_item.quantity * FOAM_FACTOR_BY_SIZE.fetch(size, 0))
    end

    support_items.create name: 'Foam', unit: 'each', quantity: foam_quantity
  end

  def add_end_cups_for_boxes
    task_items.select('SUM(quantity) as box_quantity, substring(trough_size from 1 for 1) as caps_type').group(:caps_type).each do |item|
      support_items.create name: "#{item.caps_type} end cups", unit: 'Pair', quantity: item.box_quantity
    end
  end
end
