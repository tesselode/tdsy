export class Hud
  new: (@state) =>
    @timer = timer.new!
    @tween = flux.group!

    @allGold = true
    for i = 1, NUMLEVELS
      if levelData[i]\getBestRank! > 2
        @allGold = false

    --cosmetic stuff
    @goalDisplayY = 10
    @timerY = -50
    @tutorialY = HEIGHT + 20
    @tween\to(self, .5, {tutorialY: HEIGHT * .75})
    @fadeAlpha = 255
    @tween\to self, .15, {fadeAlpha: 0}

    beholder.group self, ->
      beholder.observe 'level start', ->
        @tween\to(self, .35, {goalDisplayY: -50})\ease 'linear'
        @tween\to(self, .35, {timerY: 10})\ease 'linear'
        @tween\to(self, .5, {tutorialY: HEIGHT + 20})

      beholder.observe 'show endslate', (newBest) ->
        --create endslate
        @endSlate =
          newBest: newBest
          blackAlpha: 0
          y: HEIGHT
        @buttonDisplay = ButtonDisplay 'Go!'

        --animations
        @tween\to self, 1, {timerY: -50}
        @timer.add .5, ->
          @tween\to @endSlate, 0.4, {blackAlpha: 100}
          @tween\to @endSlate, 0.5, {y: 0}

        --menu
        @timer.add 1, ->
          @menu = Menu font.mini, WIDTH / 2, 160, {150, 150, 150, 255}, {255, 255, 255, 255}
          with @menu
            \addOption MenuOption 'Restart', ->
              gamestate.switch announcement, ->
                gamestate.switch game, game.levelData
              beholder.trigger 'menu select'

            nextLevel = levelData[@state.levelData.levelNum + 1]
            if nextLevel and nextLevel.unlocked
              \addOption MenuOption 'Next level', ->
                beholder.trigger 'menu select'
                @menu.takeInput = false
                @tween\to self, .15, {fadeAlpha: 255}
                @timer.add .15, ->
                  gamestate.switch announcement, ->
                    gamestate.switch game, levelData[game.levelData.levelNum + 1]

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
      --draw goal time
      local maxGoalToShow
      if @allGold
        maxGoalToShow = 1
      else
        maxGoalToShow = 2

      .setColor color.white
      if @state.levelData\getBestRank! > maxGoalToShow
        .printAligned 'Goal: ', font.mini, WIDTH / 2, @goalDisplayY, 'right', 'middle'
        .printAligned string.format('%0.1f', @state.levelData\getNext!), font.time, WIDTH / 2, @goalDisplayY, 'left', 'middle'
      else
        .printAligned 'Best: ', font.mini, WIDTH / 2, @goalDisplayY, 'right', 'middle'
        .printAligned string.format('%0.2f', @state.levelData.best), font.time, WIDTH / 2, @goalDisplayY, 'left', 'middle'

      --draw time
      .setColor 255, 255, 255, 255
      .printAligned string.format('%0.1f', @state.time), font.time, WIDTH / 2, @timerY, 'center', 'middle'

      --tutorial text (levels 1 and 2)
      if @state.levelData.levelNum == 1 and @state.levelData\getBestRank! == 4
        .setFont font.mini
        .printf 'Arrow keys/analog stick\nto move', 0, @tutorialY, WIDTH, 'center'
      if @state.levelData.levelNum == 2 and @state.levelData\getBestRank! == 4
        .setFont font.mini
        .printf 'X key/A button\nto dash', 0, @tutorialY, WIDTH, 'center'
      if @state.levelData.levelNum == 3 and @state.levelData\getBestRank! == 4
        .setFont font.mini
        .printf 'R key/Back button\nto restart', 0, @tutorialY, WIDTH, 'center'

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
          if @state.levelData.best
            .printAligned string.format('%0.2f', @state.levelData.best), font.timeBig, WIDTH - 20, 80, 'right', 'middle'
          else
            .printAligned string.format('--'), font.timeBig, WIDTH - 20, 80, 'right', 'middle'

        --draw goal time (or "rank achieved!" messages)
        if @state.levelData\getBestRank! == 1
          .setColor color.rank[1]
          .printAligned 'Diamond rank achieved!', font.mini, WIDTH / 2, 120, 'center', 'middle'
        elseif @state.levelData\getBestRank! == 2 and not @allGold
          .setColor color.rank[2]
          .printAligned 'Gold rank achieved!', font.mini, WIDTH / 2, 120, 'center', 'middle'
        else
          .setColor 255, 255, 255, 255
          .printAligned 'Goal', font.big, 20, 120, 'left', 'middle'
          .setColor color.rank[@state.levelData\getBestRank! - 1]
          .printAligned string.format('%0.1f', @state.levelData\getNext!), font.timeBig, WIDTH - 20, 120, 'right', 'middle'

        @buttonDisplay\draw!

        .pop!

        --draw menu
        @menu\draw! if @menu

      --practice mode message
      if @state.gameSpeed < 1
        .setColor color.red
        .printAligned 'Practice mode', font.tiny, 5, 5, 'left', 'top'


      --draw fade out
      .setColor 0, 0, 0, @fadeAlpha
      .rectangle 'fill', 0, 0, WIDTH, HEIGHT
