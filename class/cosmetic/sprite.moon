export class Sprite
  new: (@image) =>
    @color = {255, 255, 255, 255}
    @rotation = 0
    @offset = vector @image\getWidth! / 2, image\getHeight! / 2
    @scale = vector 1, 1

  draw: (x, y) =>
    with love.graphics
      .setColor @color
      .draw @image, x, y, @rotation, @scale.x, @scale.y, @offset.x, @offset.y
