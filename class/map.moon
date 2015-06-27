export class Map
  new: =>
    @world = bump.newWorld!
    @objects = {}

    @loadLevel 'level1'

  addObject: (object, ...) =>
    newObject = object @world
    newObject\create ...
    table.insert(self.objects, newObject)
    newObject

  loadLevel: (levelName) =>
    level = Level levelName

    --spawn jellyfish
    for jellyfish in *level.jellyfish
      with jellyfish
        @addObject Jellyfish, vector(.x, .y), .angle

  update: (dt) =>
    for object in *@objects do
      object\update dt

  draw: =>
    for object in *@objects do
      object\draw!
      object\drawDebug! if DEBUG
