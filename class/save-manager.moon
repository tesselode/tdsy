export class SaveManager
  new: =>
    @filename = 'save'
    @load!

  load: =>
    if love.filesystem.exists @filename
      data = love.filesystem.load(@filename)!
      for i = 1, #levelData
        levelData[i].best = data.bestTimes[i]

  save: =>
    data =
      bestTimes: {}
    for i = 1, #levelData
      data.bestTimes[i] = levelData[i].best

    --write save data
    love.filesystem.write @filename, serialize data
