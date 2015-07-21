export DEBUG = false
export WIDTH = 256
export HEIGHT = 224
export NUMLEVELS = 20

love.conf = (t) ->
  with t.window
    .fullscreentype = 'desktop'
    .title          = "The Tops Don't Sting You!"
  t.version  = "0.9.2"
  t.identity = "The Tops Don't Sting You!"
