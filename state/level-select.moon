export levelSelect

levelSelect =
  enter: =>
    @timer = timer.new!
    @tween = flux.group!

    @levelButton = {}
    levelNum = 0
    for i = 0, 3 do
      for j = 0, 3 do
        levelNum += 1
        table.insert @levelButton, LevelButton level[levelNum], 56 + 37 * j, 5 + 37 * i

    @selected = 1

    --cosmetic
    @cursor =
      x: 0
      y: 0
      goalX: 0
      goalY: 0
    @timesY = 0
    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  timesBounceAnimation: =>
    @timesY = -4
    @tween\to(self, .1, {timesY: 0})\ease 'linear'

  update: (dt) =>
    @timer.update dt
    @tween\update dt

    --controls
    if input\pressed 'left'
      @selected -= 1
      @timesBounceAnimation!
    if input\pressed 'right'
      @selected += 1
      @timesBounceAnimation!
    if input\pressed 'up'
      @selected -= 4
      @timesBounceAnimation!
    if input\pressed 'down'
      @selected += 4
      @timesBounceAnimation!
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

        with love.graphics
          --draw selection cursor
          .setColor color.white
          .draw image.buttonCursor, lume.round(@cursor.x), lume.round(@cursor.y)

          --level info
          best = saveManager.data.level[@selected].best
          local bestRank
          if best
            bestRank = level[@selected]\getRank best
          else
            bestRank = 4
          local next
          if best
            next = level[@selected]\getNext best
          else
            next = level[@selected].time.silver

          .push!
          .translate 0, -@timesY

          --print best time
          .printAligned 'Best: ', font.time, 75, 150, 'center'
          local bestText, bestColor
          if best
            bestText = string.format '%0.2f', best
            .setColor color.rank[bestRank]
          else
            bestText = '--'
            .setColor color.rank[4]
          .printAligned bestText, font.time, 75, 170, 'center'

          --print next time
          .setColor 255, 255, 255, 255
          .printAligned 'Goal: ', font.time, WIDTH - 75, 150, 'center'
          local nextText
          if bestRank < 3
            nextText = '--'
            .setColor color.rank[4]
          else
            nextText = string.format '%0.1f', next
            .setColor color.rank[bestRank - 1]
          .printAligned nextText, font.time, WIDTH - 75, 170, 'center'

          .pop!

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, scaleFactor, scaleFactor
      .print @selected
