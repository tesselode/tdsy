export class PlayerInput
  new: (@fish) =>
    @firstFrame = true
    @enabled = true

  update: (dt) =>
    inputVector = vector!

    if @enabled and not @firstFrame
      --analog movement
      inputVector.x = control.movement.x
      inputVector.y = control.movement.y

    @fish.inputVector = inputVector

    --darting
    if @enabled and not @firstFrame and control.primary.pressed
      @fish\dart!

    if @firstFrame
      @firstFrame = false
