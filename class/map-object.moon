export class MapObject
  new: (@world) =>
    @timer = timer.new!
    @tween = flux.group!
    @drawDepth = love.math.random!
    @delete = false

  create: =>

  update: (dt) =>
    @timer.update dt
    @tween\update dt

  draw: =>

  drawDebug: =>
