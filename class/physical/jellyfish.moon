export class Jellyfish extends Physical
  create: (position, angle) =>
    @spawnCentered = true
    super position, vector 12, 12

    @angle = angle or 0

    @bounced = false

    --cosmetic
    g = anim8.newGrid 16, 17, image.jellyfish\getWidth!, image.jellyfish\getHeight!
    @sprite = AnimatedSprite image.jellyfish, anim8.newAnimation g('1-5', 1), love.math.random! * .4 + .8
    with @sprite
      .rotation = @angle
      .speed = love.math.random 1, 5

  bounce: =>
    if not @bounced
      @bounced = true
      @sprite.image = image.jellyfishBounced
      beholder.trigger 'jellyfish bounced'

      --bounce animation
      @tween\to(@sprite.offset, .1, {y: -2})\ease('quadout')
      @tween\to(@sprite.offset, .1, {y: 8})\ease('quadin')\delay(.1)

      --checkmark (colorblind mode)
      @checkmarkSprite = Sprite image.checkmark
      @tween\to(@checkmarkSprite.offset, .2, {y: 20})\ease('quadout')

  update: (dt) =>
    super dt
    @sprite\update dt

  draw: =>
    x, y = @getCenter!\unpack!
    x, y = lume.round(x), lume.round(y)
    @sprite\draw x, y
    if @checkmarkSprite
      @checkmarkSprite\draw x, y
