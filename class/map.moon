export class Map
  new: =>
    @objects = {}
    table.insert @objects, MapObject!

  draw: =>
    for object in *@objects do
      object\draw!
