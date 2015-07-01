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
        --create endslate
        @endSlate =
          newBest: newBest
          blackAlpha: 0
          y: HEIGHT

        --animations
        @tween\to self, 1, {timerY: -50}
        @timer.add .5, ->
          @tween\to @endSlate, 0.4, {blackAlpha: 100}
          @tween\to @endSlate, 0.5, {y: 0}

  update: (dt) =>
    @timer.update dt
    @tween\update dt

    --menu input
    if @menu
      with @menu
        \previous! if input\pressed 'up'
        \next! if input\pressed 'down'
        \select! if input\pressed 'primary'

  destroy: =>
    beholder.stopObserving self

  draw: =>
    with love.graphics
      --draw time
      .setColor 255, 255, 255, 255
      .printAligned string.format('%0.1f', @state.time), font.time, WIDTH / 2, @timerY

      --level end slate
      if @endSlate
        --fade to black
        .setColor 0, 0, 0, @endSlate.blackAlpha
        .rectangle 'fill', 0, 0, WIDTH, HEIGHT

        --moves the y position of the text
        .push!
        .translate 0, @endSlate.y

        --draw the time
        .setColor color.rank[@state.levelData\getRank(@state.time)]
        .printAligned string.format('%0.2f', @state.time), font.timeBig, WIDTH / 2, 40, 'center', 'middle'

        --draw best time (or "new best time!" message)
        if @endSlate.newBest
          .setColor 255, 255, 255, 255
          .printAligned 'New best time!', font.mini, WIDTH / 2, 80, 'center', 'middle'
        else
          .setColor 255, 255, 255, 255
          .printAligned 'Best', font.big, 20, 80, 'left', 'middle'
          .setColor color.rank[@state.levelData\getBestRank!]
          .printAligned string.format('%0.2f', @state.levelData.best), font.timeBig, WIDTH - 20, 80, 'right', 'middle'

        --draw goal time (or "rank achieved!" messages)
        if @state.levelData\getBestRank! == 1
          .setColor color.rank[1]
          .printAligned 'Diamond rank achieved!', font.mini, WIDTH / 2, 120, 'center', 'middle'
        elseif @state.levelData\getBestRank! == 2
          .setColor color.rank[2]
          .printAligned 'Gold rank achieved!', font.mini, WIDTH / 2, 120, 'center', 'middle'
        else
          .setColor 255, 255, 255, 255
          .printAligned 'Goal', font.big, 20, 120, 'left', 'middle'
          .setColor color.rank[@state.levelData\getBestRank! - 1]
          .printAligned string.format('%0.1f', @state.levelData\getNext!), font.timeBig, WIDTH - 20, 120, 'right', 'middle'

        .pop!

        --draw menu
        @menu\draw! if @menu

      --draw fade out
      .setColor 0, 0, 0, @fadeAlpha
      .rectangle 'fill', 0, 0, WIDTH, HEIGHT