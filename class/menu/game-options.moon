export class PracticeModeOption extends MenuOption
  new: =>
    @value = 1

  previous: => @value = math.wrap @value - 1, 1, 4
  next: => @value = math.wrap @value + 1, 1, 4

  draw: (x, y, selected) =>
    with love.graphics
      if selected
        .setColor @parent.highlightColor
      else
        .setColor @parent.color
      .printAligned 'Practice mode', @parent.font, 20, y, 'left', 'middle'
      if @value == 1
        .printAligned 'Off', @parent.font, WIDTH - 20, y, 'right', 'middle'
      elseif @value == 2
        .printAligned '0.9x', @parent.font, WIDTH - 20, y, 'right', 'middle'
      elseif @value == 3
        .printAligned '0.75x', @parent.font, WIDTH - 20, y, 'right', 'middle'
      elseif @value == 4
        .printAligned '0.5x', @parent.font, WIDTH - 20, y, 'right', 'middle'

export class MusicTypeOption extends MenuOption
  new: =>
    @value = saveManager.options.musicType or 1

  previous: =>
    @value = math.wrap @value - 1, 1, 3
    beholder.trigger 'set music type', @value

  next: =>
    @value = math.wrap @value + 1, 1, 3
    beholder.trigger 'set music type', @value

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

export class GameOptions
  new: =>
    @takeInput = true

    @menu = Menu font.mini, WIDTH * .5, HEIGHT * .5, color.gray, color.white
    @menu\addOption PracticeModeOption!
    @menu\addOption MusicTypeOption!
    @menu\addOption MenuOption 'Start!', ->
      @takeInput = false
      beholder.trigger 'go to game', @level
      beholder.trigger 'menu select'

    beholder.group self, ->
      beholder.observe 'go to game options', (level) ->
        @level = level

  update: (dt) =>
    --menu controls
    if @takeInput
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
        beholder.trigger 'go to level select'

  leave: =>
    beholder.stopObserving self

  draw: =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .printAligned 'Options', font.big, WIDTH / 2, HEIGHT * .2

    @menu\draw!
