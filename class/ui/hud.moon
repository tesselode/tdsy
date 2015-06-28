export class Hud
  new: (@state) =>
    @timer = timer.new!
    @tween = flux.group!

    --cosmetic stuff
    @timerY = 0

    beholder.group self, ->
      beholder.observe 'show endslate', (newBest) ->
        @createEndslate newBest

        --animations
        @tween\to self, 1, {timerY: -50}
        @timer.add .5, ->
          @tween\to @endSlate, 0.4, {blackAlpha: 100}
          @tween\to @endSlate, 0.5, {y: 0}

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

  destroy: =>
    beholder.stopObserving self

  draw: =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .printAligned string.format('%0.1f', @state.time), font.time, WIDTH / 2, @timerY

      if @endSlate
        .setColor 0, 0, 0, @endSlate.blackAlpha
        .rectangle 'fill', 0, 0, WIDTH, HEIGHT

        .push!
        .translate 0, @endSlate.y

        .setColor color.rank[@endSlate.timeRank]
        .printAligned string.format('%0.2f', @endSlate.time), font.timeBig, WIDTH / 2, 60, 'center', 'middle'

        if @endSlate.newBest
          .setColor 255, 255, 255, 255
          .printAligned 'New best time!', font.time, WIDTH / 2, 100, 'center', 'middle'
        else
          .setColor 255, 255, 255, 255
          .printAligned 'Best: ', font.time, 20, 100, 'left', 'middle'
          .setColor color.rank[@endSlate.bestRank]
          .printAligned string.format('%0.2f', @endSlate.best), font.timeBig, WIDTH - 20, 100, 'right', 'middle'

        if @endSlate.bestRank == 1
          .setColor color.rank[1]
          .printAligned 'Diamond rank achieved!', font.time, WIDTH / 2, 140, 'center', 'middle'
        elseif @endSlate.bestRank == 2
          .setColor color.rank[2]
          .printAligned 'Gold rank achieved!', font.time, WIDTH / 2, 140, 'center', 'middle'
        else
          .setColor 255, 255, 255, 255
          .printAligned 'Next: ', font.time, 20, 140, 'left', 'middle'
          .setColor color.rank[@endSlate.bestRank - 1]
          .printAligned string.format('%0.2f', @endSlate.next), font.timeBig, WIDTH - 20, 140, 'right', 'middle'

        .pop!
