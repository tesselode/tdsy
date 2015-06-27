export class Map
  new: =>
    @world = bump.newWorld!
    @objects = {}
    table.insert @objects, MapObject!

    @addObject Physical, vector(400, 300), vector(30, 30)

  addObject: (object, ...) =>
    newObject = object @world
    newObject\create ...
    table.insert(self.objects, newObject)
    newObject

  update: (dt) =>
    for object in *@objects do
      object\update dt

  draw: =>
    for object in *@objects do
      object\draw!
      object\drawDebug! if DEBUG
