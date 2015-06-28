export class Camera
  new: (@fish, @width, @height) =>
    @position = vector!

  update: (dt) =>
    --follow player
    @position = @fish\getCenter! - vector WIDTH / 2, HEIGHT / 2

    --limit to world bounds
    @position.x = lume.clamp @position.x, 0, @width - WIDTH
    @position.y = lume.clamp @position.y, 0, @height - HEIGHT
