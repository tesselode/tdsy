export levelSelect

levelSelect =
  enter: =>
    @levelButton = {}
    levelNum = 0
    for i = 0, 3 do
      for j = 0, 3 do
        levelNum += 1
        table.insert @levelButton, LevelButton level[levelNum], 56 + 37 * j, 5 + 37 * i

    @selected = 1

    @cursor =
      x: 0
      y: 0
      goalX: 0
      goalY: 0

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  update: (dt) =>
    --controls
    if input\pressed 'left'
      @selected -= 1
    if input\pressed 'right'
      @selected += 1
    if input\pressed 'up'
      @selected -= 4
    if input\pressed 'down'
      @selected += 4
    @selected = math.wrap @selected, 1, 16

    if input\pressed 'primary'
      gamestate.switch game, @levelButton[@selected].level

    --selection cursor
    with @cursor
      .goalX = @levelButton[@selected].x
      .goalY = @levelButton[@selected].y
      .x = lume.lerp .x, .goalX, 20 * dt
      .y = lume.lerp .y, .goalY, 20 * dt

  draw: =>
    with @canvas
      \clear 0, 0, 0, 255
      \renderTo ->
        --draw level buttons
        for levelButton in *@levelButton
          levelButton\draw!

        --draw selection cursor
        with love.graphics
          --.setColor 226, 215, 71, 255
          --.setLineWidth 2
          --.rectangle 'line', lume.round(@cursor.x), lume.round(@cursor.y), 49, 30

          .setColor 255, 255, 255, 255
          .draw image.buttonCursor, lume.round(@cursor.x), lume.round(@cursor.y)

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, scaleFactor, scaleFactor
      .print @selected
