export class MapObject
  new: (@world) =>
    @timer = timer.new!
    @tween = flux.group!

  create: =>

  draw: =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .print 'hello world'
