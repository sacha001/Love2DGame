-- requirements
Lovebird = require('.libs.lovebird-master.lovebird')
Gamestate = require('.libs.hump-master.gamestate')
Display = require('entities.display')

-- states
local TitleScreen = require('entities.titleScreen.titleScreen')
local TestLevel = require('entities.testLevel.testLevel')
local Options = require('entities.options.options')

function love.load()
	local _, _, flags = love.window.getMode()
	local width, height = love.window.getDesktopDimensions(flags.display)
	Display.setDimensions(width, height)
	Display.load()

	-- gamestate register
	Gamestate.registerEvents()
	Gamestate.switch(TitleScreen)
end

function love.update(dt)
	Lovebird.update()
end

function love.keypressed(key)
  if key == 'escape' then
		if Gamestate.current() ~= TitleScreen then
			Gamestate.switch(TitleScreen)
		else
			love.event.push('quit')
		end
	end
end

function love.draw()

end
