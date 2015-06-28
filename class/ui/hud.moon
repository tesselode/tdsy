export class Hud
  new: (@state) =>

  draw: =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .printAligned string.format('%0.1f', @state.time), font.time, WIDTH / 2, 0
