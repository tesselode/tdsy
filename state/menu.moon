export menu

menu =
  enter: (previous) =>
    @timer = timer.new!
    @tween = flux.group!
    
    @background = BackgroundMenu WIDTH * 2, HEIGHT
    
    --menus
    @title           = Title!
    @levelSelect     = LevelSelect!
    if previous == game
      @focused = @levelSelect
      @translateVector = vector -WIDTH, 0
      @fadeAlpha = 255
      @tween\to self, .15, {fadeAlpha: 0}
    else
      @focused = @title
      @translateVector = vector!
      @fadeAlpha = 0
    
    beholder.group self, ->
      beholder.observe 'go to level select', ->
        @focused = @levelSelect
        @tween\to(@translateVector, .5, {x: -WIDTH, y: 0})\ease('cubicout')
      beholder.observe 'go to title', ->
        @focused = @title
        @tween\to(@translateVector, .5, {x: 0, y: 0})\ease('cubicout')
      beholder.observe 'go to game', (level) ->
        @tween\to self, .15, {fadeAlpha: 255}
        @timer.add .15, ->
          gamestate.switch game, level
    
    @canvas = love.graphics.newCanvas WIDTH, HEIGHT
    
    musicManager\playSong 'title'
    
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
        .translate @translateVector.x, HEIGHT * .5
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
        
        --draw fade transition
        .setColor 0, 0, 0, @fadeAlpha
        .rectangle 'fill', 0, 0, WIDTH, HEIGHT
  
      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, 0, 0, 0, scaleFactor, scaleFactor