love.load =  ->
  with love.graphics
    .setDefaultFilter 'nearest', 'nearest'
    .setLineStyle 'rough'

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
  anim8     = require 'lib.anim8'
  slam      = require 'lib.slam'
  require 'extra'

  --load classes
  require 'class.map-object'
  require 'class.cosmetic.sprite'
  require 'class.cosmetic.camera'
  require 'class.cosmetic.background'
  require 'class.cosmetic.tiny-fish'
  require 'class.physical.physical'
  require 'class.physical.border'
  require 'class.physical.jellyfish'
  require 'class.physical.fish'
  require 'class.ui.hud'
  require 'class.ui.level-button'
  require 'class.ui.menu'
  require 'class.menu.level-select'
  require 'class.menu.title'
  require 'class.menu.options'
  require 'class.menu.game-options'
  require 'class.menu.button-display'
  require 'class.level-data'
  require 'class.save-manager'
  require 'class.map'
  require 'class.player-input'
  require 'class.music-manager'
  require 'class.sound-manager'

  --load states
  require 'state.menu'
  require 'state.game'
  require 'state.pause'
  require 'state.announcement'

  --load images
  image = {}
  for file in *love.filesystem.getDirectoryItems 'image'
    if file\find '.png'
      image[file\match('(.-).png')] = love.graphics.newImage 'image/'..file

  --load fonts
  font = {}
  with love.graphics
    font.tiny    = .newImageFont 'font/buchTiny.png', ' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!?,.#'
    font.mini    = .newImageFont 'font/buchSmall.png', ' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!?,.#'
    font.big     = .newImageFont 'font/buchBig.png', ' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!?,.#'
    font.time    = .newFont 'font/kenpixel_blocks.ttf', 16
    font.timeBig = .newFont 'font/kenpixel_blocks.ttf', 32

	--reusable colors
  color = {}
  color.white = {252, 255, 254, 255}
  color.gray = {150, 150, 150, 255}
  color.black = {8, 0, 8, 255}
  color.red = {166, 65, 77, 255}
  color.darkBlue = {68, 80, 140, 255}
  color.rank = {}
  color.rank[1] = {132, 219, 252, 255}
  color.rank[2] = {242, 222, 112, 255}
  color.rank[3] = {200, 107, 54, 255}
  color.rank[4] = {150, 150, 150, 255}

  --load levels
  levelData = {}
  for i = 1, NUMLEVELS
    if love.filesystem.exists 'level/level'..i..'.oel'
      levelData[i] = LevelData i, 'level'..i

  control = {}
  with control
    --keyboard input
    .keyboardLeft      = input.addKeyboardButtonDetector 'left'
    .keyboardRight     = input.addKeyboardButtonDetector 'right'
    .keyboardUp        = input.addKeyboardButtonDetector 'up'
    .keyboardDown      = input.addKeyboardButtonDetector 'down'
    .keyboardX         = input.addKeyboardButtonDetector 'x'
    .keyboardZ         = input.addKeyboardButtonDetector 'z'
    .keyboardEscape    = input.addKeyboardButtonDetector 'escape'
    .keyboardR         = input.addKeyboardButtonDetector 'r'
    .keyboardXAxis     = input.addBinaryAxisDetector .keyboardLeft, .keyboardRight
    .keyboardYAxis     = input.addBinaryAxisDetector .keyboardUp, .keyboardDown

    --gamepad input
    .gamepadStickLeft  = input.addAxisButtonDetector 'leftx', -.5, 1
    .gamepadStickRight = input.addAxisButtonDetector 'leftx', .5, 1
    .gamepadStickUp    = input.addAxisButtonDetector 'lefty', -.5, 1
    .gamepadStickDown  = input.addAxisButtonDetector 'lefty', .5, 1
    .gamepadDPadLeft   = input.addGamepadButtonDetector 'dpleft', 1
    .gamepadDPadRight  = input.addGamepadButtonDetector 'dpright', 1
    .gamepadDPadUp     = input.addGamepadButtonDetector 'dpup', 1
    .gamepadDPadDown   = input.addGamepadButtonDetector 'dpdown', 1
    .gamepadA          = input.addGamepadButtonDetector 'a', 1
    .gamepadB          = input.addGamepadButtonDetector 'b', 1
    .gamepadStart      = input.addGamepadButtonDetector 'start', 1
    .gamepadBack       = input.addGamepadButtonDetector 'back', 1
    .gamepadAnalogX    = input.addAnalogAxisDetector 'leftx', 1
    .gamepadAnalogY    = input.addAnalogAxisDetector 'lefty', 1
    .gamepadDigitalX   = input.addBinaryAxisDetector .gamepadDPadLeft, .gamepadDPadRight
    .gamepadDigitalY   = input.addBinaryAxisDetector .gamepadDPadUp, .gamepadDPadDown

    --controls
    .left              = input.addButton .keyboardLeft, .gamepadStickLeft, .gamepadDPadLeft
    .right             = input.addButton .keyboardRight, .gamepadStickRight, .gamepadDPadRight
    .up                = input.addButton .keyboardUp, .gamepadStickUp, .gamepadDPadUp
    .down              = input.addButton .keyboardDown, .gamepadStickDown, .gamepadDPadDown
    .primary           = input.addButton .keyboardX, .gamepadA
    .secondary         = input.addButton .keyboardZ, .gamepadB
    .pause             = input.addButton .keyboardEscape, .gamepadStart
    .restart           = input.addButton .keyboardR, .gamepadBack
    .movement          = input.addAxisPair {.gamepadAnalogX, .gamepadAnalogY}, {.gamepadDigitalX, .gamepadDigitalY}, {.keyboardXAxis, .keyboardYAxis}

  musicManager = MusicManager!
  soundManager = SoundManager!
  saveManager = SaveManager!

  gameSpeed = 1

  with gamestate
    .switch announcement, ->
      .switch menu
    .registerEvents!

love.update = (dt) ->
  input.getJoysticks!
  input.update!
  musicManager\update dt
  soundManager\update dt
