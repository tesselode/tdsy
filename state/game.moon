export game

game =
  enter: (previous, @level) =>
    @map = Map @level
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

  endLevel: =>
    beholder.trigger 'level complete'
    @levelComplete = true
    @playerInput.enabled = false

    --save data
    best = saveManager.data.level[@level.levelNum].best
    if not best or @time < best
      saveManager.data.level[@level.levelNum].best = @time
      saveManager\write!
      beholder.trigger 'show endslate', true
    else
      beholder.trigger 'show endslate', false

  update: (dt) =>
    @playerInput\update dt
    @map\update dt

    --game flow
    if @levelStarted and not @levelComplete
      @time += dt
      if @jellyfishBounced == #@level.jellyfish
        @endLevel!

    @hud\update dt

    --pause menu
    if not @levelComplete and input\pressed 'pause'
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
