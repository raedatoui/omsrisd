OMS.PromotionItem::oldRender = OMS.PromotionItem::render
OMS.PromotionItem::render = ->
  OMS.PromotionItem::oldRender.call(@)
  if @model.node.excerpt_image?
    image = $('<div class="item-image">')
    image.append $("<img src='#{@model.node.excerpt_image.oms_thumb.url}'>")
    @$('.item-inner').prepend image

OMS.NodeIndex::oldPrepare = OMS.NodeIndex::prepare
OMS.NodeIndex::prepare = ->
  OMS.NodeIndex::oldPrepare.call(@)
  if @type.token in ['artists', 'staff_members', 'curators']
    @order 'A&ndash;Z (Last Name)', 'last_name'
