export DEBUG = true
export WIDTH = 256
export HEIGHT = 224

love.conf = (t) ->
  with t.window
    .width  = WIDTH * 3
    .height = HEIGHT * 3
  t.console = true
