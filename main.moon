love.load =  ->
  love.graphics.setDefaultFilter 'nearest', 'nearest'

  export *

  --load libraries
  gamestate = require 'lib.gamestate'
  timer     = require 'lib.timer'
  flux      = require 'lib.flux'
  bump      = require 'lib.bump'
  vector    = require 'lib.vector'
  lume      = require 'lib.lume'

  --load images
  image = {}
  for file in *love.filesystem.getDirectoryItems 'image'
    if file\find '.png'
      image[file\match('(.-).png')] = love.graphics.newImage 'image/'..file


  --load classes
  require 'class.level'
  require 'class.map'
  require 'class.map-object'
  require 'class.cosmetic.sprite'
  require 'class.physical.physical'
  require 'class.physical.jellyfish'

  require 'state.game'

  --load levels
  level = {}
  for i = 1, 16
    level[i] = Level 'level'..i

  with gamestate
    .switch game
    .registerEvents!

love.keypressed = (key) ->
  if key == 'escape' then
    love.event.quit!
