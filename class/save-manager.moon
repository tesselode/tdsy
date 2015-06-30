export class SaveManager
  new: =>
    @filename = 'save'
    @load!

  unlockLevels: =>
    for i = 1, 15
      best = @data.level[i].best
      if best and level[i]\getRank(best) < 4
        @data.level[i + 1].unlocked = true

  load: =>
    if love.filesystem.exists @filename
      --load save data if there is any
      @data = love.filesystem.load(@filename)!
    else
      --otherwise, create new save data
      @data = {}
      @data.level = {}
      for i = 1, 16
        @data.level[i] = {}
        if i == 1
          @data.level[i].unlocked = true
        else
          @data.level[i].unlocked = false

  write: =>
    love.filesystem.write @filename, serialize @data
