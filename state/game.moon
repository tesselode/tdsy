export game

game =
  enter: (previous, @levelData) =>
    @map = Map @levelData
    @playerInput = PlayerInput @map.fish

    --game flow
    @levelStarted = false
    @levelComplete = false
    @jellyfishBounced = 0
    @time = 0
    @gameSpeed = 1

    beholder.group self, ->
      beholder.observe 'level start', -> @levelStarted = true
      beholder.observe 'jellyfish bounced', -> @jellyfishBounced += 1

    --cosmetic
    @hud = Hud self

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT
    
    if saveManager.options.musicType == 1
      musicManager\playSong 'gameplay1', 1
    elseif saveManager.options.musicType == 2
      musicManager\playSong 'gameplay2', 1

  endLevel: =>
    hadDiamond = @levelData\getBestRank! == 1
    newBest = @levelData\addTime @time
    newDiamond = @levelData\getBestRank! == 1 and not hadDiamond
    
    beholder.trigger 'level complete', newBest, newDiamond
    @levelComplete = true
    @playerInput.enabled = false

    --save data
    saveManager\save!
    saveManager\unlockLevels!
    beholder.trigger 'show endslate', newBest

  update: (dt) =>
    @playerInput\update dt
    @map\update dt * @gameSpeed

    --game flow
    if @levelStarted and not @levelComplete
      @time += dt * @gameSpeed
      if @jellyfishBounced == #@levelData.map.jellyfish
        @endLevel!

    @hud\update dt

    --pause menu
    if not @levelComplete and control.pause.pressed
      gamestate.push pause

  leave: =>
    @hud\destroy!
    beholder.stopObserving self

  draw: =>
    with @canvas
      \clear 0, 0, 0, 255
      \renderTo ->
        @map\draw!
        @hud\draw!

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, .getWidth! / 2, .getHeight! / 2, 0, scaleFactor, scaleFactor, @canvas\getWidth! / 2, @canvas\getHeight! / 2
