export class ButtonDisplay
  new: (@continue, @back) =>

  draw: =>
    with love.graphics
      if @continue
        .setColor 82, 144, 60, 255
        .circle 'fill', WIDTH - 40, HEIGHT - 10, 8, 100
        .setColor color.white
        .printAligned 'A', font.mini, WIDTH - 40 + 1, HEIGHT - 10 - 1, 'center', 'middle'
        .printAligned 'Go!', font.mini, WIDTH - 5, HEIGHT - 10, 'right', 'middle'
      if @back
        .setColor 166, 65, 77, 255
        .circle 'fill', 10, HEIGHT - 10, 8, 100
        .setColor color.white
        .printAligned 'B', font.mini, 10 + 1, HEIGHT - 10 - 1, 'center', 'middle'
        .printAligned 'Back', font.mini, 25, HEIGHT - 10, 'left', 'middle'
