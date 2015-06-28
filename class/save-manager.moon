export class SaveManager
  new: =>
    @filename = 'save'
    @load!

  load: =>
    if love.filesystem.exists @filename
      @data = love.filesystem.load(@filename)!
    else
      @data = {}
      @data.level = {}
      for i = 1, 16
        @data.level[i] = {}

  write: =>
    love.filesystem.write @filename, serialize @data
