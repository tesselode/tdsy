export class Map
  new: (level) =>
    @world = bump.newWorld!
    @objects = {}
    @addObject Jellyfish, vector(200, 200), 0
    with @addObject Fish, vector(200, 100)
      \activate!

  addObject: (object, ...) =>
    newObject = object @world
    newObject\create ...
    table.insert(self.objects, newObject)
    newObject

  update: (dt) =>
    --update all objects
    for object in *@objects do
      object\update dt

  draw: =>
    --draw all objects
    for object in *@objects do
      object\draw!
      object\drawDebug! if DEBUG
