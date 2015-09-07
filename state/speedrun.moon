export speedrun

speedrun =
  enter: (previous) =>
    @timer = timer.new!
    @tween = flux.group!

    @fakeFish         = nil
    @speedrunComplete = false
    @time             = 0

    @startLevel 1

    beholder.group self, ->
      beholder.observe 'level start', -> @levelStarted = true
      beholder.observe 'jellyfish bounced', -> @jellyfishBounced += 1

    --cosmetic
    @hud = HudSpeedrun self
    @drawOldMap = false
    @fishRotationSpeed = 2

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

    --default music choice
    musicManager\playSong 'speedrun', 1

  startLevel: (levelNum) =>
    @levelData        = levelData[levelNum]
    @mapOld           = @map if @map
    @map              = Map @levelData
    @playerInput      = PlayerInput @map.fish
    @jellyfishBounced = 0
    @levelStarted     = false
    @levelComplete    = false

  endLevel: =>
    @levelComplete = true
    @playerInput.enabled = false

    if @levelData.levelNum == NUMLEVELS
      beholder.trigger 'speedrun complete'
      @speedrunComplete = true
      musicManager\stopMusic!

      @timer.add .5, ->
        @map.enabled = false

        --speedrun complete animation
        @fakeFish =
          pos: @map.fish\getCenter! - @map.camera.position
          rot: @map.fish.sprite.rotation
          scale: 1
        @tween\to @fakeFish.pos, 1, {
          x: WIDTH / 2
          y: HEIGHT / 2
        }
        @tween\to @fakeFish, 2, {
          scale: 4
        }
    else
      beholder.trigger 'level complete'

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
          scale: 1
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

    --cosmetic
    if @speedrunComplete and @fakeFish
      @fishRotationSpeed += .1 * dt
      @fakeFish.rot += @fishRotationSpeed * dt

  leave: =>
    @hud\destroy!
    beholder.stopObserving self

  draw: =>
    @canvas\clear 0, 0, 0, 255
    @canvas\renderTo ->
      if @drawOldMap
        @mapOld\draw!
      else
        @map\draw!

      @hud\draw!

      --draw fake fish
      if @fakeFish
        with @fakeFish
          love.graphics.setColor 255, 255, 255, 255
          love.graphics.draw image.fish, .pos.x, .pos.y, .rot, .scale, .scale, image.fish\getWidth! / 2, image.fish\getHeight! / 2

      @hud\drawTop!

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, .getWidth! / 2, .getHeight! / 2, 0, scaleFactor, scaleFactor, @canvas\getWidth! / 2, @canvas\getHeight! / 2
