export class SoundManager
  new: =>
    --load sounds
    @sound = {}
    for file in *love.filesystem.getDirectoryItems 'sound'
      if file\find '.wav'
        @sound[file\match('(.-).wav')] = love.audio.newSource 'sound/'..file
        
    beholder.group self, ->
      beholder.observe 'jellyfish bounced', ->
        pitch = 1
        with @sound.hit
          \setPitch pitch
          \play!
        with @sound.bounce
          \setPitch pitch
          \play!