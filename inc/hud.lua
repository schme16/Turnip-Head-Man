hud = {}

function hud:draw()
	hud:style()
	hud:timer()
	hud:score()
end

function hud:style()
	local barWidth = 200
	local barVal = player.style
	local barHeight = 25
	local barX = ((love.graphics.getWidth() - barWidth) - 10)
	local barY = 9
	
	r,g,b,a = love.graphics.getColor()

	love.graphics.setColor(15,123,200,50)
	love.graphics.rectangle('fill', barX, barY, barVal, barHeight )
	love.graphics.setColor(15,123,200,160)
	love.graphics.rectangle('line', barX, barY, 200, barHeight )
	love.graphics.setColor(r,g,b,a)
	advPrint('Style: '..tostring(player.style), barX+40,0,{0,0,0})
end

function hud:timer()
	advPrint('Time: '..tostring(game.timer), (love.graphics.getWidth()/2)-(6*15),0,{0,0,0})
end

function hud:score()
	advPrint('Score: '..tostring(player.score), 10,0,{0,0,0})
end