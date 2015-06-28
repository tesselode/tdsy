export class Level
  new: (@levelNum, levelName) =>
    @time = {}
    @fish = {}
    @jellyfish = {}

    for line in love.filesystem.lines 'level/'..levelName..'.oel'
      --get level info
      if line\find '<level'
        @width = tonumber line\match 'width="(.-)"'
        @height = tonumber line\match 'height="(.-)"'
        @time.silver = tonumber line\match 'SilverTime="(.-)"'
        @time.gold = tonumber line\match 'GoldTime="(.-)"'
        @time.diamond = tonumber line\match 'DiamondTime="(.-)"'

      --fish
      if line\find '<Fish'
        with @fish
          .x = tonumber line\match 'x="(.-)"'
          .y = tonumber line\match 'y="(.-)"'

      --jellyfish
      if line\find '<Jellyfish'
        jellyfish = {}
        with jellyfish
          .x     = tonumber line\match 'x="(.-)"'
          .y     = tonumber line\match 'y="(.-)"'
          .angle = tonumber line\match 'angle="(.-)"'
        table.insert @jellyfish, jellyfish
