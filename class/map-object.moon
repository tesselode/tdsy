export class MapObject
  draw: =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .print 'hello world'
