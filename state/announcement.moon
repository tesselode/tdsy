export announcement

announcement =
  enter: (previous, @done) =>
    --"new levels revealed" trigger conditions
    newLevelsRevealed = true
    for i = 1, 15
      if levelData[i]\getBestRank! > 3
        newLevelsRevealed = false

    with saveManager.triggers.newLevels
      if not .triggered and newLevelsRevealed
        .triggered = true
      if .triggered and not .shown
        @message = 'New levels revealed!'

    --if there's no message then skip this state
    if not @message
      @done!

  update: (dt) =>
    if control.primary.pressed
      @done!

  draw: =>
    with love.graphics
      .setColor color.white
      .print @message, 0, 0
