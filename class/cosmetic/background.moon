export class Background
  new: (@width, @height) =>
    @canvas = love.graphics.newCanvas @width, @height

  update: (dt) =>
    @tinyFishSpawner\update dt
    for fish in *@fish
      fish\update dt
      
    for i = #@fish, 1, -1
      if @fish[i].delete
        table.remove @fish, i
        
  draw: =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @background

  drawScrolling: =>
    --draw fish
    for fish in *@fish
      fish\draw!
    
    --draw scenery
    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @canvas



export class BackgroundGameplay extends Background
  new: (width, height, weird) =>
    super width, height
    
    if weird
      @background = image.backgroundWeird
    else
      @background = image.background
    
    --background fish
    @fish = {}
    @tinyFishSpawner = TinyFishSpawner self, @width
    
    --scenery
    with love.graphics
      @canvas\renderTo ->
        .setColor 255, 255, 255, 255

        --seaweed
        local baseX, baseXPrevious
        for i = 1, 4 * (@width / WIDTH)
          --choose the position for the next bunch of seaweed
          baseXPrevious = baseX or -100
          baseX = baseXPrevious + love.math.random 100, 200

          for j = 1, love.math.random 4, 12
            --create individual seaweeds
            x = baseX + love.math.random -50, 50
            seaweedHeight = love.math.random(2, 10) / 2

            --draw the seaweed
            for k = 1, seaweedHeight
              y = HEIGHT - 8 - 16 * k
              if k == seaweedHeight
                .draw image.seaweed3, x, y
              else
                .draw lume.randomchoice({image.seaweed1, image.seaweed2}), x, y

        --coral
        baseX, baseXPrevious = 0, 0
        while baseX < @width
          baseXPrevious = baseX
          baseX = baseXPrevious + love.math.random 10, 50
          sprite = lume.randomchoice {image.coral1, image.coral2, image.coral3, image.coral4}
          .draw sprite, baseX, love.math.random(HEIGHT - 8, HEIGHT), 0, 1, 1, 0, sprite\getHeight!

        --sand at bottom
        .setColor 255, 255, 255, 255
        for i = 0, @width, image.sand\getWidth!
          .draw image.sand, i, HEIGHT - 8
          


export class BackgroundMenu extends Background
  new: (width, height) =>
    super width, height
    
    @background = image.backgroundMenu
    
    --background fish
    @fish = {}
    @tinyFishSpawner = TinyFishSpawner self, @width, 5