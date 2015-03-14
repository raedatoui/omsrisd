# SirTrevor.DEBUG = true

BasicBlock = SirTrevor.Block.extend

  template: _.template("""
    <header>
      <div class='title'><%= title %></div>
    </header>
    """)

  initialize: ->
    @$el.addClass 'st-embed'
    @$el.addClass 'st-embed-' + @type

  loadData: (data) ->
    @data = _(data).defaults(@defaults or {})

  toData: ->
    @setData @data

  onBlockRender: ->
    @$editor.html @template title: @title?() or @title

SelectBlock = BasicBlock.extend

  options: []

  selectTemplate: _.template("""
    <div class='st-select'>
      <%= type %>: <select></select>
    </div>
    """)

  template: _.template("""
    <header>
      <div class='type'><%= type %></div>
      <div class='title'><%= title %></div>
    </header>
    <div class='options'></div>
    """)

  idAttr: 'id'

  validations: ['selectionRequired']

  initialize: ->
    _.bindAll this, 'changeSelect'

    @data or= _(@defaults or {}).clone()
    @editor = SirTrevor.getInstance(@instanceID)
    @model = @editor.options.model

    @$el.on 'change', '.st-select select', @changeSelect
    @$el.addClass 'st-embed'
    @$el.addClass 'st-embed-' + @type
    @bind 'onRender', =>
      @$editor.html t('nodes.field.loading')

  onBlockRender: ->
    if @data[@idAttr]?
      selection = @getSelection()
      if selection? then @renderSelection() else @onError()
    else
      @renderSelect()

  getSelection: ->

  getSelectionName: (thing) -> thing.name
  getSelectionID: (thing) -> thing[@idAttr]

  renderSelect: ->
    options = @options?() or @options
    $output = $('<div>').append @selectTemplate type: @title?() or @title
    $output.find('select').append(@createOption(''))
    for option in options
      $output.find('select').append(@createOption(option))
    @$editor.html($output)

  createOption: (option) ->
    $option = $('<option>')

    unless option is ''
      name = @getSelectionName option
      val = @getSelectionID option
      $option.text(name).val(val)

    $option

  changeSelect: ->
    @data[@idAttr] = @$el.find('.st-select select').val()
    @renderSelection()

  renderSelection: ->
    selection = @getSelection()
    if selection?
      editor_html = @template
        title: @getSelectionName selection
        type: @title?() or @title
      @$editor.html(editor_html)

  onError: -> @remove()

  selectionRequired: ->
    @setError @$el, 'You must choose something to embed' unless @data[@idAttr]?

SirTrevor.Blocks.Node = SelectBlock.extend

  type: 'node'
  title: 'Media'

  options: -> OMS.RelatedNode.media()

  getSelection: ->
    try OMS.RelatedNode.find(@data.id) catch

  renderSelection: ->
    selection = @getSelection()
    if selection?
      editor_html = @template
        title: selection.name
        type: selection.node_type().name

      @$editor.html(editor_html)

      if selection.file?
        $img = $('<img>')
          .attr('src', selection.file.oms_thumb.url)
          .addClass('preview')
        @$editor.find('header').append $img

  onError: ->
    # Related Nodes probably haven't been loaded yet, so waiting...
    OMS.RelatedNode.one 'refresh', => @onBlockRender()

SirTrevor.Blocks.List = SelectBlock.extend

  type: 'list'
  idAttr: 'token'

  options: -> OMS.RelatedNode.types()

  getSelection: ->
    OMS.NodeType.findByAttribute 'token', @data.token

  getSelectionName: (thing) ->
    _.pluralize thing.name

SirTrevor.Blocks.Field = SelectBlock.extend

  type: 'field',
  idAttr: 'token'

  options: ->
    definitions = @model.node_type().custom_field_definitions
    definition for definition in definitions when definition.data_type is 'Nodes'

  getSelection: ->
    _(@options()).findWhere token: @data.token

SirTrevor.Blocks.Group = SelectBlock.extend

  type: 'group'
  title: 'Stack'
  idAttr: 'name'

  displayOptions: ['gallery', 'carousel']
  
  optionsTemplate: _("""
    <div class="group-title"></div>
    <div class="group-display-title"></div>
    <div class="group-display"></div>
    <div class="group-order"></div>
  """).template()
  
  optionTemplate: _("""
    <label>
      <input type="radio" name="<%= name %>" value="<%= value %>">
      <%= _(value).capitalize() %>
    </label>""").template()

  titleTemplate: _("""
    <label>
      Title
      <input type="text" name="<%= name %>">
    </label>""").template()

  displayTitleTemplate: _("""
    <label>
      <input type="checkbox" name="<%= name %>">
      Display stack title
    </label>""").template()

  nodeTemplate: _("""<div class="group-node" data-id="<%= node.id %>">
    <header>
      <div class="title"><%= node.name %></div>
      <div class="type"><%= node.node_type().name %></div>
      <div class="handle"></div>
    </header>
    <div class="options"></div>
  </div>""").template()

  defaults:
    display: 'gallery'
    # This is a string because it gets improperly saved as such currently
    displayTitle: 'true'
    order: []

  nodeDefaults:
    display: 'medium'

  options: -> OMS.RelatedNode.groups()

  renderSelection: ->
    SelectBlock::renderSelection.call(@)

    group = @getSelection()
    @$inner.css
      backgroundColor: "##{group.color}"
      borderColor: "##{group.color}"

    @renderOptions()

  getSelection: ->
    _(@options()).findWhere name: @data.name

  onError: ->
    # Related Nodes probably haven't been loaded yet, so waiting...
    OMS.RelatedNode.one 'refresh', => @onBlockRender()

  renderOptions: ->

    @$options = @$el.find('.options')
    @$options.append @optionsTemplate()

    @$editor.find("> header .title")
      .append($('<a class="toggle-options edit">')
      .text('Edit'))
      
    @$inner.on 'click', '.toggle-options', =>
      @$el.toggleClass('editing')
      
    @$inner.on 'click', '.group-display input[type="radio"]', =>
      @data.display = @$el.find('.group-display input:checked').val()
      
    @$inner.on 'click', '.group-node input[type="radio"]', =>
      @updateGroupOrder()
      
    @$inner.on 'change', '.group-display-title input', =>
      @data.displayTitle = @$el.find('.group-display-title input').is(':checked').toString()
      
    @$inner.on 'change', '.group-title input', =>
      @data.title = @$el.find('.group-title input').val()
    
    @renderTitleOptions()
    @renderTitleDisplayOptions()
    @renderDisplayOptions()
    @renderNodes()
  
  renderTitleOptions: ->
    $display = @$el.find('.group-title').empty()
    uid = _.uniqueId()

    $display.append @titleTemplate name: "title-" + uid
    $display.find('input').val @data.title or @data.name
  
  renderTitleDisplayOptions: ->
    $display = @$el.find('.group-display-title').empty()
    uid = _.uniqueId()

    $display.append @displayTitleTemplate name: "display-title-" + uid
    $display.find('input').prop 'checked', @data.displayTitle is 'true'

  renderDisplayOptions: ->
    $display = @$el.find('.group-display').empty()
    uid = _.uniqueId()

    _(@displayOptions).each (option) =>
      view = $ @optionTemplate
        name: "display-" + uid,
        value: option
      view.find('input').prop 'checked', option is @data.display
      $display.append view

  renderNodes: ->
    @$el.find('.group-order').empty()
    @$el.find('.group-order').sortable
      items: "> .group-node"
      axis: "y"
      containment: "parent"
      handle: '.handle'
      update: => @updateGroupOrder()
      scroll: false
      tolerance: 'pointer'

    _(@sortedGroup()).each (node) =>
      @renderNode node

    @updateGroupOrder()

  renderNode: (node) ->
    options = _.defaults _(@data.order).findWhere(id: "#{node.id}") or {}, @nodeDefaults
    uid = _.uniqueId()
    view = $ @nodeTemplate node: node

    if node.file?
      img = $('<img>').attr('src', node.file.oms_thumb.url)
      img.addClass 'preview'
      view.find('header').append img

    _(['small', 'medium', 'large']).each (option) =>
      $option = $ @optionTemplate
        name: "group-node-size-#{node.id}-#{uid}"
        value: option
      $option.find('input').prop 'checked', option is options.display
      view.find('.options').append $option

    @$el.find('.group-order').append view

  updateGroupOrder: ->
    nodes = []
    @$el.find('.group-node').each (i, node) ->
      nodes.push
        id: $(node).data('id'),
        display: $(node).find('.options input:checked').val()
    @data.order = nodes

  sortedGroup: ->
    group = OMS.RelatedNode.ofGroup(@getSelection())
    order = _(@data.order).reject (o) -> not o?
    _(group).sortBy (node) ->
      o = _(order).findWhere id: "#{node.id}"
      i = _(order).indexOf(o)
      if i == -1 then Infinity else i

SirTrevor.Blocks.Code = SirTrevor.Blocks.Text.extend
  type: 'code'
  title: 'HTML'

  formattable: false
  hasTextBlock: false

  editorHTML: '<div class="st-required st-text-block st-code-block" contenteditable="true"></div>'

  toData: ->
    @setData 
      html: @$el.find('.st-code-block').html()

  loadData: (data) ->
    @$el.find('.st-code-block').html data?.html

  onContentPasted: ->
    # Do nothing...

# Sir Trevor requires some data to be added to validate the save
InstitutionBlock = BasicBlock.extend

  template: _.template("""
    <header>
      <div class='type'>ICA</div>
      <div class='title'><%= title %></div>
    </header>
    """)

  toData: -> @setData institution: true

InstitutionBlock.isAvailable = ->
  @options.model?.type is 'institution_pages'

SirTrevor.Blocks.MailingList = InstitutionBlock.extend
  type: 'mailing_list'

SirTrevor.Blocks.PurchaseForm = InstitutionBlock.extend
  type: 'purchase_form'

SirTrevor.Blocks.DonateButton = BasicBlock.extend
  type: 'donate_button'

  template: _.template("""
    <header>
      <div class='title'><%= title %></div>
      <div class='type'>ICA</div>
      <div class='options'>
        <label>
          URL
          <input type='text' class='donate-button-url'>
        </label>
      </div>
    </header>
    """)

  defaults:
    url: ''

  initialize: ->
    @$el.addClass 'st-embed'
    @$el.addClass 'st-embed-' + @type

  toData: ->
    @data = url: @$el.find('input').val()
    @setData @data

  onBlockRender: ->
    @$editor.html @template title: @title?() or @title

    @$el.find('input').val @data?.url

    $editLink = $('<a class="toggle-options edit">').text('Edit')

    @$editor.find("> header .title").append $editLink
    @$inner.on 'click', '.toggle-options', =>
      @$el.toggleClass('editing')

SirTrevor.Blocks.SocialLinks = InstitutionBlock.extend
  type: 'social_links'

SirTrevor.Blocks.Hours = InstitutionBlock.extend
  type: 'hours'

SirTrevor.Blocks.PressReleases = InstitutionBlock.extend
  type: 'press_releases'

# Sir Trevor requires some data to be added to validate the save
ICAat50Block = BasicBlock.extend
  template: _.template("""
    <header>
      <div class='type'>ICA@50</div>
      <div class='title'><%= title %></div>
    </header>
    """)

  toData: -> @setData institution: true

ICAat50Block.isAvailable = ->
  @options.model?.id is 3580

SirTrevor.Blocks.CurrentExhibitions = ICAat50Block.extend
  type: 'current_exhibitions'

SirTrevor.Blocks.CurrentPrograms = ICAat50Block.extend
  type: 'current_programs'
  title: 'Programs (Happening This Week)'
