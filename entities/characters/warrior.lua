local Player = require('entities.characters.player')

local Warrior = {}
Warrior.__index = Warrior

function Warrior.new()
  local instance = {
    _class = "Warrior",
    _width = 20,
    _height = 20,
    _xCoord = 50,
    _yCoord = 500,
    _yVelocity = 0,
    _xVelocity = 0,
    _xAccel = 10,
    _speed = 5,
    _gravity = -50,
    _jumpHeight = -12,
    _maxJumps = 2
  }
  setmetatable(instance, Warrior)
  return instance
end

setmetatable(Warrior, {__index = Player})

return Warrior
