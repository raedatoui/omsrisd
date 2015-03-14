class OMS::NodeObserver < ActiveRecord::Observer

  def after_update node
    if node.node_type.token == 'institution_pages'
      reload_routes
    end
  end

  def after_create node
    if node.node_type.token == 'institution_pages'
      reload_routes
    end
  end

  def after_destroy node
    if node.node_type.token == 'institution_pages'
      reload_routes
    end
  end

  protected

  def reload_routes
    DynamicRouter.reload
  end


end
