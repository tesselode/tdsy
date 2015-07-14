export class VolumeSliderOption extends MenuOption
  new: =>
    @value = 5
    
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

export class Options
  new: =>
    @menu = Menu font.mini, WIDTH * .5, HEIGHT * .65, color.gray, color.white
    @menu\addOption VolumeSliderOption!
    @menu\addOption MenuOption 'Back', ->
      beholder.trigger 'go to title'
      
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
      beholder.trigger 'go to title'
        
  draw: =>
    @menu\draw!