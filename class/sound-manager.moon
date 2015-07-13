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
        with @sound['bounce'..@bounceSound]
          \play!
        @bounceSound += 1 if @bounceSound < 7
          
      beholder.observe 'fish darted', ->
        with @sound.dart
          \setPitch .9 + love.math.random(1, 5) * .05
          \play!
          
      beholder.observe 'level complete', (newBest) ->
        @timer.add .5, ->
          if newBest
            @sound.fanfareBig\play!
          else
            @sound.fanfareSmall\play!
          
  update: (dt) =>
    @timer.update dt