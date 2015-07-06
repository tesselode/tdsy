export class SaveManager
  new: =>
    @filename = 'save'
    @load!

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
    if love.filesystem.exists @filename
      data = love.filesystem.load(@filename)!
      for i = 1, NUMLEVELS
        if levelData[i]
          levelData[i].best = data.bestTimes[i]

    @unlockLevels!

  save: =>
    data =
      bestTimes: {}
    for i = 1, NUMLEVELS
      if levelData[i]
        data.bestTimes[i] = levelData[i].best

    --write save data
    love.filesystem.write @filename, serialize data
