export class SaveManager
  new: =>
    @saveFilename = 'save'
    @optionsFilename = 'options'
    @load!
    
    beholder.group self, ->
      beholder.observe 'set sound balance', (value) ->
        @options.soundBalance = value
        @save!

  unlockLevels: =>
    if levelData[1]
      levelData[1].unlocked = true
    for i = 1, NUMLEVELS - 1
      if levelData[i] and levelData[i]\getBestRank! < 4
        if levelData[i + 1] then
          levelData[i + 1].unlocked = true
          
    --temporary - every level is unlocked
    for i = 1, NUMLEVELS do
      if levelData[i]
        levelData[i].unlocked = true

  load: =>
    --load save data
    if love.filesystem.exists @saveFilename
      data = love.filesystem.load(@saveFilename)!
      for i = 1, NUMLEVELS
        if levelData[i]
          levelData[i].best = data.bestTimes[i]
    
    --load options
    if love.filesystem.exists @optionsFilename
      @options = love.filesystem.load(@optionsFilename)!
    else
      @options =
        soundBalance: 5
    beholder.trigger 'set sound balance', @options.soundBalance

    @unlockLevels!

  save: =>
    data =
      bestTimes: {}
    for i = 1, NUMLEVELS
      if levelData[i]
        data.bestTimes[i] = levelData[i].best

    --write save data
    love.filesystem.write @saveFilename, serialize data
    
    --write options
    love.filesystem.write @optionsFilename, serialize @options
