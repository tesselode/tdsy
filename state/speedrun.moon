export speedrun

speedrun =
  enter: (previous) =>
    @timer = timer.new!
    @tween = flux.group!

    @time = 0

    @startLevel 16

    beholder.group self, ->
      beholder.observe 'level start', -> @levelStarted = true
      beholder.observe 'jellyfish bounced', -> @jellyfishBounced += 1

    --cosmetic
    @hud = HudSpeedrun self
    @drawOldMap = false

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

    --default music choice
    musicManager\playSong 'gameplay1', 1

  startLevel: (levelNum) =>
    @levelData        = levelData[levelNum]
    @mapOld           = @map if @map
    @map              = Map @levelData
    @playerInput      = PlayerInput @map.fish
    @jellyfishBounced = 0
    @levelStarted     = false
    @levelComplete    = false

  endLevel: =>
    beholder.trigger 'level complete'
    @levelComplete = true
    @playerInput.enabled = false

    @timer.add .5, ->
      @startLevel @levelData.levelNum + 1

      --cosmetic stuff
      @drawOldMap          = true
      @mapOld.enabled      = false
      @map.enabled         = false
      @timer.add .5, ->
        @map.enabled         = true

      @timer.add .25, ->
        @drawOldMap = false

      --fancy fish transition
      @fakeFish =
        pos: @mapOld.fish\getCenter! - @mapOld.camera.position
        rot: @mapOld.fish.sprite.rotation
      @tween\to @fakeFish.pos, .5, {
        x: @map.fish\getCenter!.x - @map.camera.position.x
        y: @map.fish\getCenter!.y - @map.camera.position.y
      }
      @tween\to @fakeFish, .5, {
        rot: @map.fish.sprite.rotation
      }
      @timer.add .5, ->
        @fakeFish = false

  update: (dt) =>
    @timer.update dt
    @tween\update dt

    @playerInput\update dt
    @map\update dt
    @mapOld\update dt if @mapOld

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
        if @drawOldMap
          @mapOld\draw!
        else
          @map\draw!

        @hud\draw!

        --draw fake fish
        if @fakeFish
          love.graphics.setColor 255, 255, 255, 255
          love.graphics.draw image.fish, @fakeFish.pos.x, @fakeFish.pos.y, @fakeFish.rot, 1, 1, image.fish\getWidth! / 2, image.fish\getHeight! / 2

        love.graphics.setColor 255, 255, 255, 255

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, .getWidth! / 2, .getHeight! / 2, 0, scaleFactor, scaleFactor, @canvas\getWidth! / 2, @canvas\getHeight! / 2
