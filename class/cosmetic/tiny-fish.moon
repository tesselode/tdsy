export class TinyFish extends MapObject
  create: (@direction, @position) =>
    @speed = love.math.random(40, 60) * @direction
    @velocity = vector @speed, 0
    @sprite = Sprite image.tinyFish
    @sprite.scale.x = @direction
    @angle = 0
    @uptime = 0
    @turnRadius = love.math.random(10, 30) / 100
    @turnSpeed = love.math.random(50, 100) / 100
    
  update: (dt) =>
    @uptime += dt
    @angle = @turnRadius * math.sin @uptime * @turnSpeed
    @velocity = vector(@speed, 0)\rotated(@angle)
    @sprite.rotation = @angle
    @position += @velocity * dt
    
  draw: =>
    @sprite\draw lume.round(@position.x), lume.round(@position.y)
    
    
    
export class TinyFishSpawner
  new: (@map, @levelData) =>
    @timer = timer.new!
    
    --spawn initial fish
    for i = 1, love.math.random(10)
      @spawnFish lume.randomchoice({-1, 1}), true
    if love.math.random(1, 3) == 3
      @spawnSchool lume.randomchoice({-1, 1}), true
      
    --timers for spawning additional fish
    @newTimer!
    @newSchoolTimer!
    
  newTimer: =>
    @timer.add love.math.random(1, 3), ->
      @spawnFish lume.randomchoice({-1, 1}), false
      @newTimer!
    
  newSchoolTimer: =>
    @timer.add love.math.random(5, 10), ->
      @spawnSchool lume.randomchoice({-1, 1}), false
      @newSchoolTimer!
    
  update: (dt) =>
    @timer.update dt
  
  spawnFish: (direction, randomX) =>
    local x, y
    if randomX
      x = love.math.random(0, @levelData.map.width)
    else
      if direction == 1
        x = -16
      elseif direction == -1
        x = @levelData.map.width + 16
    y = love.math.random 50, HEIGHT - 50
    
    @map\addObject TinyFish, direction, vector x, y
  
  spawnSchool: (direction, randomX) =>
    local x, y
    if randomX
      x = love.math.random(0, @levelData.map.width)
    else
      if direction == 1
        x = -16
      elseif direction == -1
        x = @levelData.map.width + 16
    y = love.math.random 50, HEIGHT - 50
    
    @fish = {}
    for i = 1, love.math.random 5, 15
       @map\addObject TinyFish, direction, vector(x, y) + vector love.math.random(-40, 40), love.math.random(-40, 40)