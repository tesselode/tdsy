export class VolumeSliderOption extends MenuOption
  new: =>
    @value = saveManager.options.soundBalance or 5

  previous: =>
    @value = lume.clamp @value - 1, 0, 10
    beholder.trigger 'set sound balance', @value

  next: =>
    @value = lume.clamp @value + 1, 0, 10
    beholder.trigger 'set sound balance', @value

  onSelect: =>

  draw: (x, y, selected) =>
    with love.graphics
      if selected
        .setColor @parent.highlightColor
      else
        .setColor @parent.color
      .printAligned 'Sound balance', @parent.font, 20, y, 'left', 'middle'

      .rectangle 'fill', WIDTH - 100, y - 1, 80, 2
      .rectangle 'fill', WIDTH - 100 + 80 * (@value / 10) - 1, y - 5, 2, 10

export class MusicTypeOption extends MenuOption
  new: =>
    @value = saveManager.options.musicType or 1

  previous: =>
    @value = math.wrap @value - 1, 1, 3
    beholder.trigger 'set music type', @value

  next: =>
    @value = math.wrap @value + 1, 1, 3
    beholder.trigger 'set music type', @value

  onSelect: =>

  draw: (x, y, selected) =>
    with love.graphics
      if selected
        .setColor @parent.highlightColor
      else
        .setColor @parent.color
      .printAligned 'Music', @parent.font, 20, y, 'left', 'middle'
      if @value == 1
        .printAligned 'Default', @parent.font, WIDTH - 20, y, 'right', 'middle'
      elseif @value == 2
        .printAligned 'Type A', @parent.font, WIDTH - 20, y, 'right', 'middle'
      elseif @value == 3
        .printAligned 'Type B', @parent.font, WIDTH - 20, y, 'right', 'middle'

export class ScreenSizeOption extends MenuOption
  new: =>
    @value = saveManager.options.screenSize or 1

  previous: =>
    @value = math.wrap @value - 1, 1, 5
    beholder.trigger 'set screen size', @value

  next: =>
    @value = math.wrap @value + 1, 1, 5
    beholder.trigger 'set screen size', @value

  onSelect: =>

  draw: (x, y, selected) =>
    with love.graphics
      if selected
        .setColor @parent.highlightColor
      else
        .setColor @parent.color
      .printAligned 'Screen size', @parent.font, 20, y, 'left', 'middle'
      if @value == 5
        .printAligned 'Full', @parent.font, WIDTH - 20, y, 'right', 'middle'
      else
        .printAligned @value..'X', @parent.font, WIDTH - 20, y, 'right', 'middle'

export class Options
  new: =>
    @menu = Menu font.mini, WIDTH * .5, HEIGHT * .5, color.gray, color.white
    @menu\addOption ScreenSizeOption!
    @menu\addOption VolumeSliderOption!
    @menu\addOption MusicTypeOption!
    @menu\addOption MenuOption 'Back', ->
      beholder.trigger 'go to title'

    @buttonDisplay = ButtonDisplay 'Select', 'Back'

  update: (dt) =>
    --menu controls
    with @menu
      \previous! if control.up.pressed
      \next! if control.down.pressed
      \secondaryPrevious! if control.left.pressed
      \secondaryNext! if control.right.pressed
      if control.primary.pressed
        \select!
        beholder.trigger 'menu select'

    if control.secondary.pressed
      beholder.trigger 'menu back'
      beholder.trigger 'go to title'

  draw: =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .printAligned 'Options', font.big, WIDTH / 2, HEIGHT * .2

    @menu\draw!
    @buttonDisplay\draw!
