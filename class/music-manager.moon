export class MusicManager
  new: =>
    with love.audio
      @music =
        title: .newSource 'music/RoccoW - Lady Bad Luck.mp3'
    for song in *@music
      song\setLooping true
        
  playSong: (song) =>
    --stop other music
    for k, v in pairs @music
      if v ~= @music[song]
        v\stop!
    
    --play music if not already playing
    if not @music[song]\isPlaying!
      @music[song]\play!