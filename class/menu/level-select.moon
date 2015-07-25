export class LevelSelect
  new: (@selected) =>  
    @timer = timer.new!
    @tween = flux.group!

    --get completion percentage
    completionPoints = 0
    for k, v in pairs levelData
      if v\getBestRank! == 1
        completionPoints += 3
      elseif v\getBestRank! == 2
        completionPoints += 2
      elseif v\getBestRank! == 3
        completionPoints += 1
    @completionPercentage = (completionPoints / (NUMLEVELS * 3)) * 100

    --create level buttons
    @levelButton = {}
    levelNum = 0
    for i = 0, 2
      for j = 0, 4
        levelNum += 1
        table.insert @levelButton, LevelButton levelData[levelNum], 35 + 37 * j, 5 + 37 * i

    --bonus levels
    @showBonusLevels = true
    for i = 1, 15
      if levelData[i]\getBestRank! > 3
        @showBonusLevels = false
    if @showBonusLevels
      i = 3
      for j = 0, 4
        levelNum += 1
        table.insert @levelButton, LevelButton levelData[levelNum], 35 + 37 * j, 5 + 37 * i

    @finalLevelRevealed = true
    for i = 1, NUMLEVELS - 1
      if levelData[i]\getBestRank! > 2
        @finalLevelRevealed = false

    --controls
    @takeInput = true

    --cosmetic
    @cursor =
      x: @levelButton[@selected].x
      y: @levelButton[@selected].y
      goalX: @levelButton[@selected].x
      goalY: @levelButton[@selected].y
    @timesY = 0

  timesBounceAnimation: =>
    @timesY = -4
    @tween\to(self, .1, {timesY: 0})\ease 'linear'

  update: (dt) =>
    @timer.update dt
    @tween\update dt

    --controls
    if @takeInput
      if control.left.pressed
        @selected -= 1
        @timesBounceAnimation!
        beholder.trigger 'menu navigate'
      if control.right.pressed
        @selected += 1
        @timesBounceAnimation!
        beholder.trigger 'menu navigate'
      if control.up.pressed
        @selected -= 5
        @timesBounceAnimation!
        beholder.trigger 'menu navigate'
      if control.down.pressed
        @selected += 5
        @timesBounceAnimation!
        beholder.trigger 'menu navigate'
      if @showBonusLevels
        @selected = math.wrap @selected, 1, 20
      else
        @selected = math.wrap @selected, 1, 15

      if control.primary.pressed and levelData[@selected].unlocked
        @takeInput = false
        beholder.trigger 'go to game', @levelButton[@selected].level
        beholder.trigger 'menu select'

      if control.secondary.pressed
        beholder.trigger 'go to title'
        beholder.trigger 'menu back'

    --selection cursor
    with @cursor
      .goalX = @levelButton[@selected].x
      .goalY = @levelButton[@selected].y
      .x = lume.lerp .x, .goalX, 20 * dt
      .y = lume.lerp .y, .goalY, 20 * dt

  draw: =>
    with love.graphics
      --draw level buttons
      for levelButton in *@levelButton
        levelButton\draw!

      --draw selection cursor
      .setColor 255, 255, 255, 255
      .draw image.buttonCursor, lume.round(@cursor.x), lume.round(@cursor.y)

      .push!
      .translate 0, -@timesY

      --print best time
      .setColor color.white
      .printAligned 'Best', font.mini, 75, 150, 'center'
      if levelData[@selected] and levelData[@selected].best
        .setColor color.rank[levelData[@selected]\getBestRank!]
        .printAligned string.format('%0.2f', levelData[@selected].best), font.time, 75, 170, 'center'
      else
        .setColor color.rank[4]
        .printAligned '--', font.time, 75, 170, 'center'

      --print next time
      .setColor color.white
      .printAligned 'Goal', font.mini, WIDTH - 75, 150, 'center'
      local maxGoalToShow
      if @finalLevelRevealed
        maxGoalToShow = 2
      else
        maxGoalToShow = 3
      if levelData[@selected] and levelData[@selected]\getBestRank! < maxGoalToShow
        .setColor color.rank[4]
        .printAligned '--', font.time, WIDTH - 75, 170, 'center'
      elseif levelData[@selected]
        .setColor color.rank[levelData[@selected]\getBestRank! - 1]
        .printAligned string.format('%0.1f', levelData[@selected]\getNext!), font.time, WIDTH - 75, 170, 'center'

      .pop!

      --print locked message
      if levelData[@selected] and not levelData[@selected].unlocked
        local hint
        if @selected < 16
          hint = 'Get bronze ranks\nto unlock levels'
        elseif @selected < NUMLEVELS
          hint = 'Get gold ranks\nto unlock levels'
        else
          if @finalLevelRevealed
            hint = 'Get diamond ranks on\nevery level to unlock'
          else
            hint = '????'

        .setColor 0, 0, 0, 100
        .rectangle 'fill', 0, HEIGHT * .2, WIDTH, HEIGHT * .4
        .setColor color.white
        .printAligned 'Locked', font.big, WIDTH / 2, HEIGHT * .2
        .setFont font.mini
        .printf hint, 0, HEIGHT * .4, WIDTH, 'center'

      --draw completion bar
      .setColor 8, 0, 8, 255
      .rectangle 'fill', 20, HEIGHT * .9, WIDTH - 40, 20
      .setColor 91, 153, 254, 255
      .rectangle 'fill', 20, HEIGHT * .9, (WIDTH - 40) * (@completionPercentage / 100), 20
      .setColor color.white
      if @completionPercentage == 100
        .printAligned 'Thank you for playing!', font.mini, WIDTH / 2, HEIGHT * .9
      else
        .printAligned string.format('%0.0f', @completionPercentage)..'% completion', font.mini, WIDTH / 2, HEIGHT * .9
