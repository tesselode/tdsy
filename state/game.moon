export game

game =
  enter: =>
    @map = Map!

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  update: (dt) =>
    @map\update dt

  draw: =>
    with @canvas
      \clear 0, 0, 0, 255
      \renderTo ->
        @map\draw!

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, scaleFactor, scaleFactor
