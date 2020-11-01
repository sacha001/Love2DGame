local Player = {
  _class = "Default",
  _width = nil,
  _height = nil,
  _xCoord = nil,
  _yCoord = nil,
  _yVelocity = nil,
  _xVelocity = nil,
  _xAccel = nil,
  _speed = nil,
  _gravity = nil,
  _jumpHeight = nil,
  _numJumps = nil,
  _maxJumps = nil,
  _jumpReady = true,
  _facing = 1,
  _leftKey = nil,
  _rightKey = nil,
  _jumpKey = nil,
  _attackKey = nil,
  _controller = false,
  _joystick1 = nil,
  _alive = true
}

Player.__index = Player

function Player:getXCoord()
  return self._xCoord
end

function Player:getWidth()
  return self._width
end

function Player:getHeight()
  return self._height
end

function Player:setXCoord(xCoord)
  self._xCoord = xCoord
end

function Player:getYCoord()
  return self._yCoord
end

function Player:setYCoord(yCoord)
  self._yCoord = yCoord
end

function Player:getGravity()
  return self._gravity
end

function Player:getJumpHeight()
  return self._jumpHeight
end

function Player:getSpeed()
  return self._speed
end

function Player:getClass()
  return self._class
end

function Player:canJump()
  if self._numJumps < self._maxJumps then
    return true
  else
    return false
  end
end

function Player:getYVelocity()
  return self._yVelocity
end

function Player:getXVelocity()
  return self._xVelocity
end

function Player:setXVelocity(newVelocity)
  self._xVelocity = newVelocity
end

function Player:setYVelocity(newVelocity)
  self._yVelocity = newVelocity
end

function Player:isJumpReady()
  return self._jumpReady
end

function Player:setJumpReady(jumpReady)
  self._jumpReady = jumpReady
end

function Player:updateYVelocity(dt)
  self._yVelocity = self._yVelocity - self._gravity * dt
end

function Player:updateXVelocity(dt, keyPressed)
  if keyPressed == 'd' then

    if self._xVelocity < 0 then
      self._xVelocity = 0
    end

    if self._xVelocity < self._speed then
      self._xVelocity = self._xVelocity + (self._xAccel * dt)
    else
      self._xVelocity = self._speed
    end

  elseif keyPressed == 'a' then

    if self._xVelocity > 0 then
    self._xVelocity = 0
    end

    if self._xVelocity > -self._speed then
      self._xVelocity = self._xVelocity - (self._xAccel * dt)
    else
      self._xVelocity = (-self._speed)
    end

  elseif keyPressed == 'nokey' then

    if self._xVelocity > 0 then
      self._xVelocity = self._xVelocity - (self._xAccel * dt)
      if self._xVelocity < 0 then
        self._xVelocity = 0
      end
    end

    if self._xVelocity < 0 then
      self._xVelocity = self._xVelocity + (self._xAccel * dt)
      if self._xVelocity > 0 then
        self._xVelocity = 0
      end
    end

  end
end

function Player:jump()
  self._numJumps = self._numJumps + 1


  self._yVelocity = self._jumpHeight
end

function Player:setFacing(facing)
  if facing == 'right' then
    self._facing = 1
  elseif facing == 'left' then
    self._facing = -1
  else
    self._facing = facing
  end
end

function Player:getFacing()
  return self._facing
end

function Player:isOnTopOfTile(tile)

  local tileX1 = tile._x
  local tileX2 = tile._x + tile._w
  local tileY = tile._y --only need one Y since it's a rectangle

  local playerX1 = self:getXCoord()
  local playerX2 = self:getXCoord() + self:getWidth()
  local playerY = self:getYCoord() + self:getHeight()

  return ( playerX2 > tileX1 and playerX1 < tileX2 and playerY == tileY )
end

function Player:getLeftKey()
  return self._leftKey
end

function Player:getRightKey()
  return self._rightKey
end

function Player:getJumpKey()
  return self._jumpKey
end

function Player:getAttackKey()
  return self._attackKey
end

function Player:usesController()
  return self._controller
end

function Player:isAlive()
  return self._alive
end

function Player:setAlive(alive)
  self._alive = alive
end

function Player:kill(world)
  world:remove(self)
  self:setAlive(false)
end

function Player:spawn(world, x, y)
  self:setXCoord(x)
  self:setYCoord(y)
  self:setYVelocity(-1) --ensures players spawn falling
  world:add(self,x, y, self:getWidth(), self:getHeight())
  self:setAlive(true)
end

function Player:update(dt, world)
  if self._alive then
    if (self._controller and self._joystick1 ~= nil and self._joystick1:getAxis(1) > 0.35)
     or love.keyboard.isDown(self._rightKey) then

      self:updateXVelocity(dt, 'd')
      self:setFacing('right')

    elseif (self._controller and self._joystick1 ~= nil and self._joystick1:getAxis(1) < 0.35)
     or love.keyboard.isDown(self._leftKey) then

      self:updateXVelocity(dt, 'a')
      self:setFacing('left')
    else
      self:updateXVelocity(dt, 'nokey')
    end

    if (self._controller and self._joystick1 ~= nil and self._joystick1:isGamepadDown('a')
     or love.keyboard.isDown(self._jumpKey)) and (self:canJump()) and (self:isJumpReady()) then

      self:jump()
      self._jumpReady = false
    end

    if (self._controller and self._joystick1 ~= nil and self._joystick1:isGamepadDown('x'))
     or love.keyboard.isDown(self._attackKey) then
       self:attack(world)
    end

    if self._xVelocity ~= 0  or self._yVelocity ~= 0 then

      local x, y, cols, cols_len = world:move(self, self._xCoord + self._xVelocity, self._yCoord + self._yVelocity)
      self._xCoord = x
      self._yCoord = y
      self:updateYVelocity(dt)
      for _, col in ipairs(cols) do
        if (col.other._type == "floor" or col.other._type == "wall") and self:isOnTopOfTile(col.other) then
          self._yVelocity = 0
          self._numJumps = 0
        end
      end
    end
  end
end

return Player
