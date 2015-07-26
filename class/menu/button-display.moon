export class ButtonDisplay
  new: (@continue, @back) =>

  draw: =>
    with love.graphics
      if @continue
        --draw circle
        .setLineWidth 2
        .setColor color.white
        x = WIDTH - 5 - font.mini\getWidth(@continue) - 15
        .circle 'line', x, HEIGHT - 10, 8, 100
        .setColor 148, 204, 78, 255
        .circle 'fill', x, HEIGHT - 10, 8, 100

        --draw text
        .setColor color.white
        .printAligned 'A', font.mini, x + 1, HEIGHT - 10 - 1, 'center', 'middle'
        .printAligned @continue, font.mini, WIDTH - 5, HEIGHT - 10, 'right', 'middle'

      if @back
        --draw circle
        .setLineWidth 2
        .setColor color.white
        .circle 'line', 10, HEIGHT - 10, 8, 100
        .setColor 166, 65, 77, 255
        .circle 'fill', 10, HEIGHT - 10, 8, 100

        --draw text
        .setColor color.white
        .printAligned 'B', font.mini, 10 + 1, HEIGHT - 10 - 1, 'center', 'middle'
        .printAligned @back, font.mini, 25, HEIGHT - 10, 'left', 'middle'
