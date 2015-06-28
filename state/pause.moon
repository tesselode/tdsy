export pause

pause =
  enter: =>
    --menu options
    @options = {}
    @options[1] = {}
    @options[1].text = 'Restart'
    @options[1].onSelect = ->
      gamestate.pop!
      gamestate.switch game, game.level
    @options[2] = {}
    @options[2].text = 'Back to menu'
    @options[2].onSelect = ->
      gamestate.pop!
      gamestate.switch levelSelect

    @selected = 1

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

  update: (dt) =>
    @selected -= 1 if input\pressed 'up'
    @selected += 1 if input\pressed 'down'
    @selected = math.wrap @selected, 1, 2

    if input\pressed 'pause'
      gamestate.pop!
    if input\pressed 'primary'
      @options[@selected].onSelect!

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

          --draw menu options
          for k, v in pairs @options
            if k == @selected
              .setColor 255, 255, 255, 255
            else
              .setColor 150, 150, 150, 255
            .printAligned v.text, font.time, WIDTH / 2, HEIGHT / 2 + 20 * k

    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, scaleFactor, scaleFactor
