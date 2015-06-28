export levelSelect

levelSelect =
  enter: =>
    @levelButton = {}
    levelNum = 0
    for i = 0, 3 do
      for j = 0, 3 do
        levelNum += 1
        table.insert @levelButton, LevelButton level[levelNum], 15 + 59 * j, 10 + 40 * i, 49, 30

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
          .setColor 226, 215, 71, 255
          .setLineWidth 2
          .rectangle 'line', @cursor.x, @cursor.y, 49, 30

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, scaleFactor, scaleFactor
      .print @selected
