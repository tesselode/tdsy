export speedrun

speedrun =
  enter: (previous) =>
    @levelData = levelData[1]
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

  endLevel: =>
    local newBest
    if gameSpeed == 1
      newBest = @levelData\addTime @time
    else
      newBest = false

    beholder.trigger 'level complete', newBest
    @levelComplete = true
    @playerInput.enabled = false

    --save data
    saveManager\save!
    saveManager\unlockLevels!
    beholder.trigger 'show endslate', newBest

  update: (dt) =>
    @playerInput\update dt
    @map\update dt * gameSpeed

    --game flow
    if @levelStarted and not @levelComplete
      @time += dt * gameSpeed
      if @jellyfishBounced == #@levelData.map.jellyfish
        @endLevel!

    @hud\update dt

    --pause menu
    if not @levelComplete and control.pause.pressed
      gamestate.push pause
    --quick restart
    if not @levelComplete and control.restart.pressed
      gamestate.switch game, @levelData
      beholder.trigger 'menu select'

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
        --love.graphics.draw image.titleSquare, WIDTH / 2, HEIGHT / 2, 0, 1, 1, image.titleSquare\getWidth! / 2, image.titleSquare\getHeight! / 2

    with love.graphics

      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, .getWidth! / 2, .getHeight! / 2, 0, scaleFactor, scaleFactor, @canvas\getWidth! / 2, @canvas\getHeight! / 2
