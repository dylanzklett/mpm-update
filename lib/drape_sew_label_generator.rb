class DrapeSewLabelGenerator < LabelGenerator
  def initialize(task)
    @task = task
    @pdf = Prawn::Document.new :margin => [90.70, 73.70, 0, 0]
  end

  def settings
    @settings ||= {
      # 1 in = 72 pdf pt
      cell_width: 227,
      cell_height: 124.42,
      cell_right_margin: 0,
      item_on_page: 5,
      header_height: 31.1811,
      footer_height: 19.8425
    }
  end

  def generate
    start_x_pos = pdf.bounds.right - settings[:cell_width]
    start_y_pos = pdf.bounds.top

    labels_text = []
    task.task_items.each_with_index do |task_item|
      task_item.quantity.times do
        labels_text << print_curtain_info(task_item)
      end
    end

    labels_text.each_with_index do |label_text, index|

      pdf.start_new_page if (index/settings[:item_on_page]).to_i != 0 &&
                        ((index-1)/settings[:item_on_page]).to_i != (index/settings[:item_on_page]).to_i
      inner_index = index % settings[:item_on_page]
      x_pos = pdf.bounds.right - settings[:cell_width]
      y_pos = start_y_pos - ((inner_index).to_i*settings[:cell_height])
      pdf.bounding_box [x_pos, y_pos], width: settings[:cell_width], height: settings[:cell_height] do
        pdf.move_down settings[:header_height]
        pdf.indent 60 do
          pdf.text label_text, size: 10
        end
        pdf.move_down settings[:footer_height]
      end
    end
    pdf
  end

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
