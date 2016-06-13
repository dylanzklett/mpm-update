class DrapeTask < Task
  def populate_task_items
    project.curtains.each do |curtain|
      task_items.create quantity: curtain.quantity,
                        pattern_color: curtain.fabric_color,
                        room: curtain.room,
                        width: curtain.width,
                        height: curtain.height,
                        width_per_curt: ( curtain.width / Setting.get_devider).ceil,
                        finished_length: curtain.height * 2
    end
  end

  def populate_support_items
    support_items.destroy_all
    add_fabrics
    add_weight
    add_shirring
    add_tape
    add_box
  end

  def mailer
    DrapeTaskMailer
  end

  def worksheet_name
    'Drape Worksheet'
  end

  def task_items_partial_name
    'drape_task_item'
  end

  def task_type
    :drape_task_items
  end

  def get_box_label_pdf
    DrapeLabelGenerator.new(self)
  end

  def get_sew_label_pdf
    DrapeSewLabelGenerator.new(self)
  end

  def full_width_count
    task_items.inject(0){|acc, task_item| acc + (task_item.width_per_curt * task_item.quantity) }
  end

  def full_price
    price_for_width * full_width_count
  end

  def price_for_width
    manufacturer.try(:price_for_width) || 0
  end

  private

  def add_fabrics
    self.task_items.select('SUM(calculated_fabric) as calculated_fabric, pattern_color').group(:pattern_color).each do |item|
      self.support_items.create name: "fabric #{item.pattern_color}", unit: 'yards', quantity: item.calculated_fabric.try(:round, 2)
    end
  end

  def add_weight
    self.task_items.select('SUM(calculated_weight) as calculated_weight').each do |item|
      self.support_items.create name: "Weight", unit: 'yards', quantity: item.calculated_weight.try(:round, 2)
    end
  end

  def add_shirring
    self.task_items.select('SUM(calculated_shirring) as calculated_shirring').each do |item|
      self.support_items.create name: "shirring", unit: 'yards', quantity: item.calculated_shirring.try(:round, 2)
    end
  end

  def add_tape
    self.task_items.select('SUM(calculated_tape) as calculated_tape').each do |item|
      self.support_items.create name: "1/4\" tape", unit: 'yards', quantity: item.calculated_tape.try(:round, 2)
    end
  end

  def add_box
    self.task_items.select('SUM(quantity) as box_quantity').each do |item|
      self.support_items.create name: 'box', unit: 'unit', quantity: item.box_quantity
    end
  end
end
