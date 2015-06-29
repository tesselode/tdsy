export pause

pause =
  enter: =>
    --menu options
    @menu = Menu font.time, WIDTH / 2, HEIGHT / 2, {150, 150, 150, 255}, {255, 255, 255, 255}
    with @menu
      \addOption 'Restart', ->
        gamestate.pop!
        gamestate.switch game, game.level
      \addOption 'Back to menu', ->
        gamestate.pop!
        gamestate.switch levelSelect

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  update: (dt) =>
    with @menu
      \previous! if input\pressed 'up'
      \next! if input\pressed 'down'
      \select! if input\pressed 'primary'

    if input\pressed 'pause'
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
          .printAligned 'Pause', font.timeBig, WIDTH / 2, HEIGHT / 2, 'center', 'bottom'

          @menu\draw!

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, scaleFactor, scaleFactor
