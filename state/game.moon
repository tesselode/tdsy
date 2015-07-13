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

    beholder.group self, ->
      beholder.observe 'level start', -> @levelStarted = true
      beholder.observe 'jellyfish bounced', -> @jellyfishBounced += 1

    --cosmetic
    @hud = Hud self

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT
    
    musicManager\playSong 'gameplay2', 1

  endLevel: =>
    beholder.trigger 'level complete'
    @levelComplete = true
    @playerInput.enabled = false

    --save data
    newBest = @levelData\addTime @time
    saveManager\save!
    saveManager\unlockLevels!
    beholder.trigger 'show endslate', newBest

  update: (dt) =>
    @playerInput\update dt
    @map\update dt

    --game flow
    if @levelStarted and not @levelComplete
      @time += dt
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
      .draw @canvas, 0, 0, 0, scaleFactor, scaleFactor
