export speedrun

speedrun =
  enter: (previous) =>
    @timer = timer.new!
    @tween = flux.group!

    @time = 0    

    @startLevel 1

    beholder.group self, ->
      beholder.observe 'level start', -> @levelStarted = true
      beholder.observe 'jellyfish bounced', -> @jellyfishBounced += 1

    --cosmetic
    @hud = HudSpeedrun self

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

    --default music choice
    if saveManager.options.musicType == 1
      if @levelData.levelNum > 15
        musicManager\playSong 'gameplay2', 1
      else
        musicManager\playSong 'gameplay1', 1
    --user set music choice
    elseif saveManager.options.musicType == 2
      musicManager\playSong 'gameplay1', 1
    elseif saveManager.options.musicType == 3
      musicManager\playSong 'gameplay2', 1

  startLevel: (levelNum) =>
    @levelData        = levelData[levelNum]
    @map              = Map @levelData
    @playerInput      = PlayerInput @map.fish
    @jellyfishBounced = 0
    @levelStarted     = false
    @levelComplete    = false

  endLevel: =>
    beholder.trigger 'level complete', newBest
    @levelComplete = true
    @playerInput.enabled = false

    @timer.add 1, ->
      @startLevel @levelData.levelNum + 1

  update: (dt) =>
    @timer.update dt
    @tween\update dt

    @playerInput\update dt
    @map\update dt

    --game flow
    if @levelStarted and not @levelComplete
      @time += dt * gameSpeed
      if @jellyfishBounced == #@levelData.map.jellyfish
        @endLevel!

    @hud\update dt

    --pause menu
    if not @levelComplete and control.pause.pressed
      gamestate.push pauseSpeedrun

  leave: =>
    @hud\destroy!
    beholder.stopObserving self

  draw: =>
    with @canvas
      \clear 0, 0, 0, 255
      \renderTo ->
        @map\draw!
        @hud\draw!

        love.graphics.setColor 255, 255, 255, 255

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, .getWidth! / 2, .getHeight! / 2, 0, scaleFactor, scaleFactor, @canvas\getWidth! / 2, @canvas\getHeight! / 2
