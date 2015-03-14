OMS::Node.class_eval do
  searchable do
    string :last_name do
      if self.respond_to?(:sortable_name) && self.sortable_name.present?
        self.sortable_name
      else
        self.name.split(' ').reverse.join(' ')
      end
    end
  end

  matcher(/^order$/) do |value, name|
    property, direction = value.split(' ')
    
    if property == "last_name"
      direction = direction ? direction.downcase.to_sym : :asc 
      order_by :last_name, direction
    end
  end
end
