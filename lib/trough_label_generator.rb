class TroughLabelGenerator < LabelGenerator
  def print_curtain_info(task_item)
    res = ''
    res += "Customer Order No.  #{task.project.customer_number}\n"
    res += "Sales Order No. #{task.project.sales_number}\n"
    res += "Color: #{task_item.trough_color}\n"
    res += "Width: #{task_item.convert(:width, 'in')}in | #{task_item.convert(:width, 'cm')}cm\n"
    res += "Length:  #{task_item.convert(:height, 'in')}in | #{task_item.convert(:height, 'cm')}cm\n"
    res += "Model: #{task_item.model_code}\n"
    res += "Room: #{task_item.room}\n"
    res
  end
end
