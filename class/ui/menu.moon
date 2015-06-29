export class Menu
  new: (@font, @x, @y, @color, @highlightColor) =>
    @options = {}
    @spacing = @font\getHeight 'test'

    @selected = 1

  addOption: (text, onSelect) =>
    table.insert @options, {text: text, onSelect: onSelect}

  previous: =>
    @selected -= 1
    @selected = math.wrap @selected, 1, #@options

  next: =>
    @selected += 1
    @selected = math.wrap @selected, 1, #@options

  select: =>
    @options[@selected].onSelect!

  draw: =>
    with love.graphics
      for k, v in pairs @options
        if k == @selected
          .setColor @highlightColor
        else
          .setColor @color
        .printAligned v.text, @font, @x, @y + @spacing * (k - 1)
