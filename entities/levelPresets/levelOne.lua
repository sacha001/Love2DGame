Level = require("entities.levelPresets.level")

local LevelOne = {}
LevelOne.__index = LevelOne

function LevelOne.new(dispHeight, dispWidth)
  local instance = {
    {
      _next = {
        _size = 0
      },
      _floors = {
        {
          _x = 0,
          _y = dispHeight - (dispHeight * 0.05),
          _w = dispWidth * 0.3,
          _h = dispHeight * 0.05,
          _type = "floor"
        },
        {
          _x = dispWidth - (dispWidth * 0.5),
          _y = dispHeight - (dispHeight * 0.05),
          _w = dispWidth * 0.5,
          _h = dispHeight * 0.05,
          _type = "floor"
        },
        {
          _x = dispWidth - (dispWidth * 0.65),
          _y = dispHeight - (dispHeight * 0.2),
          _w = dispWidth * 0.08,
          _h = dispHeight * 0.02,
          _type = "floor"
        },
        {
          _x = dispWidth - (dispWidth * 0.8),
          _y = dispHeight - (dispHeight * 0.35),
          _w = dispWidth * 0.08,
          _h = dispHeight * 0.02,
          _type = "floor"
        },
        {
          _x = dispWidth - (dispWidth * 0.5),
          _y = dispHeight - (dispHeight * 0.35),
          _w = dispWidth * 0.08,
          _h = dispHeight * 0.02,
          _type = "floor"
        },
        {
          _x = dispWidth - (dispWidth * 0.25),
          _y = dispHeight - (dispHeight * 0.43),
          _w = dispWidth * 0.08,
          _h = dispHeight * 0.02,
          _type = "floor"
        }
      },
      _walls = {
        {
          _x = 0,
          _y = 0,
          _w = dispWidth * 0.03,
          _h = dispHeight,
          _type = "wall"
        },
        {
          _x = dispWidth - (dispWidth * 0.03),
          _y = dispHeight - (dispHeight * 0.5),
          _w = dispWidth * 0.03,
          _h = dispHeight * 0.5,
          _type = "wall"
        }
    }
  }
}

  setmetatable(instance, LevelOne)
  return instance
end

function LevelOne:getTile(index)
  --Return tile set at index
  return self[index]
end

setmetatable(LevelOne, {__index = Level})
return LevelOne
