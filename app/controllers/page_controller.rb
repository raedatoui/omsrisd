class PageController < ApplicationController

  def index
    node_type = OMS::NodeType.find_by_token 'interests'
    @nodes = node_type.nodes.all()
    @nodes = @nodes.sort_by{|node| node.name.downcase}
  end

  def node
    @node = OMS::Node.find params[:id]
  end

end
