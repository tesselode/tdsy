export menu

menu =
  enter: (previous) =>
    --dumb hack to get around the announcement screen affecing transitions
    if previous == announcement
      previous = previous.previous

    @timer = timer.new!
    @tween = flux.group!

    --cosmetic
    useWeirdBackground = true
    for k, v in pairs levelData
      if v\getBestRank! ~= 1
        useWeirdBackground = false
    @background = BackgroundMenu WIDTH * 3, HEIGHT, useWeirdBackground

    --menus
    @title = Title!

    if previous == game
      @levelSelect = LevelSelect game.levelData.levelNum
    else
      @levelSelect = LevelSelect 1

    @gameOptions = GameOptions!
    @gameOptionsY = HEIGHT

    @options = Options!

    --choose starting menu based on previous state
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
        @tween\to(self, .5, {gameOptionsY: HEIGHT})
      beholder.observe 'go to game options', ->
        @focused = @gameOptions
        @tween\to(self, .5, {gameOptionsY: 0})
      beholder.observe 'go to title', ->
        @focused = @title
        @tween\to(@translateVector, .5, {x: 0, y: 0})\ease('cubicout')
      beholder.observe 'go to options', ->
        @focused = @options
        @tween\to(@translateVector, .5, {x: WIDTH, y: 0})\ease('cubicout')
      beholder.observe 'go to game', (level) ->
        @tween\to self, .15, {fadeAlpha: 255}
        @timer.add .15, ->
          gamestate.switch game, level

    @canvas = love.graphics.newCanvas WIDTH, HEIGHT

    if previous == game
      musicManager\playSong 'title', 1
    else
      musicManager\playSong 'title'

  update: (dt) =>
    @timer.update dt
    @tween\update dt

    @background\update dt

    @focused\update dt

  leave: =>
    @gameOptions\leave!
    beholder.stopObserving self

  draw: =>
    with love.graphics
      @canvas\clear 0, 0, 0, 255
      @canvas\renderTo ->
        --draw background
        @background\draw!
        .push!
        .translate @translateVector.x - WIDTH, HEIGHT * .5
        @background\drawScrolling!
        .pop!

        --draw menus
        .push!
        .translate @translateVector.x, @translateVector.y

        @title\draw!

        .push!
        .translate WIDTH, 0
        @levelSelect\draw!
        .push!
        .translate 0, @gameOptionsY
        @gameOptions\draw!
        .pop!
        .pop!

        .push!
        .translate -WIDTH, 0
        @options\draw!
        .pop!

        .pop!

        --draw fade transition
        .setColor 0, 0, 0, @fadeAlpha
        .rectangle 'fill', 0, 0, WIDTH, HEIGHT

      scaleFactor = .getHeight! / HEIGHT
      .setColor 255, 255, 255, 255
      .draw @canvas, .getWidth! / 2, .getHeight! / 2, 0, scaleFactor, scaleFactor, @canvas\getWidth! / 2, @canvas\getHeight! / 2
