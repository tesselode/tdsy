export class LevelButton
  new: (@level, @x, @y) =>
    --detect if the gold rank has been achieved on levels 1-19
    @finalLevelRevealed = true
    for i = 1, NUMLEVELS - 1
      if levelData[i]\getBestRank! > 2
        @finalLevelRevealed = false

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
      
      --for the last level, don't show a locked symbol until gold has been achieved
      --on levels 1-20. this keeps things mysterious  
      if @level.levelNum == NUMLEVELS and not @finalLevelRevealed
        return false

      if @level and @level.unlocked then
        --draw level number if unlocked
        .setColor color.white
        .printAligned @level.levelNum, font.mini, @x + 17, @y + 16, 'center', 'middle'
      else
        --show locked symbol if not
        .setColor 255, 255, 255, 255
        .draw image.lock, @x + 8, @y + 8
