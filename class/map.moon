export class Map
  new: (levelData) =>
    @loadLevel levelData
    @enabled = true

  loadLevel: (levelData) =>
    @world = bump.newWorld!
    @objects = {}

    --create outside borders
    with levelData.map
      @addObject Border, vector(0, 0), vector(.width, 1)
      @addObject Border, vector(0, .height - 8), vector(.width, 8)
      @addObject Border, vector(0, 0), vector(1, .height)
      @addObject Border, vector(.width, 0), vector(1, .height)

    --spawn fish
    with levelData.map.fish
      @fish = @addObject Fish, vector .x, .y
      @camera = Camera @fish, levelData.map.width, levelData.map.height

    --spawn jellyfish
    for jellyfish in *levelData.map.jellyfish
      with jellyfish
        @addObject Jellyfish, vector(.x, .y), .angle

    --background
    @background = BackgroundGameplay levelData

  addObject: (object, ...) =>
    newObject = object @world
    newObject\create ...
    table.insert(self.objects, newObject)
    newObject

  update: (dt) =>
    --update scenery
    @background\update dt

    if not @enabled
      return false

    --update all objects
    for object in *@objects do
      object\update dt

    --delete objects
    for i = #@objects, 1, -1 do
      if @objects[i].delete
        table.remove @objects, i

    @camera\update dt

  draw: =>
    with love.graphics
      .setStencil ->
        .rectangle 'fill', 0, 0, WIDTH, HEIGHT

      --draw background
      @background\draw!

      --attach camera
      .push!
      .translate -@camera.position.x, -@camera.position.y

      --draw scrolling parts of background
      @background\drawScrolling!

      --draw all objects
      table.sort @objects, (a, b) -> return a.drawDepth > b.drawDepth
      for object in *@objects do
        if object.__class ~= Fish or @enabled --don't draw the fish if disabled (this helps with a transition for speedrun mode)
          object\draw!
          object\drawDebug! if DEBUG

      .pop!

      .setStencil!
