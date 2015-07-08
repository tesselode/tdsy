export title

title =
  enter: =>
    if not @background
      @background = BackgroundMenu WIDTH, HEIGHT
      
    @menu = Menu font.mini, WIDTH * .5, HEIGHT * .65, color.gray, color.white
    @menu\addOption 'Play!', ->
      gamestate.switch levelSelect
    @menu\addOption 'Quit', ->
      love.event.quit!
      
    @mainCanvas = love.graphics.newCanvas WIDTH, HEIGHT
    @backgroundCanvas = love.graphics.newCanvas WIDTH, HEIGHT
    
  update: (dt) =>
    @background\update dt
    
    --menu controls
    with @menu
      \previous! if control.up.pressed
      \next! if control.down.pressed
      \select! if control.primary.pressed
    
  draw: =>
    with @backgroundCanvas
      \clear 0, 0, 0, 255
      \renderTo ->
        with love.graphics
          --draw background
          @background\draw!
          .push!
          .translate 0, HEIGHT * .5
          @background\drawScrolling!
          .pop!
          
    with @mainCanvas
      \clear 0, 0, 0, 0
      \renderTo ->
        with love.graphics
          --title
          .setFont font.big
          .printf "The Tops Don't Sting You", 0, 30, WIDTH, 'center'
          
          --menu
          @menu\draw!
          
    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @backgroundCanvas, 0, 0, 0, scaleFactor, scaleFactor
      .draw @mainCanvas, 0, 0, 0, scaleFactor, scaleFactor