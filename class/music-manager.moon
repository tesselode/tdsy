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

    @masterMusicVolume = .65
    @userMusicVolume = 1

    beholder.group self, ->
      beholder.observe 'set sound balance', (value) ->
        if value > 5
          @userMusicVolume = 1 - (value - 5) / 5
        else
          @userMusicVolume = 1

      beholder.observe 'level complete', (newBest, newDiamond) ->
        if false and newDiamond then
          @current.volume = 0
          @timer.add 3, ->
            @tween\to @current, 1, {volume: 1}

  update: (dt) =>
    @timer.update dt
    @tween\update dt

    --set song volumes
    for k, v in pairs @music
      v.source\setVolume v.volume * @userMusicVolume * @masterMusicVolume

  playSong: (nextSong, crossfadeTime) =>
    crossfadeTime = crossfadeTime or 0

    return false if @music[nextSong] == @current

    --fade out currently playing song
    if @current
      @tween\to @current, crossfadeTime, {volume: 0}

    --fade in requested song
    @current = @music[nextSong]
    @timer.add crossfadeTime * .5, ->
      with @current
        .volume = .5
        .source\stop!
        .source\play!
        @tween\to @current, crossfadeTime * .5, {volume: 1}

  stopMusic: =>
    if @current
      @current.source\stop!
      @current = nil
