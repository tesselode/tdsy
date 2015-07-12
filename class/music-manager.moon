export class MusicManager
  new: =>
    @timer = timer.new!
    @tween = flux.group!
    
    --load music
    with love.audio
      @music =
        title: {volume: 1, source: .newSource 'music/lazy.mp3'}
        gameplay1: {volume: 1, source: .newSource 'music/type a.mp3'}
        gameplay2: {volume: 1, source: .newSource 'music/type b.mp3'}
    for k, v in pairs @music
      v.source\setLooping true
    
  update: (dt) =>
    @timer.update dt
    @tween\update dt
    
    --set song volumes
    for k, v in pairs @music
      v.source\setVolume v.volume
  
  playSong: (nextSong, crossfadeTime) =>
    crossfadeTime = crossfadeTime or 0
    
    return false if nextSong == @current
    
    --fade out currently playing song
    for k, v in pairs @music
      if v.source\isPlaying!
        @tween\to v, crossfadeTime, {volume: 0}
        
    --fade in requested song
    @current = nextSong
    @timer.add crossfadeTime * .5, ->
      with @music[nextSong]
        .volume = .5
        .source\stop!
        .source\play!
        @tween\to @music[nextSong], crossfadeTime * .5, {volume: 1}