export class Fish extends Physical
  create: (position) =>
    @spawnCentered = true
    super position, vector 12, 12

    --tweak these
    @inputCurve         = 2
    @gravity            = 10
    @acceleration       = 800
    @friction           = .15
    @maxSpeed           = 175
    @dartSpeed          = 400
    @dartFriction       = .01
    @dartCooldown       = .15
    @minimumBounceSpeed = 30
    @maxHealth          = 3

    --don't tweak these
    @active = false
    @inputVector = vector!
    @darting = false
    @canDart = true

    --cosmetic stuff
    @hitboxColor = {255, 255, 255, 100}
    @sprite = Sprite image.fish
    @bubbleTrail = love.graphics.newParticleSystem image.bubbleSmall, 10000
    with @bubbleTrail
      \setSpeed 25, 25
      \setLinearAcceleration 0, -100, 0, -100
      \setParticleLifetime 5, 5
      \setSpread 6

    @activate!

  filter: (other) =>
    if other.__class == Jellyfish or other.__class == Border then
      return 'slide'
    else
      return 'cross'

  activate: =>
    @active = true
    beholder.trigger 'level start'

  dart: =>
    if not @active then
      @activate!

    if @canDart and @inputVector\len! ~= 0
      @darting = true
      @velocity = @inputVector * @dartSpeed

      --cooldown
      @canDart = false
      @timer.add @dartCooldown, ->
        @canDart = true

      --adjust sprite
      @sprite.scale.y = lume.sign @velocity.x

  update: (dt) =>
    if not @active and @inputVector\len! ~= 0
      @activate!
    if not @active
      return false

    --input curve
    curvedLength = @inputVector\len! ^ @inputCurve
    @inputVector = @inputVector\normalized! * curvedLength

    --gravity
    @velocity.y += @gravity * dt

    --movement
    @velocity += @inputVector * @acceleration * dt

    --friction
    local lerpFactor
    if @darting
      lerpFactor = @dartFriction
    else
      lerpFactor = @friction
    newSpeed = lume.lerp @velocity\len!, 0, 1 - lerpFactor ^ dt
    @velocity = @velocity\normalized! * newSpeed

    --darting
    if @darting and @velocity\len! < @maxSpeed
      @darting = false

    --limit speed
    if not @darting and @velocity\len! > @maxSpeed then
      @velocity = @velocity\normalized! * @maxSpeed

    --apply movement (finally!)
    super dt

    --sprite stuff
    @sprite.rotation = @velocity\angleTo!

    --cosmetic stuff
    x, y = @getCenter!\unpack!
    with @bubbleTrail
      \setPosition x, y
      \setDirection @velocity\angleTo! * math.pi
      if @darting
        \start!
        \setEmissionRate 35
      elseif @inputVector\len! ~= 0
        \start!
        \setEmissionRate 3
      else
        \stop!

      \update dt

  collision: (col) =>
    if col.other.__class == Jellyfish
      --find relative direction of the collision
      normal = vector(col.normal.x, col.normal.y)\rotated(-col.other.angle)
      normal.x, normal.y = lume.round(normal.x), lume.round(normal.y)

      --get relative velocity
      relativeVelocity = @velocity\rotated -col.other.angle

      --horizontal collisions
      if normal.x ~=0
        relativeVelocity.x = 0

      --bounce off of jellyfish
      if normal.y < 0
        relativeVelocity.y = -relativeVelocity.y - @minimumBounceSpeed
        col.other\bounce!
      elseif normal.y > 0
        relativeVelocity.y = 0

      --set velocity
      @velocity = relativeVelocity\rotated col.other.angle

    --if col.other.__class == Border
    --  if col.normal.x ~= 0 then
    --    @velocity.x = 0
    --  if col.normal.y ~= 0 then
    --    @velocity.y = 0

  draw: =>
    --draw bubble trail
    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @bubbleTrail

    --draw sprite
    x, y = @getCenter!\unpack!
    x, y = lume.round(x), lume.round(y)
    @sprite\draw x, y
