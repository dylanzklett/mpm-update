module ApplicationHelper
  def link_to_remove_fields(name, f, function)
    f.hidden_field(:_destroy) + link_to(name, '#', onclick: "#{function}(this); return false;")
  end

  def link_to_add_fields(name, f, association, function)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    content_tag :a, name, href: '#', onclick: "#{function}(this, '#{association}', '#{escape_javascript(fields)}'); return false;"
  end

  def find_version_author_name(version)
    user = User.find_version_author(version)
    user ? user.email : version.whodunnit
  end

  def find_version_customer_name(customer_id)
    Customer.where(id: customer_id).first.try :email
  end

  def find_version_sales_name(sales_id)
    User.where(id: sales_id).first.try :email
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end
end
