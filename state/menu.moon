export menu

menu =
  enter: =>
    @timer = timer.new!
    @tween = flux.group!
    
    @background = BackgroundMenu WIDTH, HEIGHT
    
    --menus
    @title           = Title!
    @levelSelect     = LevelSelect!
    @focused         = @title
    @translateVector = vector!
    
    beholder.group self, ->
      beholder.observe 'go to level select', ->
        @focused = @levelSelect
        @tween\to(@translateVector, .5, {x: -WIDTH, y: 0})\ease('cubicout')
      beholder.observe 'go to title', ->
        @focused = @title
        @tween\to(@translateVector, .5, {x: 0, y: 0})\ease('cubicout')
    
    @canvas = love.graphics.newCanvas WIDTH, HEIGHT
    
  update: (dt) =>
    @timer.update dt
    @tween\update dt
    
    @background\update dt
    
    @focused\update dt
  
  leave: =>
    beholder.stopObserving self
  
  draw: =>
    with love.graphics
      @canvas\clear 0, 0, 0, 255
      @canvas\renderTo ->
        --draw background
        @background\draw!
        .push!
        .translate 0, HEIGHT * .5
        @background\drawScrolling!
        .pop!
        
        --draw menus
        .push!
        .translate @translateVector.x, @translateVector.y
        
        @title\draw!
        
        .push!
        .translate WIDTH, 0
        @levelSelect\draw!
        .pop!
        
        .pop!
  
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, scaleFactor, scaleFactor