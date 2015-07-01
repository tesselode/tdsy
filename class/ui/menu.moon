export class Menu
  new: (@font, @x, @y, @color, @highlightColor) =>
    @options = {}
    @spacing = @font\getHeight 'test'

    @selected = 1
    @takeInput = true

  addOption: (text, onSelect) =>
    table.insert @options, {text: text, onSelect: onSelect}

  previous: =>
    if @takeInput
      @selected -= 1
      @selected = math.wrap @selected, 1, #@options

  next: =>
    if @takeInput
      @selected += 1
      @selected = math.wrap @selected, 1, #@options

  select: =>
    if @takeInput
      @options[@selected].onSelect!

  draw: =>
    with love.graphics
      for k, v in pairs @options
        if k == @selected
          .setColor @highlightColor
        else
          .setColor @color
        .printAligned v.text, @font, @x, @y + @spacing * (k - 1)
