export class SoundManager
  new: =>
    @timer = timer.new!
    
    --load sounds
    @sound = {}
    for file in *love.filesystem.getDirectoryItems 'sound'
      if file\find '.wav'
        @sound[file\match('(.-).wav')] = love.audio.newSource 'sound/'..file
        
    @bounceSound = 1
        
    beholder.group self, ->
      beholder.observe 'level start', ->
        @bounceSound = 1
      
      beholder.observe 'jellyfish bounced', ->
        with @sound['bounce-0'..@bounceSound]
          \play!
        @bounceSound += 1 if @bounceSound < 7
          
      beholder.observe 'fish darted', ->
        with @sound.dart
          \setPitch .9 + love.math.random(1, 5) * .05
          \play!
          
      beholder.observe 'level complete', (newBest) ->
        @timer.add 0, ->
          if newBest
            @sound.fanfareBig\play!
          else
            @sound.fanfareSmall\play!
            
      beholder.observe 'menu navigate', ->
        @sound.menuBeep\play!
      beholder.observe 'menu select', ->
        @sound.menuSelect\play!
      beholder.observe 'menu back', ->
        @sound.menuBack\play!
        
      beholder.observe 'set sound balance', (value) ->
        local volume
        if value < 5
          volume = 1 - (5 - value) / 5
        else
          volume = 1
        print volume
          
        for k, v in pairs @sound
          v\setVolume volume
          
  update: (dt) =>
    @timer.update dt