export class LevelButton
  new: (@level, @x, @y) =>

  draw: =>
    with love.graphics
      .setColor 255, 255, 255, 255
      if @level and @level\getBestRank! == 1 then
        .draw image.buttonDiamond, @x, @y
      elseif @level and @level\getBestRank! == 2 then
        .draw image.buttonGold, @x, @y
      elseif @level and @level\getBestRank! == 3 then
        .draw image.buttonBronze, @x, @y
      else
        .draw image.button, @x, @y

      if @level and @level.unlocked then
        .setColor color.white
        .printAligned @level.levelNum, font.mini, @x + 17, @y + 16, 'center', 'middle'
      else
        .setColor 255, 255, 255, 255
        .draw image.lock, @x + 8, @y + 8
