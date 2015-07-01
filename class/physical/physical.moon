export class Physical extends MapObject
  create: (position, size) =>
    if self.spawnCentered
      @world\add self, position.x - size.x / 2, position.y - size.y / 2, size.x, size.y
    else
      @world\add self, position.x, position.y, size.x, size.y

    @velocity = vector!

    @hitboxColor = {150, 150, 150, 100}

  filter: (other) => 'cross'

  getCenter: =>
    x, y, w, h = @world\getRect self
    vector x + w / 2, y + h / 2

  move: (displacement) =>
    --perform movement
    currentX, currentY = @world\getRect self
    goal = vector(currentX, currentY) + displacement
    actualX, actualY, cols, len = @world\move self, goal.x, goal.y, @filter

    --call collision callback
    for col in *cols do
      @collision col

    --return info (kind of redundant)
    vector(actualX, actualY), cols, len

  update: (dt) =>
    super dt

    --apply velocity
    @move @velocity * dt

  collision: (col) =>

  drawDebug: =>
    --draw hitbox
    with love.graphics
      .setColor @hitboxColor
      .rectangle 'fill', @world\getRect self
