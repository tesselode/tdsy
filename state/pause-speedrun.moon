export pauseSpeedrun

pauseSpeedrun =
  enter: =>
    @timer = timer.new!
    @tween = flux.group!

    @enterMainMenu!

    --cosmetic
    @fadeAlpha = 0
    @buttonDisplay = ButtonDisplay 'Select', 'Back'

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  enterMainMenu: =>
    @onMainMenu = true

    @menu = Menu font.mini, WIDTH / 2, HEIGHT / 2, {150, 150, 150, 255}, {255, 255, 255, 255}
    with @menu
      \addOption MenuOption 'Resume', ->
        gamestate.pop!
      \addOption MenuOption 'Restart', ->
        @enterConfirmationMenu!
        beholder.trigger 'menu select'
      \addOption MenuOption 'Back to menu', ->
        beholder.trigger 'menu back'
        @menu.takeInput = false
        @tween\to self, .15, {fadeAlpha: 255}
        @timer.add .15, ->
          gamestate.pop!
          gamestate.switch menu

  enterConfirmationMenu: =>
    @onMainMenu = false

    @menu = Menu font.mini, WIDTH / 2, HEIGHT / 2, {150, 150, 150, 255}, {255, 255, 255, 255}
    with @menu
      \addOption MenuOption 'Yes', ->
        gamestate.pop!
        gamestate.switch speedrun
        beholder.trigger 'menu select'
      \addOption MenuOption 'No', ->
        @enterMainMenu!
        beholder.trigger 'menu back'
      .selected = 2

  update: (dt) =>
    @timer.update dt
    @tween\update dt

    with @menu
      \previous! if control.up.pressed
      \next! if control.down.pressed
      \select! if control.primary.pressed

    if (control.pause.pressed or control.secondary.pressed) and not control.primary.pressed
      gamestate.pop!

  draw: =>
    with @canvas
      \clear 0, 0, 0, 255
      \renderTo ->
        with love.graphics
          --draw gameplay canvas
          if speedrun.canvas
            .setColor 100, 100, 100, 255
            .draw speedrun.canvas

          .setColor 255, 255, 255, 255
          if @onMainMenu
            .printAligned 'Pause', font.big, WIDTH / 2, HEIGHT * .4, 'center', 'bottom'
          else
            .printAligned 'Are you sure?', font.mini, WIDTH / 2, HEIGHT * .4, 'center', 'bottom'

          @menu\draw!
          @buttonDisplay\draw!

          --draw fade out
          .setColor 0, 0, 0, @fadeAlpha
          .rectangle 'fill', 0, 0, WIDTH, HEIGHT

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, .getWidth! / 2, .getHeight! / 2, 0, scaleFactor, scaleFactor, @canvas\getWidth! / 2, @canvas\getHeight! / 2
