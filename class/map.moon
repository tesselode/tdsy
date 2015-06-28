export class Map
  new: =>
    @world = bump.newWorld!
    @objects = {}

    @loadLevel level[1]

  addObject: (object, ...) =>
    newObject = object @world
    newObject\create ...
    table.insert(self.objects, newObject)
    newObject

  loadLevel: (levelInstance) =>
    --create outside borders
    with levelInstance
      @addObject Border, vector(0, 0), vector(.width, 1)
      @addObject Border, vector(0, .height - 8), vector(.width, 8)
      @addObject Border, vector(0, 0), vector(1, .height)
      @addObject Border, vector(.width, 0), vector(1, .height)

    --spawn fish
    with levelInstance.fish
      @addObject Fish, vector .x, .y

    --spawn jellyfish
    for jellyfish in *levelInstance.jellyfish
      with jellyfish
        @addObject Jellyfish, vector(.x, .y), .angle

  update: (dt) =>
    for object in *@objects do
      object\update dt

  draw: =>
    for object in *@objects do
      object\draw!
      object\drawDebug! if DEBUG
