local Player = require('entities.characters.player')

local Mage = {}
Mage.__index = Mage
function Mage.new(x, y, controller, leftKey, rightKey, jumpKey, attackKey, joystick1)
  local instance = {
    _class = "Mage",
    _width = 20,
    _height = 20,
    _yVelocity = 0,
    _xVelocity = 0,
    _xAccel = 10,
    _speed = 5,
    _gravity = -50,
    _jumpHeight = -12,
    _numJumps = 0,
    _maxJumps = 2,
    _jumpReady = true,
    _fireBallDelay = 1,
    _fireBalls = {},
    _fireBallSpeed = 500,
    _xCoord = x,
    _yCoord = y,
    _leftKey = leftKey,
    _rightKey = rightKey,
    _jumpKey = jumpKey,
    _attackKey = attackKey,
    _controller = controller,
    _joystick1 = joystick1,
    _timer = 0
  }
  setmetatable(instance, Mage)
  return instance
end


function Mage:attack(world)
  local x = self._xCoord + (self._width / 2) + (30 * self:getFacing())
  if (self._timer + self._fireBallDelay) < love.timer.getTime() then
    local fireBall = {x=x, y=self._yCoord, w=10, h=10, direction = self:getFacing()}
    self._fireBalls[#self._fireBalls + 1] = fireBall
    world:add(fireBall, x, self._yCoord, 10, 10)
    self._timer = love.timer.getTime()
  end
end

function Mage:updateFireBalls(dt, world, level)
  local i = 1
  for _, fireBall in ipairs(self._fireBalls) do
    local x, y, cols, cols_len = world:move(fireBall, fireBall.x + self._fireBallSpeed * dt * fireBall.direction, fireBall.y)
    fireBall.x = x
    fireBall.y = y

    if cols_len > 0 then
      for _, col in ipairs(cols) do
        for _, player in ipairs(level:getPlayers()) do
          if col.other == player then
            player:kill(world)
            player:spawn(world, 50, 500)
          end
        end
      end
      self:removeFireBall(i, world)
    end
    i = i + 1
  end
end

function Mage:getFireBalls()
  return self._fireBalls
end

function Mage:removeFireBall(index, world)
  world:remove(self._fireBalls[index])
  table.remove(self._fireBalls, index)
end

function Mage:drawFireBalls()
  for _, fireBall in ipairs(self._fireBalls) do
    love.graphics.setColor(255,69,0)
    love.graphics.rectangle("fill", fireBall.x, fireBall.y, fireBall.w, fireBall.h)
  end
end

setmetatable(Mage, {__index = Player})

return Mage
