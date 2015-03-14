OMS::NodeSerializer.class_eval do
  attributes :id, :created_at, :updated_at, :text, :published_state, :published_at,
    :html, :file, :groups, :type, :name, :weight, :followed, :updated_by,
    :author_names

  def include_created_at?
    scope.present?
  end

  def include_updated_at?
    scope.present?
  end
  
  def author_names
    ids = read_public_attribute_for_serialization(:author) || []
    if ids.any?
      OMS::Node.where('oms_nodes.id IN (?)', ids).collect(&:name)
    else
      []
    end
  end

end
