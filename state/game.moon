export game

game =
  enter: =>
    @map = Map!
    @playerInput = PlayerInput @map.fish

    --game flow
    @time = 0

    --cosmetic
    @hud = Hud self

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  update: (dt) =>
    @playerInput\update dt
    @map\update dt

    --game flow
    @time += dt

  draw: =>
    with @canvas
      \clear 0, 0, 0, 255
      \renderTo ->
        @map\draw!
        @hud\draw!

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, scaleFactor, scaleFactor
