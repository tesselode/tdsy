export class LevelButton
  new: (@level, @x, @y) =>

  draw: =>
    with love.graphics
      best = saveManager.data.level[@level.levelNum].best
      local rank
      if best
        rank = @level\getRank best

      .setColor 255, 255, 255, 255
      if rank == 1 then
        .draw image.buttonDiamond, @x, @y
      elseif rank == 2 then
        .draw image.buttonGold, @x, @y
      elseif rank == 3 then
        .draw image.buttonBronze, @x, @y
      else
        .draw image.button, @x, @y

      .setColor color.white
      .printAligned @level.levelNum, font.mini, @x + 17, @y + 16, 'center', 'middle'
