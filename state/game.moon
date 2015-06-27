export game

game =
  enter: =>
    @map = Map!

  update: (dt) =>
    @map\update dt

  draw: =>
    @map\draw!
