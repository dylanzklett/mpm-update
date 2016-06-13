require 'prawn'

class LabelGenerator
  attr_accessor :pdf, :task

  def initialize(task)
    @task = task
    @pdf = Prawn::Document.new :margin => [36, 12.024, 36, 12.024]
  end

  def settings
    @settings ||= {
      # 1 in = 72 pdf pt
      cell_width: 288,
      cell_height: 144,
      cell_right_margin: 12.024,
      item_on_page: 10,
      header_height: 40,
      footer_height: 35
    }
  end

  def generate
    start_x_pos = pdf.bounds.right
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

      x_pos = (inner_index%2 * (settings[:cell_width] + settings[:cell_right_margin])) + (inner_index%2)
      y_pos = start_y_pos - ((inner_index/2).to_i*settings[:cell_height])
      pdf.bounding_box [x_pos, y_pos], width: settings[:cell_width], height: settings[:cell_height] do
        draw_header settings[:header_height]
        pdf.indent 60 do
          pdf.text label_text, size: 10
        end
        draw_footer
      end
    end
    pdf
  end

  def draw_header(height)
    prawn_logo = Rails.root.join('app', 'assets', 'images', 'label_safetydrape_logo.png')
    pdf.image prawn_logo, width: 192, height: 30, position: :center
    pdf.move_down 5
  end

  def draw_footer
    first_str = '<i><b>Mitigation Technologies</b>, Baltimore MD</i>'
    second_str = 'www.mitigationtechnologies.com 800-616-ATFP(2837)'
    pdf.move_down 5
    pdf.text_box first_str, inline_format: true, at: [0, pdf.cursor], width: settings[:cell_width], align: :center, size: 7
    pdf.move_down 7
    pdf.text_box second_str, inline_format: true, at: [0, pdf.cursor], width: settings[:cell_width], align: :center, size: 7
  end
end
