export class Background
  new: (@width, @height) =>
    @canvas = love.graphics.newCanvas @width, @height

  update: (dt) =>
    @tinyFishSpawner\update dt
    for fish in *@fish
      fish\update dt

  draw: =>
    --draw water
    stop1 = @transition1
    stop2 = stop1 + image.waterBright\getHeight!
    stop3 = @transition2
    stop4 = @transition2 + image.water\getHeight!

    with love.graphics
      .setColor 91, 153, 244, 255
      .rectangle 'fill', 0, 0, WIDTH, stop1

      .setColor 255, 255, 255, 255
      for i = 0, WIDTH, image.waterBright\getWidth!
        .draw image.waterBright, i, stop1

      .setColor 68, 80, 140, 255
      .rectangle 'fill', 0, stop2, WIDTH, stop3 - stop2

      .setColor 255, 255, 255, 255
      for i = 0, WIDTH, image.water\getWidth!
        .draw image.water, i, stop3

      .setColor 42, 52, 67, 255
      .rectangle 'fill', 0, stop4, WIDTH, HEIGHT - stop4

  drawScrolling: =>
    --draw fish
    for fish in *@fish
      fish\draw!
    
    --draw scenery
    with love.graphics
      .setColor 255, 255, 255, 255
      .draw @canvas



export class BackgroundGameplay extends Background
  new: (width, height) =>
    super width, height
    
    --water
    @transition1 = 0
    @transition2 = HEIGHT - 48  
    
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
    
    --water
    @transition1 = HEIGHT * .5
    @transition2 = HEIGHT
    
    --background fish
    @fish = {}
    @tinyFishSpawner = TinyFishSpawner self, @width, 5