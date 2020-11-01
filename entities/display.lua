local Display = {
  _width = 0,
  _height = 0,
  _xScale = 1,
  _yScale = 1
}

function Display.load()
	love.window.setMode(_width, _height, {fullscreen = true})
end

function Display.setDimensions(width, height)
  _width, _height = width, height
end

function Display.setWidth(width)
  _width = width
end

function Display.setHeight(height)
  _height = height
end

function Display.getWidth()
  return _width
end

function Display.getHeight()
  return _height
end

function Display.getXScale(width)
  _xScale = _width/width
  return _xScale
end

function Display.getYScale(height)
  _yScale = _height/height
  return _yScale
end

return Display
