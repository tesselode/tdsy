export pause

pause =
  enter: =>
    @timer = timer.new!
    @tween = flux.group!

    --menu options
    @menu = Menu font.mini, WIDTH / 2, HEIGHT / 2, {150, 150, 150, 255}, {255, 255, 255, 255}
    with @menu
      \addOption 'Resume', ->
        gamestate.pop!
      \addOption 'Restart', ->
        gamestate.pop!
        gamestate.switch game, game.level
      \addOption 'Back to menu', ->
        @menu.takeInput = false
        @tween\to self, .15, {fadeAlpha: 255}
        @timer.add .15, ->
          gamestate.pop!
          gamestate.switch levelSelect

    --cosmetic
    @fadeAlpha = 0

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  update: (dt) =>
    @timer.update dt
    @tween\update dt

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
          .printAligned 'Pause', font.big, WIDTH / 2, HEIGHT * .4, 'center', 'bottom'

          @menu\draw!

          --draw fade out
          .setColor 0, 0, 0, @fadeAlpha
          .rectangle 'fill', 0, 0, WIDTH, HEIGHT

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, scaleFactor, scaleFactor
