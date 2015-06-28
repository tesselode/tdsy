export class PlayerInput
  new: (@fish) =>
    @firstFrame = true
    @enabled = true

  update: (dt) =>
    inputVector = vector!

    if @enabled and not @firstFrame
      --analog movement
      inputVector.x = input\getAxis 'horizontal'
      inputVector.y = input\getAxis 'vertical'

      --limit vector to a circle
      if inputVector\len! > 1
        inputVector\normalize_inplace!

    @fish.inputVector = inputVector

    --darting
    if @enabled and not @firstFrame and input\pressed('primary')
      @fish\dart!

    if @firstFrame
      @firstFrame = false
