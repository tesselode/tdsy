export class MapObject
  new: (@world) =>
    @timer = timer.new!
    @tween = flux.group!

  create: =>

  update: (dt) =>
    @timer.update dt
    @tween\update dt

  draw: =>

  drawDebug: =>
