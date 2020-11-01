Gamestate = require('libs.hump-master.gamestate')
Display = require('entities.display')

local Options = {}
local TEST_FONT, TXT_OPTIONS

function Options:init()
  TEST_FONT = love.graphics.newFont(36)
  TXT_OPTIONS = love.graphics.newText(TEST_FONT, 'Options')
end

function Options:enter()
  TXT_OPTIONS = love.graphics.newText(TEST_FONT, 'Options')
end

function Options:draw()
  love.graphics.draw(TXT_OPTIONS,
  Display.getWidth()/2,
  Display.getHeight()/2, 0, 1, 1,
  TXT_OPTIONS:getWidth()/2, TXT_OPTIONS:getHeight()/2)
end

function Options:leave()
  TXT_OPTIONS = nil
end

return Options
