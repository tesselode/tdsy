export menu

menu =
  enter: =>
    @background = BackgroundMenu WIDTH, HEIGHT
    
    @levelSelect = LevelSelect!
    
    @canvas = love.graphics.newCanvas WIDTH, HEIGHT
    
  update: (dt) =>
    @background\update dt
    
    @levelSelect\update dt
  
  draw: =>
    with love.graphics
      @canvas\clear 0, 0, 0, 255
      @canvas\renderTo ->
        --draw background
        @background\draw!
        .push!
        .translate 0, WIDTH * .5
        @background\drawScrolling!
        .pop!
        
        @levelSelect\draw!
  
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, scaleFactor, scaleFactor