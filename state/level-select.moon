export levelSelect

levelSelect =
  enter: (previous) =>
    @timer = timer.new!
    @tween = flux.group!

    --get completion percentage
    completionPoints = 0
    for k, v in pairs level
      best = saveManager.data.level[k].best
      if best
        rank = v\getRank best
        if rank == 1
          completionPoints += 3
        elseif rank == 2
          completionPoints += 2
        elseif rank == 1
          completionPoints += 1
    @completionPercentage = (completionPoints / 48) * 100

    --create level buttons
    @levelButton = {}
    levelNum = 0
    for i = 0, 3 do
      for j = 0, 3 do
        levelNum += 1
        table.insert @levelButton, LevelButton level[levelNum], 56 + 37 * j, 5 + 37 * i

    --controls
    @selected = 1
    @takeInput = true

    --cosmetic
    @cursor =
      x: 0
      y: 0
      goalX: 0
      goalY: 0
    @timesY = 0
    @canvas = love.graphics.newCanvas WIDTH, HEIGHT
    @background =
      x: 0
      y: 0

    if previous == game
      @fadeAlpha = 255
      @tween\to self, .15, {fadeAlpha: 0}
    else
      @fadeAlpha = 0

  timesBounceAnimation: =>
    @timesY = -4
    @tween\to(self, .1, {timesY: 0})\ease 'linear'

  update: (dt) =>
    @timer.update dt
    @tween\update dt

    --controls
    if @takeInput
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

      if input\pressed('primary') and saveManager.data.level[@selected].unlocked
        @takeInput = false
        @tween\to self, .15, {fadeAlpha: 255}
        @timer.add .15, ->
          gamestate.switch game, @levelButton[@selected].level

    --selection cursor
    with @cursor
      .goalX = @levelButton[@selected].x
      .goalY = @levelButton[@selected].y
      .x = lume.lerp .x, .goalX, 20 * dt
      .y = lume.lerp .y, .goalY, 20 * dt

    --cosmetic
    with @background
      .x -= 16 * dt
      .y -= 16 * dt
      if .x < -32
        .x += 32
      if .y < -32
        .y += 32

  draw: =>
    with @canvas
      \clear 0, 0, 0, 255
      \renderTo ->
        --draw background
        with love.graphics
          .push!
          .translate lume.round(@background.x), lume.round(@background.y)

          .setColor 255, 255, 255, 255
          for i = 0, 9
            for j = 0, 9
              .draw image.checkerboard, 64 * i, 64 * j

          .pop!

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
          .printAligned 'Best', font.mini, 75, 150, 'center'
          local bestText, bestColor
          if best
            bestText = string.format '%0.2f', best
            .setColor color.rank[bestRank]
          else
            bestText = '--'
            .setColor color.rank[4]
          .printAligned bestText, font.time, 75, 170, 'center'

          --print next time
          .setColor color.white
          .printAligned 'Goal', font.mini, WIDTH - 75, 150, 'center'
          local nextText
          if bestRank < 3
            nextText = '--'
            .setColor color.rank[4]
          else
            nextText = string.format '%0.1f', next
            .setColor color.rank[bestRank - 1]
          .printAligned nextText, font.time, WIDTH - 75, 170, 'center'

          .pop!

          --print locked message
          if not saveManager.data.level[@selected].unlocked
            .setColor 0, 0, 0, 100
            .rectangle 'fill', 0, HEIGHT * .2, WIDTH, HEIGHT * .4
            .setColor color.white
            .printAligned 'Locked', font.big, WIDTH / 2, HEIGHT * .2
            .setFont font.mini
            .printf 'Get silver ranks\nto unlock levels', 0, HEIGHT * .4, WIDTH, 'center'

          --draw completion bar
          .setColor 8, 0, 8, 255
          .rectangle 'fill', 20, HEIGHT * .9, WIDTH - 40, 20
          .setColor 68, 80, 140, 255
          .rectangle 'fill', 20, HEIGHT * .9, (WIDTH - 40) * (@completionPercentage / 100), 20
          .setColor color.white
          .printAligned string.format('%0.0f', @completionPercentage)..'% completion', font.mini, WIDTH / 2, HEIGHT * .9

          --draw fade out
          .setColor 0, 0, 0, @fadeAlpha
          .rectangle 'fill', 0, 0, WIDTH, HEIGHT

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, scaleFactor, scaleFactor
