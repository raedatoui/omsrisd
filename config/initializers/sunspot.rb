Sunspot::Query::OriginalDismax = Sunspot::Query::Dismax

class Sunspot::Query::PatchedDismax < Sunspot::Query::OriginalDismax
  def to_params
    super.merge(:defType => "edismax")
  end

  def to_subquery
    super.sub("{!dismax", "{!edismax")
  end
end

Sunspot::Query.send :remove_const, :Dismax
Sunspot::Query::Dismax = Sunspot::Query::PatchedDismax
