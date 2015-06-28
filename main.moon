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
  beholder  = require 'lib.beholder'
  input     = require 'lib.tactile'
  require 'extra'

  with input
    --keyboard input
    \addKeyboardButtonDetector 'keyboardLeft', 'left'
    \addKeyboardButtonDetector 'keyboardRight', 'right'
    \addKeyboardButtonDetector 'keyboardUp', 'up'
    \addKeyboardButtonDetector 'keyboardDown', 'down'
    \addKeyboardButtonDetector 'keyboardX', 'x'
    \addKeyboardButtonDetector 'keyboardZ', 'z'
    \addKeyboardButtonDetector 'keyboardReturn', 'return'
    \addKeyboardButtonDetector 'keyboardEscape', 'escape'
    \addBinaryAxisDetector 'keyboardXAxis', 'keyboardLeft', 'keyboardRight'
    \addBinaryAxisDetector 'keyboardYAxis', 'keyboardUp', 'keyboardDown'

    --gamepad input
    \addGamepadButtonDetector 'gamepadA', 'a', 1
    \addGamepadButtonDetector 'gamepadB', 'b', 1
    \addGamepadButtonDetector 'gamepadStart', 'start', 1
    \addAxisButtonDetector 'gamepadLeft', 'leftx', -.5, 1
    \addAxisButtonDetector 'gamepadRight', 'leftx', .5, 1
    \addAxisButtonDetector 'gamepadDown', 'lefty', .5, 1
    \addAxisButtonDetector 'gamepadUp', 'lefty', -.5, 1
    \addAnalogAxisDetector 'gamepadLeftX', 'leftx', 1
    \addAnalogAxisDetector 'gamepadLeftY', 'lefty', 1

    --controls
    \addButton 'left', {'keyboardLeft', 'gamepadLeft'}
    \addButton 'right', {'keyboardRight', 'gamepadRight'}
    \addButton 'down', {'keyboardDown', 'gamepadDown'}
    \addButton 'up', {'keyboardUp', 'gamepadUp'}
    \addButton 'primary', {'keyboardX', 'gamepadA'}
    \addButton 'secondary', {'keyboardZ', 'gamepadB'}
    \addButton 'pause', {'keyboardEscape', 'gamepadStart'}
    \addAxis 'horizontal', {'keyboardXAxis', 'gamepadLeftX'}
    \addAxis 'vertical', {'keyboardYAxis', 'gamepadLeftY'}

  --load images
  image = {}
  for file in *love.filesystem.getDirectoryItems 'image'
    if file\find '.png'
      image[file\match('(.-).png')] = love.graphics.newImage 'image/'..file

  --load fonts
  font = {}
  with love.graphics
  	font.time    = .newFont 'font/kenpixel_blocks.ttf', 16
  	font.timeBig = .newFont 'font/kenpixel_blocks.ttf', 32

	--reusable colors
  color = {}
  color.rank = {}
  color.rank[1] = {129, 213, 240, 255}
  color.rank[2] = {222, 215, 123, 255}
  color.rank[3] = {201, 201, 201, 255}
  color.rank[4] = {150, 150, 150, 255}

  --load classes
  require 'class.level'
  require 'class.map'
  require 'class.map-object'
  require 'class.cosmetic.sprite'
  require 'class.cosmetic.camera'
  require 'class.cosmetic.background'
  require 'class.physical.physical'
  require 'class.physical.border'
  require 'class.physical.jellyfish'
  require 'class.physical.fish'
  require 'class.ui.hud'
  require 'class.player-input'

  require 'state.game'

  --load levels
  level = {}
  for i = 1, 16
    level[i] = Level 'level'..i

  with gamestate
    .switch game
    .registerEvents!

love.update = (dt) ->
  input\update!

love.keypressed = (key) ->
  if key == 'escape' then
    love.event.quit!
