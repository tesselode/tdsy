export class HudSpeedrun
  new: (@state) =>
    @timer = timer.new!
    @tween = flux.group!

    --cosmetic stuff
    @goalDisplayY = 10
    @timerY       = -50
    @bgFadeAlpha  = 0
    @fadeAlpha    = 255
    @tween\to self, .15, {fadeAlpha: 0}

    beholder.group self, ->
      beholder.observe 'level start', ->
        @tween\to(self, .35, {goalDisplayY: -50})\ease 'linear'
        @tween\to(self, .35, {timerY: 10})\ease 'linear'
      beholder.observe 'level complete', ->
        @timer.add .5, ->
          @tween\to self, .25, {bgFadeAlpha: 255}
        @timer.add .75, ->
          @tween\to self, .25, {bgFadeAlpha: 0}
      beholder.observe 'speedrun complete', (newBest) ->
        @timer.add .5, ->
          @showEndslate newBest

  showEndslate: (newBest) =>
    @endSlate =
      newBest: newBest
      bgAlpha: 0
      y: -100

    @tween\to(@, .35, {timerY: -50})\ease 'linear'
    @timer.add .5, ->
      @tween\to @, .5, {bgFadeAlpha: 255}
      @tween\to @endSlate, 1, {y: 0}

      @timer.add 1, ->
        @tween\to @endSlate, .5, {bgAlpha: 255}

      @timer.add 3, ->
        @menu = Menu font.mini, WIDTH / 2, 180, {150, 150, 150, 255}, {255, 255, 255, 255}
        with @menu
          \addOption MenuOption 'Again!', ->
            gamestate.switch announcement, ->
              gamestate.switch speedrun
            beholder.trigger 'menu select'
          \addOption MenuOption 'Back to menu', ->
            beholder.trigger 'menu back'
            @menu.takeInput = false
            @tween\to self, .15, {fadeAlpha: 255}
            @timer.add .15, ->
              gamestate.switch announcement, ->
                gamestate.switch menu

  update: (dt) =>
    @timer.update dt
    @tween\update dt

    --menu input
    if @menu
      with @menu
        \previous! if control.up.pressed
        \next! if control.down.pressed
        \select! if control.primary.pressed

  destroy: =>
    beholder.stopObserving self

  draw: =>
    with love.graphics
      --draw fade out
      .setColor 0, 0, 0, @bgFadeAlpha
      .rectangle 'fill', 0, 0, WIDTH, HEIGHT

      .setColor color.white
      --.printAligned 'Best: ', font.mini, WIDTH / 2, @goalDisplayY, 'right', 'middle'
      --.printAligned string.format('%0.2f', @state.levelData.best), font.time, WIDTH / 2, @goalDisplayY, 'left', 'middle'

      --draw time
      .setColor 255, 255, 255, 255
      .printAligned string.format('%0.1f', @state.time), font.time, WIDTH / 2, @timerY, 'center', 'middle'

      --draw endslate
      if @endSlate
        .setColor 255, 255, 255, @endSlate.bgAlpha
        .draw image.background, 0, 0

        .push!
        .translate 0, @endSlate.y

        .setColor color.white
        .printAligned 'Your time!', font.mini, 10, 20, 'left', 'middle'
        .printAligned string.format('%0.2f', @state.time), font.timeBig, WIDTH - 10, 20, 'right', 'middle'

        .pop!

      @menu\draw! if @menu


  drawTop: =>
    with love.graphics
      --draw fade out
      .setColor 0, 0, 0, @fadeAlpha
      .rectangle 'fill', 0, 0, WIDTH, HEIGHT
