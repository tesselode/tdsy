export class Map
  new: (levelData) =>
    @loadLevel levelData
    @tinyFishSpawner = TinyFishSpawner self, levelData

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
    @background = Background levelData.map.width, levelData.map.height

  addObject: (object, ...) =>
    newObject = object @world
    newObject\create ...
    table.insert(self.objects, newObject)
    newObject

  update: (dt) =>
    --update all objects
    for object in *@objects do
      object\update dt

    @camera\update dt
    
    --spawn little fishies
    @tinyFishSpawner\update dt

  draw: =>
    --draw background
    @background\draw!

    --attach camera
    with love.graphics
      .push!
      .translate -@camera.position.x, -@camera.position.y

    --draw scrolling parts of background
    @background\drawScrolling!

    --draw all objects
    for object in *@objects do
      object\draw!
      object\drawDebug! if DEBUG

    love.graphics.pop!
