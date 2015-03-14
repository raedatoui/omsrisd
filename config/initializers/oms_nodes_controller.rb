OMS::NodesController.class_eval do
  alias_method :old_order_collection, :order_collection

  def order_collection
    return if params[:order] && params[:order].match(/last_name/)
    old_order_collection
  end


  def search_collection
    # Workaround until Node#search returns the current scope if params blank
    if params[:order] && params[:order].match(/last_name/)
      search = @nodes.search('', params)   
    else
      search = @nodes.search(params[:term], params)
    end

    return unless search
    @nodes = search
  end
end