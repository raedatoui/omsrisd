# Patch to limit which block types get shown in different contexts
SirTrevor.Editor::__setBlocksTypes__ = SirTrevor.Editor::_setBlocksTypes
SirTrevor.Editor::_setBlocksTypes = ->
  @__setBlocksTypes__()
  _(@blockTypes).each (_, type) =>
    if SirTrevor.Blocks.hasOwnProperty(type)
      if SirTrevor.Blocks[type].isAvailable? and
          not SirTrevor.Blocks[type].isAvailable.call(@)
        delete this.blockTypes[type]

# Patch to allow bullets to be added with markdown syntax
SirTrevor.__toMarkdown__ = SirTrevor.toMarkdown
SirTrevor.toMarkdown = (content, type) ->
  md = SirTrevor.__toMarkdown__(content, type)
  md = md.replace /\\\*/g, "*" if md?
  md

# Remove bold formatter
delete SirTrevor.Formatters.Bold

# Create custom formatters for headlines
Header = SirTrevor.Formatter.extend
  title: "bold",
  cmd: "insertText",
  text: "#"
  onClick: ->
    if window.getSelection
        window.getSelection().collapseToStart()
    else if sel = document.selection && sel.type == "Text"
        range = sel.createRange()
        range.collapse(true)
        range.select()
    document.execCommand @cmd, false, @text + ' '

Subheader = Header.extend
  text: "##"

SirTrevor.Formatters.Header = new Header
SirTrevor.Formatters.Subheader = new Subheader
