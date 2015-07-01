export class LevelData
  new: (@levelNum, filename) =>
    @unlocked = false
    @goalTime = {}
    @map =
      fish: {}
      jellyfish: {}

    for line in love.filesystem.lines 'level/'..filename..'.oel'
      --get level info
      if line\find '<level'
        @map.width = tonumber line\match 'width="(.-)"'
        @map.height = tonumber line\match 'height="(.-)"'
        @goalTime[3] = tonumber line\match 'SilverTime="(.-)"'
        @goalTime[2] = tonumber line\match 'GoldTime="(.-)"'
        @goalTime[1] = tonumber line\match 'DiamondTime="(.-)"'

      --fish
      if line\find '<Fish'
        with @map.fish
          .x = tonumber line\match 'x="(.-)"'
          .y = tonumber line\match 'y="(.-)"'

      --jellyfish
      if line\find '<Jellyfish'
        jellyfish = {}
        with jellyfish
          .x     = tonumber line\match 'x="(.-)"'
          .y     = tonumber line\match 'y="(.-)"'
          .angle = tonumber line\match 'angle="(.-)"'
        table.insert @map.jellyfish, jellyfish

  addTime: (time) =>
    if not @best or time < @best
      @best = time
