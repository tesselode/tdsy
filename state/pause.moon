export pause

pause =
  enter: =>
    @timer = timer.new!
    @tween = flux.group!

    --menu options
    @menu = Menu font.mini, WIDTH / 2, HEIGHT / 2, {150, 150, 150, 255}, {255, 255, 255, 255}
    with @menu
      \addOption MenuOption 'Resume', ->
        gamestate.pop!
      \addOption MenuOption 'Restart', ->
        gamestate.pop!
        gamestate.switch game, game.levelData
        beholder.trigger 'menu select'
      if gameSpeed < 1
        \addOption MenuOption 'Leave practice mode', ->
          export gameSpeed = 1
          gamestate.pop!
          gamestate.switch game, game.levelData
          beholder.trigger 'menu select'
      \addOption MenuOption 'Back to menu', ->
        beholder.trigger 'menu back'
        @menu.takeInput = false
        @tween\to self, .15, {fadeAlpha: 255}
        @timer.add .15, ->
          gamestate.pop!
          gamestate.switch menu

    --cosmetic
    @fadeAlpha = 0
    @buttonDisplay = ButtonDisplay 'Select', 'Back'

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

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
          if game.canvas
            .setColor 100, 100, 100, 255
            .draw game.canvas

          .setColor 255, 255, 255, 255
          .printAligned 'Pause', font.big, WIDTH / 2, HEIGHT * .4, 'center', 'bottom'

          @menu\draw!
          @buttonDisplay\draw!

          --draw fade out
          .setColor 0, 0, 0, @fadeAlpha
          .rectangle 'fill', 0, 0, WIDTH, HEIGHT

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, .getWidth! / 2, .getHeight! / 2, 0, scaleFactor, scaleFactor, @canvas\getWidth! / 2, @canvas\getHeight! / 2
