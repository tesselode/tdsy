export class MapObject
  new: (@world) =>
    @timer = timer.new!
    @tween = flux.group!
    @drawDepth = 0

  create: =>

  update: (dt) =>
    @timer.update dt
    @tween\update dt

  draw: =>

  drawDebug: =>
