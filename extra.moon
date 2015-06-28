love.graphics.printAligned = (text, font, x, y, hAlign, vAlign) ->
  hAlign = hAlign or 'center'
  vAlign = vAlign or 'top'

  love.graphics.setFont font

  if hAlign == 'left'
    x = x
  elseif hAlign == 'right'
    x = x - font\getWidth text
  elseif hAlign == 'center'
    x = x - font\getWidth(text) / 2

  if vAlign == 'top'
    y = y
  elseif vAlign == 'bottom'
    y = y - font\getHeight text
  elseif vAlign == 'middle'
    y = y - font\getHeight(text) / 2

  love.graphics.print text, x, y
