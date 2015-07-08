export class TinyFish
  new: (@direction, @width, @position) =>
    @speed = love.math.random(40, 60) * @direction
    @velocity = vector @speed, 0
    @sprite = Sprite image.tinyFish
    @sprite.scale.x = @direction
    @angle = 0
    @uptime = 0
    @turnRadius = love.math.random(10, 30) / 100
    @turnSpeed = love.math.random(50, 100) / 100
    @drawDepth = 100
    
  update: (dt) =>
    --turn slightly
    @uptime += dt
    @angle = @turnRadius * math.sin @uptime * @turnSpeed
    @velocity = vector(@speed, 0)\rotated(@angle)
    @sprite.rotation = @angle
    @position += @velocity * dt
    
    --delete when off screen
    if (@direction == 1 and @position.x > @width + 100) or (@direction == -1 and @position.x < -100)
      @delete = true
    
  draw: =>
    @sprite\draw lume.round(@position.x), lume.round(@position.y)
    
    
    
export class TinyFishSpawner
  new: (@background, @width, spawnSchools) =>
    @timer = timer.new!
    
    --fish spawning
    for i = 1, love.math.random(10)
      @spawnFish lume.randomchoice({-1, 1}), true
    @newTimer!
    
    --fish school spawning
    if spawnSchools
      if love.math.random(1, 3) == 3
        @spawnSchool lume.randomchoice({-1, 1}), true
      @newSchoolTimer!
    
  spawnFish: (direction, randomX) =>
    --decide the position of the fish
    local x, y
    if randomX
      x = love.math.random(0, @width)
    else
      if direction == 1
        x = -16
      elseif direction == -1
        x = @width + 16
    y = love.math.random 50, HEIGHT - 50
    
    --add a fish
    table.insert @background.fish, TinyFish direction, @width, vector x, y
  
  spawnSchool: (direction, randomX) =>
    --decide the position of the fish
    local x, y
    if randomX
      x = love.math.random(0, @width)
    else
      if direction == 1
        x = -16
      elseif direction == -1
        x = @width + 16
    y = love.math.random 50, HEIGHT - 50
    
    --add a bunch of fish
    @fish = {}
    for i = 1, love.math.random 5, 15
      pos = vector(x, y) + vector love.math.random(-40, 40), love.math.random(-40, 40)
      table.insert @background.fish, TinyFish direction, @width, pos
    
  newTimer: =>
    --spawn single fish at random intervals
    @timer.add love.math.random(1, 3), ->
      @spawnFish lume.randomchoice({-1, 1}), false
      @newTimer!
    
  newSchoolTimer: =>
    --spawn schools of fish at random intervals
    @timer.add love.math.random(5, 10), ->
      @spawnSchool lume.randomchoice({-1, 1}), false
      @newSchoolTimer!
    
  update: (dt) =>
    @timer.update dt