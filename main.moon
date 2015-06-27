love.load =  ->
  export *

  gamestate = require 'lib.gamestate'
  timer = require 'lib.timer'
  flux = require 'lib.flux'
  bump = require 'lib.bump'

  require 'class.map'
  require 'class.map-object'

  require 'state.game'

  with gamestate
    .switch game
    .registerEvents!

love.keypressed = (key) ->
  if key == 'escape' then
    love.event.quit!
