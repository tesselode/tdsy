export class Title
  new: =>
    @menu = Menu font.mini, WIDTH * .5, HEIGHT * .7, color.gray, color.white
    @menu\addOption MenuOption 'Play!', ->
      beholder.trigger 'go to level select'
    @menu\addOption MenuOption 'Options', ->
      beholder.trigger 'go to options'
    @menu\addOption MenuOption 'Quit', ->
      love.event.quit!
      
    @uptime = 0
      
  update: (dt) =>
    @uptime += dt
    
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
      .draw image.title, WIDTH * .5, HEIGHT * .5 + math.sin(@uptime * 2) * 2, 0, 1, 1, image.title\getWidth! / 2, image.title\getHeight!
      
      --menu
      @menu\draw!