export class Jellyfish extends Physical
  create: (position, angle) =>
    @spawnCentered = true
    super position, vector 12, 12

    @angle = angle or 0

    @bounced = false
    @sprite = Sprite image.jellyfish
    @sprite.rotation = @angle
    @floatSpeed = love.math.random(1, 6)
    @floating = true

    @uptime = 0

  bounce: =>
    if not @bounced
      @bounced = true
      @sprite = Sprite image.jellyfishBounced
      @sprite.rotation = @angle
      beholder.trigger 'jellyfish bounced'

      --bounce animation
      @floating = false
      @tween\to(@sprite.offset, .1, {y: -2})\ease('quadout')
      @tween\to(@sprite.offset, .1, {y: 8})\ease('quadin')\delay(.1)
      @timer.add .2, ->
        --restart floating animation
        @uptime = 0
        @floating = true

  update: (dt) =>
    super dt

    --floating effect
    @uptime += dt
    if @floating
      @sprite.offset.y = 8 + math.sin(@uptime * @floatSpeed)

  draw: =>
    x, y = @getCenter!\unpack!
    x, y = lume.round(x), lume.round(y)
    @sprite\draw x, y
