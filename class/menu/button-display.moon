export class ButtonDisplay
  new: (@continue, @back) =>

  draw: =>
    with love.graphics
      if @continue
        if input.joysticks[1]
          --draw button
          .setLineWidth 2
          .setColor color.white
          x = WIDTH - 5 - font.mini\getWidth(@continue) - 15
          .circle 'line', x, HEIGHT - 10, 8, 100
          .setColor 148, 204, 78, 255
          .circle 'fill', x, HEIGHT - 10, 8, 100
          .setColor color.white
          .printAligned 'A', font.mini, x + 1, HEIGHT - 10, 'center', 'middle'
        else
          --draw key
          .setLineWidth 2
          .setColor color.white
          x = WIDTH - 5 - font.mini\getWidth(@continue) - 15
          .rectangle 'line', x - 8, HEIGHT - 10 - 8, 16, 16
          .setColor 94, 102, 96, 255
          .rectangle 'fill', x - 8, HEIGHT - 10 - 8, 16, 16
          .setColor color.white
          .printAligned 'X', font.mini, x + 1, HEIGHT - 10, 'center', 'middle'

        --draw text
        .setColor color.white
        .printAligned @continue, font.mini, WIDTH - 5, HEIGHT - 10, 'right', 'middle'

      if @back
        if input.joysticks[1]
          --draw button
          .setLineWidth 2
          .setColor color.white
          .circle 'line', 13, HEIGHT - 10, 8, 100
          .setColor 166, 65, 77, 255
          .circle 'fill', 13, HEIGHT - 10, 8, 100
          .setColor color.white
          .printAligned 'B', font.mini, 13 + 1, HEIGHT - 10, 'center', 'middle'
        else
          --draw key
          .setLineWidth 2
          .setColor color.white
          .rectangle 'line', 13 - 8, HEIGHT - 10 - 8, 16, 16
          .setColor 94, 102, 96, 255
          .rectangle 'fill', 13 - 8, HEIGHT - 10 - 8, 16, 16
          .setColor color.white
          .printAligned 'Z', font.mini, 13 + 1, HEIGHT - 10, 'center', 'middle'

        --draw text
        .setColor color.white
        .printAligned @back, font.mini, 28, HEIGHT - 10, 'left', 'middle'
