export class SaveManager
  new: =>
    beholder.group self, ->
      beholder.observe 'set sound balance', (value) ->
        @options.soundBalance = value
        @save!
      beholder.observe 'set music type', (value) ->
        @options.musicType = value
        @save!
      beholder.observe 'set screen size', (value) ->
        @options.screenSize = value
        @save!

        --set the screen size
        if value == 5
          width, height = love.window.getDesktopDimensions!
          love.window.setMode width, height
          love.window.setFullscreen true
        else
          love.window.setFullscreen false
          love.window.setMode WIDTH * value, HEIGHT * value

    @saveFilename = 'save'
    @optionsFilename = 'options'
    @load!

  unlockLevels: =>
    --unlock main levels
    if levelData[1]
      levelData[1].unlocked = true
    for i = 1, NUMLEVELS - 6
      if levelData[i] and levelData[i]\getBestRank! < 4
        if levelData[i + 1] then
          levelData[i + 1].unlocked = true

    --unlock bonus levels
    unlockBonusLevels = true
    for i = 1, NUMLEVELS - 5
      if levelData[i]\getBestRank! > 2
        unlockBonusLevels = false
    if unlockBonusLevels
      for i = 16, NUMLEVELS - 1
        levelData[i].unlocked = true

    --unlock last level
    unlockLastLevel = true
    for i = 1, NUMLEVELS - 1
      if levelData[i]\getBestRank! > 2
        unlockLastLevel = false
    levelData[NUMLEVELS].unlocked = true if unlockLastLevel

    --temporary - every level is unlocked
    --for i = 1, NUMLEVELS do
    --  if levelData[i]
    --    levelData[i].unlocked = true

  load: =>
    --load save data
    if love.filesystem.exists @saveFilename
      data = love.filesystem.load(@saveFilename)!
      for i = 1, NUMLEVELS
        if levelData[i]
          levelData[i].best = data.bestTimes[i]
      @triggers = data.triggers
    else
      @triggers =
        newLevels: {triggered: false, shown: false}
        diamondTimes: {triggered: false, shown: false}

    --load options
    if love.filesystem.exists @optionsFilename
      @options = love.filesystem.load(@optionsFilename)!
    else
      @options =
        soundBalance: 5
        musicType: 1
        screenSize: 2
    beholder.trigger 'set sound balance', @options.soundBalance
    beholder.trigger 'set screen size', @options.screenSize

    @unlockLevels!

  save: =>
    data =
      bestTimes: {}
      triggers: @triggers
    for i = 1, NUMLEVELS
      if levelData[i]
        data.bestTimes[i] = levelData[i].best

    --write save data
    love.filesystem.write @saveFilename, serialize data

    --write options
    love.filesystem.write @optionsFilename, serialize @options
