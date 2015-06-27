export class MapObject
  new: (@world) =>
    @timer = timer.new!
    @tween = flux.group!

  create: =>

  update: (dt) =>

  draw: =>

  drawDebug: =>
