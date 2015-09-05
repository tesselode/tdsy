export class HudSpeedrun
  new: (@state) =>
    @timer = timer.new!
    @tween = flux.group!

    --cosmetic stuff
    @goalDisplayY = 10
    @timerY       = -50
    @bgFadeAlpha  = 0
    @fadeAlpha    = 255
    @tween\to self, .15, {fadeAlpha: 0}

    beholder.group self, ->
      beholder.observe 'level start', ->
        @tween\to(self, .35, {goalDisplayY: -50})\ease 'linear'
        @tween\to(self, .35, {timerY: 10})\ease 'linear'

  update: (dt) =>
    @timer.update dt
    @tween\update dt

  destroy: =>
    beholder.stopObserving self

  draw: =>
    with love.graphics
      --draw fade out
      .setColor 0, 0, 0, @bgFadeAlpha
      .rectangle 'fill', 0, 0, WIDTH, HEIGHT

      .setColor color.white
      --.printAligned 'Best: ', font.mini, WIDTH / 2, @goalDisplayY, 'right', 'middle'
      --.printAligned string.format('%0.2f', @state.levelData.best), font.time, WIDTH / 2, @goalDisplayY, 'left', 'middle'

      --draw time
      .setColor 255, 255, 255, 255
      .printAligned string.format('%0.1f', @state.time), font.time, WIDTH / 2, @timerY, 'center', 'middle'

      --draw fade out
      .setColor 0, 0, 0, @fadeAlpha
      .rectangle 'fill', 0, 0, WIDTH, HEIGHT
