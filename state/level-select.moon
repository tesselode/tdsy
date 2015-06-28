export levelSelect

levelSelect =
  enter: =>
    @levelButton = {}
    for i = 0, 3 do
      for j = 0, 3 do
        table.insert @levelButton, LevelButton 15 + 59 * i, 10 + 40 * j, 49, 30

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  draw: =>
    with @canvas
      \clear 0, 0, 0, 255
      \renderTo ->
        for levelButton in *@levelButton
          levelButton\draw!

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, scaleFactor, scaleFactor
