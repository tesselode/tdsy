export game

game =
  enter: =>
    @map = Map!

    Level 'level1'

  update: (dt) =>
    @map\update dt

  draw: =>
    @map\draw!
