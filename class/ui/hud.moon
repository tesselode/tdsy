export class Hud
  new: (@state) =>
    @timer = timer.new!
    @tween = flux.group!

    --cosmetic stuff
    @timerY = 0
    @fadeAlpha = 255
    @tween\to self, .15, {fadeAlpha: 0}

    beholder.group self, ->
      beholder.observe 'show endslate', (newBest) ->
        @createEndslate newBest

        --animations
        @tween\to self, 1, {timerY: -50}
        @timer.add .5, ->
          @tween\to @endSlate, 0.4, {blackAlpha: 100}
          @tween\to @endSlate, 0.5, {y: 0}

        --menu
        @timer.add 1, ->
          @menu = Menu font.mini, WIDTH / 2, 160, {150, 150, 150, 255}, {255, 255, 255, 255}
          with @menu
            \addOption 'Restart', ->
              gamestate.switch game, game.level
            \addOption 'Back to menu', ->
              @menu.takeInput = false
              @tween\to self, .15, {fadeAlpha: 255}
              @timer.add .15, ->
                gamestate.switch levelSelect

  createEndslate: (newBest) =>
    @endSlate = {}
    with @endSlate
      --get time information
      level = @state.level
      .time = @state.time
      .timeRank = level\getRank .time
      .newBest = newBest
      .best = saveManager.data.level[level.levelNum].best
      .bestRank = level\getRank .best
      .next = level\getNext .best

      --cosmetic
      .blackAlpha = 0
      .y = HEIGHT

  update: (dt) =>
    @timer.update dt
    @tween\update dt

    if @menu
      with @menu
        \previous! if input\pressed 'up'
        \next! if input\pressed 'down'
        \select! if input\pressed 'primary'

  destroy: =>
    beholder.stopObserving self

  draw: =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .printAligned string.format('%0.1f', @state.time), font.time, WIDTH / 2, @timerY

      if @endSlate
        --fade to black
        .setColor 0, 0, 0, @endSlate.blackAlpha
        .rectangle 'fill', 0, 0, WIDTH, HEIGHT

        --moves the y position of the text
        .push!
        .translate 0, @endSlate.y

        --draw the time
        .setColor color.rank[@endSlate.timeRank]
        .printAligned string.format('%0.2f', @endSlate.time), font.timeBig, WIDTH / 2, 40, 'center', 'middle'

        --draw the best time (or "new best time!" message)
        if @endSlate.newBest
          .setColor 255, 255, 255, 255
          .printAligned 'New best time!', font.mini, WIDTH / 2, 80, 'center', 'middle'
        else
          .setColor 255, 255, 255, 255
          .printAligned 'Best', font.big, 20, 80, 'left', 'middle'
          .setColor color.rank[@endSlate.bestRank]
          .printAligned string.format('%0.2f', @endSlate.best), font.timeBig, WIDTH - 20, 80, 'right', 'middle'

        --draw the next time (or the "rank achieved!" messages)
        if @endSlate.bestRank == 1
          .setColor color.rank[1]
          .printAligned 'Diamond rank achieved!', font.mini, WIDTH / 2, 120, 'center', 'middle'
        elseif @endSlate.bestRank == 2
          .setColor color.rank[2]
          .printAligned 'Gold rank achieved!', font.mini, WIDTH / 2, 120, 'center', 'middle'
        else
          .setColor 255, 255, 255, 255
          .printAligned 'Goal', font.big, 20, 120, 'left', 'middle'
          .setColor color.rank[@endSlate.bestRank - 1]
          .printAligned string.format('%0.1f', @endSlate.next), font.timeBig, WIDTH - 20, 120, 'right', 'middle'

        .pop!

        --draw menu
        @menu\draw! if @menu

      --draw fade out
      .setColor 0, 0, 0, @fadeAlpha
      .rectangle 'fill', 0, 0, WIDTH, HEIGHT
