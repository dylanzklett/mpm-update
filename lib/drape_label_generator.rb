class DrapeLabelGenerator < LabelGenerator
  def print_curtain_info(task_item)
    res = ''
    res += "PO#  #{task.project.customer_number}\n"
    res += "SO# #{task.project.sales_number}\n"
    res += "Color: #{task_item.pattern_color}\n"
    res += "Width: #{task_item.convert(:width, 'in')}in | #{task_item.convert(:width, 'cm')}cm\n"
    res += "Length:  #{task_item.convert(:height, 'in')}in | #{task_item.convert(:height, 'cm')}cm\n"
    res += "Model: #{task_item.model_code}\n"
    res += "Room: #{task_item.room}\n"
    res
  end
end
