love.load =  ->
  export *

  gamestate = require 'lib.gamestate'
  timer     = require 'lib.timer'
  flux      = require 'lib.flux'
  bump      = require 'lib.bump'
  vector    = require 'lib.vector'

  require 'class.level'
  require 'class.map'
  require 'class.map-object'
  require 'class.physical.physical'
  require 'class.physical.jellyfish'

  require 'state.game'

  with gamestate
    .switch game
    .registerEvents!

love.keypressed = (key) ->
  if key == 'escape' then
    love.event.quit!
