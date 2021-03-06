export announcement

announcement =
  enter: (previous, @done) =>
    @timer = timer.new!
    @tween = flux.group!

    @previous = previous

    @message = nil

    --"new levels revealed" trigger conditions
    newLevelsRevealed = true
    for i = 1, 15
      if levelData[i]\getBestRank! > 3
        newLevelsRevealed = false

    --"diamond times revealed" trigger conditions
    diamondTimesRevealed = true
    for i = 1, NUMLEVELS
      if levelData[i]\getBestRank! > 2
        diamondTimesRevealed = false

    speedrunModeUnlocked = saveManager\getAllLevelsUnlocked!

    @checkTrigger saveManager.triggers.newLevels, newLevelsRevealed, 'New levels revealed!'
    @checkTrigger saveManager.triggers.diamondTimes, diamondTimesRevealed, 'Diamond times revealed!'
    @checkTrigger saveManager.triggers.speedrunMode, speedrunModeUnlocked, 'Speedrun mode unlocked!'

    --if there's no message then skip this state
    if not @message
      @done!
    else
      --duck out music briefly
      with musicManager
        if .current
          .current.volume = 0
          .timer.add 3, ->
            .tween\to .current, 1, {volume: 1}
      beholder.trigger 'announcement'

      @takeInput = false

      --cosmetic
      @rectangle = {width: 0, height: 0}
      @tween\to @rectangle, .2, {width: 200, height: 50}
      @timer.add .2, ->
        @takeInput = true
      @buttonDisplay = ButtonDisplay 'OK Cool!'

      @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  checkTrigger: (trigger, condition, message) =>
    with trigger
      if not .triggered and condition
        .triggered = true
      print not .shown
      if .triggered and not .shown
        @message = message
        .shown = true
        saveManager\save!

  update: (dt) =>
    @timer.update dt
    @tween\update dt

    if @takeInput and control.primary.pressed
      @takeInput = false
      @tween\to @rectangle, .2, {width: 0, height: 0}
      @timer.add .2, ->
        @done!

  leave: =>
    beholder.trigger 'announcement end'

  draw: =>
    with love.graphics
      @canvas\clear 0, 0, 0, 255
      @canvas\renderTo ->
        --draw the fancy rectangle
        .setColor 68, 80, 140, 255
        x = WIDTH * .5 - @rectangle.width * .5
        y = HEIGHT * .5 - @rectangle.height * .5
        .rectangle 'fill', x, y, @rectangle.width, @rectangle.height
        .setColor color.white
        .rectangle 'line', x, y, @rectangle.width, @rectangle.height

        --draw message text
        if @takeInput
          .setColor color.white
          .printAligned @message, font.mini, WIDTH * .5, HEIGHT * .5, 'center', 'middle'

        @buttonDisplay\draw!

      with love.graphics
        scaleFactor = .getHeight! / HEIGHT
        .setColor 255, 255, 255, 255
        .draw @canvas, .getWidth! / 2, .getHeight! / 2, 0, scaleFactor, scaleFactor, @canvas\getWidth! / 2, @canvas\getHeight! / 2
