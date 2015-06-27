export class Map
  new: =>
    @world = bump.newWorld!
    @objects = {}
    table.insert @objects, MapObject!

  addObject: (object, ...) =>
    newObject = object @world
    newObject\create ...
    table.insert(self.objects, newObject)
    newObject

  draw: =>
    for object in *@objects do
      object\draw!
