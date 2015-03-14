class OMS::RelationshipObserver < ActiveRecord::Observer

  def after_update relationship
    create_reveal_images relationship
  end

  def after_create relationship
    create_reveal_images relationship
  end

  def after_destroy relationship
    delete_reveal_images relationship # if relationship.destroyed?
  end


  protected
    def delete_reveal_images relationship
      node = relationship.node
      related_node = relationship.related
      if related_node.node_type.token == 'exhibitions' && related_node.end_date && related_node.end_date.year < 2000 && node.node_type.token == 'images'
        img = RevealImage.find_by_node_id(node.id)
        img.destroy if img
      end
    end

    def create_reveal_images relationship
      node = relationship.node
      related_node = relationship.related
      if node && related_node && node.node_type.token == 'exhibitions' && node.end_date && node.end_date.year < 2000 && related_node.node_type.token == 'images'
        RevealImage.find_or_create_by_node_id related_node.id
      end
    end
end
