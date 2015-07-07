export class Sprite
  new: (@image) =>
    @color = {255, 255, 255, 255}
    @rotation = 0
    @offset = vector @image\getWidth! / 2, image\getHeight! / 2
    @scale = vector 1, 1

  update: =>

  draw: (x, y) =>
    with love.graphics
      .setColor @color
      .draw @image, x, y, @rotation, @scale.x, @scale.y, @offset.x, @offset.y

export class AnimatedSprite extends Sprite
  new: (image, @animation) =>
    super image
    @speed = 1
    @offset = vector 8, 8
    
  update: (dt) =>
    @animation\update dt * @speed
    
  draw: (x, y) =>
    love.graphics.setColor @color
    @animation\draw @image, x, y, @rotation, @scale.x, @scale.y, @offset.x, @offset.y