export class LevelSelect
  new: =>
    @selected = 1
    
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
    @completionPercentage = (completionPoints / 48) * 100

    --create level buttons
    @levelButton = {}
    levelNum = 0
    for i = 0, 2 do
      for j = 0, 4 do
        levelNum += 1
        table.insert @levelButton, LevelButton levelData[levelNum], 35 + 37 * j, 5 + 37 * i

    --controls
    @takeInput = true

    --cosmetic
    @cursor =
      x: @levelButton[@selected].x
      y: @levelButton[@selected].y
      goalX: @levelButton[@selected].x
      goalY: @levelButton[@selected].y
    @timesY = 0

    --fade transition
    --if previous == game
    --  @fadeAlpha = 255
    --  @tween\to self, .15, {fadeAlpha: 0}
    --else
    --  @fadeAlpha = 0
      
    --slide transition
    --if previous == title
    --  @slideY = HEIGHT
    --  @tween\to self, .5, {slideY: 0}
    --else
    --  @slideY = 0
    
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
      if control.right.pressed
        @selected += 1
        @timesBounceAnimation!
      if control.up.pressed
        @selected -= 5
        @timesBounceAnimation!
      if control.down.pressed
        @selected += 5
        @timesBounceAnimation!
      @selected = math.wrap @selected, 1, 15

      if control.primary.pressed and levelData[@selected].unlocked
        @takeInput = false
        --@tween\to self, .15, {fadeAlpha: 255}
        @timer.add .15, ->
          gamestate.switch game, @levelButton[@selected].level

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
      if levelData[@selected] and levelData[@selected]\getBestRank! < 3
        .setColor color.rank[4]
        .printAligned '--', font.time, WIDTH - 75, 170, 'center'
      elseif levelData[@selected]
        .setColor color.rank[levelData[@selected]\getBestRank! - 1]
        .printAligned string.format('%0.1f', levelData[@selected]\getNext!), font.time, WIDTH - 75, 170, 'center'

      .pop!

      --print locked message
      if levelData[@selected] and not levelData[@selected].unlocked
        .setColor 0, 0, 0, 100
        .rectangle 'fill', 0, HEIGHT * .2, WIDTH, HEIGHT * .4
        .setColor color.white
        .printAligned 'Locked', font.big, WIDTH / 2, HEIGHT * .2
        .setFont font.mini
        .printf 'Get bronze ranks\nto unlock levels', 0, HEIGHT * .4, WIDTH, 'center'

      --draw completion bar
      .setColor 8, 0, 8, 255
      .rectangle 'fill', 20, HEIGHT * .9, WIDTH - 40, 20
      .setColor 91, 153, 254, 255
      .rectangle 'fill', 20, HEIGHT * .9, (WIDTH - 40) * (@completionPercentage / 100), 20
      .setColor color.white
      .printAligned string.format('%0.0f', @completionPercentage)..'% completion', font.mini, WIDTH / 2, HEIGHT * .9

      --draw fade out
      --.setColor 0, 0, 0, @fadeAlpha
      --.rectangle 'fill', 0, 0, WIDTH, HEIGHT