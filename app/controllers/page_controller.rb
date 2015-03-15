class PageController < ApplicationController

  def index
    @nodes = OMS::Node.all()
  end

end
