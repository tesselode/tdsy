export class Menu
  new: (@font, @x, @y, @color, @highlightColor) =>
    @options = {}
    @spacing = @font\getHeight 'test'

    @selected = 1
    @takeInput = true

  addOption: (option) =>
    option.parent = self
    table.insert @options, option
    return option

  previous: =>
    if @takeInput
      @selected -= 1
      @selected = math.wrap @selected, 1, #@options
      beholder.trigger 'menu navigate'

  next: =>
    if @takeInput
      @selected += 1
      @selected = math.wrap @selected, 1, #@options
      beholder.trigger 'menu navigate'

  secondaryPrevious: =>
    if @takeInput
      @options[@selected]\previous!
      beholder.trigger 'menu navigate'

  secondaryNext: =>
    if @takeInput
      @options[@selected]\next!
      beholder.trigger 'menu navigate'

  select: =>
    if @takeInput
      @options[@selected]\onSelect!

  draw: =>
    for k, v in pairs @options
      selected = k == @selected
      x, y = @x, @y + @spacing * (k - 1)
      v\draw x, y, selected

export class MenuOption
  new: (@text, @onSelect) =>
    @hAlign = 'center'
    @vAlign = 'middle'

  previous: =>

  next: =>

  onSelect: =>

  draw: (x, y, selected) =>
    with love.graphics
      if selected
        .setColor @parent.highlightColor
      else
        .setColor @parent.color
      .printAligned @text, @parent.font, x, y, @hAlign, @vAlign
