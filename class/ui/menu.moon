export class Menu
  new: (@font, @x, @y, @color, @highlightColor) =>
    @options = {}
    @spacing = @font\getHeight 'test'

    @selected = 1
    @takeInput = true

  addOption: (option) =>
    option.parent = self
    table.insert @options, option

  previous: =>
    if @takeInput
      @selected -= 1
      @selected = math.wrap @selected, 1, #@options

  next: =>
    if @takeInput
      @selected += 1
      @selected = math.wrap @selected, 1, #@options
      
  secondaryPrevious: =>
    if @takeInput
      @options[@selected]\previous!
      
  secondaryNext: =>
    if @takeInput
      @options[@selected]\next!

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
    
  previous: =>
    
  next: =>
    
  select: =>
    
  draw: (x, y, selected) =>
    with love.graphics
      if selected
        .setColor @parent.highlightColor
      else
        .setColor @parent.color
      .printAligned @text, @parent.font, x, y