export class Title
  new: =>
    @menu = Menu font.mini, WIDTH * .5, HEIGHT * .65, color.gray, color.white
    @menu\addOption MenuOption 'Play!', ->
      beholder.trigger 'go to level select'
    @menu\addOption MenuOption 'Quit', ->
      love.event.quit!
      
  update: (dt) =>
    --menu controls
    with @menu
      \previous! if control.up.pressed
      \next! if control.down.pressed
      if control.primary.pressed
        \select!
        beholder.trigger 'menu select'
        
  draw: =>
    with love.graphics
      --title
      .setFont font.big
      .printf "The Tops Don't Sting You!", 0, 30, WIDTH, 'center'
      
      --menu
      @menu\draw!