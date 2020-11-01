local Player = require('entities.characters.player')

local Archer = {}
Archer.__index = Archer

function Archer.new(x, y, controller, leftKey, rightKey, jumpKey, attackKey, joystick1)
  local instance = {
    _class = "Archer",
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
    _arrowDelay = 1,
    _arrows = {},
    _arrowSpeed = 500,
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
  setmetatable(instance, Archer)
  return instance
end

function Archer:attack(world)
  if (self._timer + self._arrowDelay) < love.timer.getTime() then
    local x = love.mouse.getX() - self._xCoord
    local y = love.mouse.getY() - self._yCoord
    local angle = tostring(math.atan2(y,x))
    local xVel = math.cos(angle)
    local yVel = math.sin(angle)

    local xStart

    if love.mouse.getX() > self._xCoord then
      xStart = self._xCoord + (self._width / 2) + 30
    else
      xStart = self._xCoord + (self._width / 2) - 30
    end

    local arrow = {x=xStart, y=self._yCoord, w=10, h=10, xVel = xVel, yVel = yVel}
    self._arrows[#self._arrows + 1] = arrow
    world:add(arrow, xStart, self._yCoord, 10, 10)
    self._timer = love.timer.getTime()
  end
end

function Archer:updateArrows(dt, world, level)
  local i = 1
  for _, arrow in ipairs(self._arrows) do
    arrow.yVel = arrow.yVel + dt
    local x, y, cols, cols_len = world:move(arrow, arrow.x + (arrow.xVel * self._arrowSpeed * dt), arrow.y + (arrow.yVel * self._arrowSpeed * dt))
    arrow.x = x
    arrow.y = y

    if cols_len > 0 then
      for _, col in ipairs(cols) do
        for _, player in ipairs(level:getPlayers()) do
          if col.other == player then
            player:kill(world)
            player:spawn(world, 50, 500)
          end
        end
      end
      self:removeArrow(i, world)
    end
    i = i + 1
  end
end

function Archer:getArrows()
  return self._arrows
end

function Archer:removeArrow(index, world)
  world:remove(self._arrows[index])
  table.remove(self._arrows, index)
end

function Archer:drawArrows()
  for _, arrow in ipairs(self._arrows) do
    love.graphics.setColor(255,69,0)
    love.graphics.rectangle("fill", arrow.x, arrow.y, arrow.w, arrow.h)
  end
end

setmetatable(Archer, {__index = Player})

return Archer
