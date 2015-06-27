export class Jellyfish extends Physical
  create: (position, angle) =>
    @spawnCentered = true
    super position, vector 12, 12

    @angle = angle or 0

    @bounced = false
    @floatSpeed = love.math.random(1, 6)
    @floating = true

    @uptime = 0

  bounce: =>
    if not @bounced
      @bounced = true
      beholder.trigger 'jellyfish bounced'

      --bounce animation
      @floating = false
      @timer.add .2, ->
        --restart floating animation
        @uptime = 0
        @floating = true

  update: (dt) =>
    super dt

    --floating effect
    @uptime += dt
