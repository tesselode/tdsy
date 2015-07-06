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
  serialize = require 'lib.ser'
  require 'extra'

  --load classes
  require 'class.cosmetic.sprite'
  require 'class.cosmetic.camera'
  require 'class.cosmetic.background'
  require 'class.map-object'
  require 'class.physical.physical'
  require 'class.physical.border'
  require 'class.physical.jellyfish'
  require 'class.physical.fish'
  require 'class.ui.hud'
  require 'class.ui.level-button'
  require 'class.ui.menu'
  require 'class.level-data'
  require 'class.save-manager'
  require 'class.map'
  require 'class.player-input'

  --load states
  require 'state.game'
  require 'state.level-select'
  require 'state.pause'

  --load images
  image = {}
  for file in *love.filesystem.getDirectoryItems 'image'
    if file\find '.png'
      image[file\match('(.-).png')] = love.graphics.newImage 'image/'..file

  --load fonts
  font = {}
  with love.graphics
    font.mini    = .newFont 'font/Ernest.ttf', 20
    font.big     = .newFont 'font/Ernest.ttf', 40
    font.time    = .newFont 'font/kenpixel_blocks.ttf', 16
    font.timeBig = .newFont 'font/kenpixel_blocks.ttf', 32

	--reusable colors
  color = {}
  color.white = {252, 255, 254, 255}
  color.rank = {}
  color.rank[1] = {132, 219, 252, 255}
  color.rank[2] = {242, 222, 112, 255}
  color.rank[3] = {200, 107, 54, 255}
  color.rank[4] = {150, 150, 150, 255}

  --load levels
  levelData = {}
  for i = 1, NUMLEVELS
    if love.filesystem.exists 'level/level'..i..'.oel'
      print i
      levelData[i] = LevelData i, 'level'..i

  saveManager = SaveManager!

  control = {}
  with control
    --keyboard input
    .keyboardLeft   = input.addKeyboardButtonDetector 'left'
    .keyboardRight  = input.addKeyboardButtonDetector 'right'
    .keyboardUp     = input.addKeyboardButtonDetector 'up'
    .keyboardDown   = input.addKeyboardButtonDetector 'down'
    .keyboardX      = input.addKeyboardButtonDetector 'x'
    .keyboardZ      = input.addKeyboardButtonDetector 'z'
    .keyboardEscape = input.addKeyboardButtonDetector 'escape'
    .keyboardXAxis  = input.addBinaryAxisDetector .keyboardLeft, .keyboardRight
    .keyboardYAxis  = input.addBinaryAxisDetector .keyboardUp, .keyboardDown

    --gamepad input
    .gamepadA       = input.addGamepadButtonDetector 'a', 1
    .gamepadB       = input.addGamepadButtonDetector 'b', 1
    .gamepadStart   = input.addGamepadButtonDetector 'start', 1
    .gamepadLeft    = input.addAxisButtonDetector 'leftx', -.5, 1
    .gamepadRight   = input.addAxisButtonDetector 'leftx', .5, 1
    .gamepadDown    = input.addAxisButtonDetector 'lefty', .5, 1
    .gamepadUp      = input.addAxisButtonDetector 'lefty', -.5, 1
    .gamepadLeftX   = input.addAnalogAxisDetector 'leftx', 1
    .gamepadLeftY   = input.addAnalogAxisDetector 'lefty', 1

    --controls
    .left           = input.addButton .keyboardLeft, .gamepadLeft
    .right          = input.addButton .keyboardRight, .gamepadRight
    .down           = input.addButton .keyboardDown, .gamepadDown
    .up             = input.addButton .keyboardUp, .gamepadUp
    .primary        = input.addButton .keyboardX, .gamepadA
    .secondary      = input.addButton .keyboardZ, .gamepadB
    .pause          = input.addButton .keyboardEscape, .gamepadStart
    .horizontal     = input.addAxis .gamepadLeftX, .keyboardXAxis
    .vertical       = input.addAxis .gamepadLeftY, .keyboardYAxis
    .movement       = input.addAxisPair {.gamepadLeftX, .gamepadLeftY}, {.keyboardXAxis, .keyboardYAxis}

  with gamestate
    .switch levelSelect
    .registerEvents!

love.update = (dt) ->
  input.update!
