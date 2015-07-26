export class ButtonDisplay
  new: (@continue, @back) =>

  draw: =>
    with love.graphics
      if @continue
        .setColor 82, 144, 60, 255
        x = WIDTH - 5 - font.mini\getWidth(@continue) - 15
        .circle 'fill', x, HEIGHT - 10, 8, 100
        .setColor color.white
        .printAligned 'A', font.mini, x + 1, HEIGHT - 10 - 1, 'center', 'middle'
        .printAligned @continue, font.mini, WIDTH - 5, HEIGHT - 10, 'right', 'middle'
      if @back
        .setColor 166, 65, 77, 255
        .circle 'fill', 10, HEIGHT - 10, 8, 100
        .setColor color.white
        .printAligned 'B', font.mini, 10 + 1, HEIGHT - 10 - 1, 'center', 'middle'
        .printAligned @back, font.mini, 25, HEIGHT - 10, 'left', 'middle'
