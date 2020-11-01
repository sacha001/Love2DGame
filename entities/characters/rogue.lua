local Player = require('entities.characters.player')

local Rogue = {}
Rogue.__index = Rogue

function Rogue.new()
  local instance = {
    _class = "Rogue",
    _width = 20,
    _height = 20,
    _xCoord = 50,
    _yCoord = 500,
    _yVelocity = 0,
    _xVelocity = 0,
    _speed = 5,
    _gravity = -50,
    _jumpHeight = -12,
    _numJumps = 0,
    _maxJumps = 2,
    _jumpReady = true
  }
  setmetatable(instance, Rogue)
  return instance
end

setmetatable(Rogue, {__index = Player})

return Rogue
