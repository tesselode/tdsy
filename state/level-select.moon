export levelSelect

levelSelect =
  selected: 1

  enter: (previous) =>
    
      
    --canvases
    @mainCanvas = love.graphics.newCanvas WIDTH, HEIGHT
    @backgroundCanvas = love.graphics.newCanvas WIDTH, HEIGHT
    @render!
    @draw!

  

  

  render: =>
    with @backgroundCanvas
      \clear 0, 0, 0, 255
      \renderTo ->
        with love.graphics
          --draw background
          title.background\draw!
          .push!
          .translate 0, HEIGHT * .5
          title.background\drawScrolling!
          .pop!
    
    with @mainCanvas
      \clear 0, 0, 0, 0
      \renderTo ->
        

  draw: =>
    @render!
    
    with love.graphics
      scaleFactor = .getHeight! / HEIGHT
      
      .setColor 255, 255, 255, 255
      .draw @backgroundCanvas, 0, 0, 0, scaleFactor, scaleFactor
      
      .push!
      .translate 0, @slideY * scaleFactor
      .draw title.mainCanvas, 0, -HEIGHT * scaleFactor, 0, scaleFactor, scaleFactor
      .draw @mainCanvas, 0, 0, 0, scaleFactor, scaleFactor
      
      .pop!