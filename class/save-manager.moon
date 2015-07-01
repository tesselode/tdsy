export class SaveManager
  new: =>
    @filename = 'save'
    @load!

  unlockLevels: =>
    levelData[1].unlocked = true
    for i = 1, #levelData - 1
      if levelData[i]\getBestRank! < 4
        levelData[i + 1].unlocked = true

  load: =>
    if love.filesystem.exists @filename
      data = love.filesystem.load(@filename)!
      for i = 1, #levelData
        levelData[i].best = data.bestTimes[i]

    @unlockLevels!

  save: =>
    data =
      bestTimes: {}
    for i = 1, #levelData
      data.bestTimes[i] = levelData[i].best

    --write save data
    love.filesystem.write @filename, serialize data
