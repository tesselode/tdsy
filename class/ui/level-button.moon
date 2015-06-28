export class LevelButton
  new: (@level, @x, @y, @w, @h) =>

  draw: =>
    with love.graphics
      .setColor 44, 133, 222, 255
      .rectangle 'fill', @x, @y, @w, @h
