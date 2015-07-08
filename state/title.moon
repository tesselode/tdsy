export title

title =
  enter: =>
    if not @background
      @background = BackgroundMenu WIDTH, HEIGHT
    @mainCanvas = love.graphics.newCanvas WIDTH, HEIGHT
    @backgroundCanvas = love.graphics.newCanvas WIDTH, HEIGHT
    
  update: (dt) =>
    @background\update dt
    
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
          .setFont font.big
          .printf "The Tops Don't Sting You", 0, 30, WIDTH, 'center'
          
    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @backgroundCanvas, 0, 0, 0, scaleFactor, scaleFactor
      .draw @mainCanvas, 0, 0, 0, scaleFactor, scaleFactor