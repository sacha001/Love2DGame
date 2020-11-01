local Level  = {
  _players = {},
  _blocks = {},
  _floors = {},
  _walls = {}
}

Level.__index = Level

function Level.new()
  local instance = {

  }

  setmetatable(instance, Level)
  return instance
end

function Level:getPlayers()
  return self._players
end

function Level:addPlayer(world, player)
  self._players[#self._players + 1] = player
  player:spawn(world, player:getXCoord(), player:getYCoord())
end

function Level:drawPlayers()
  for _,player in ipairs(self._players) do
    if(player:isAlive()) then
      if player:getClass() == "Mage" then
        player:drawFireBalls()
      elseif player:getClass() == "Archer" then
        player:drawArrows()
      end

      love.graphics.setColor(0,255,0)
      love.graphics.rectangle("fill", player:getXCoord(), player:getYCoord(), player:getWidth(), player:getHeight())
    end
  end
end

function Level:drawBlocks()
  for _,block in ipairs(self._blocks) do
    love.graphics.setColor(255,0,0)
    love.graphics.rectangle("fill", block._x, block._y, block._w, block._h)
  end
end

function Level:build(world)
  for _, tile in ipairs(self) do
    for _, floor in ipairs(tile._floors) do
      self._blocks[#self._blocks + 1] = floor
      world:add(floor, floor._x, floor._y, floor._w, floor._h)
    end

    for _, wall in ipairs(tile._walls) do
      self._blocks[#self._blocks + 1] = wall
      world:add(wall, wall._x, wall._y, wall._w, wall._h)
    end
  end
end

function Level:keyReleased(key)
  for _, player in ipairs(self._players) do
    if key == player:getJumpKey() then
      player:setJumpReady(true)
    end
  end
end

function Level:gamepadreleased(joystick, button)
  for _, player in ipairs(self._players) do
    if button == 'a' and player:usesController() then
      player:setJumpReady(true)
    end
  end
end

function Level:updatePlayers(dt, world)
  for _, player in ipairs(self._players) do
    if player:getClass() == "Mage" then
      player:updateFireBalls(dt, world, self)
    elseif player:getClass() ==  "Archer" then
      player:updateArrows(dt, world, self);
    end
    player:update(dt, world)
  end
end

return Level
