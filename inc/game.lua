



--local bound = {right = love.graphics.newImage('img/player/right/walkingBounding.png'), left = love.graphics.newImage('img/player/left/walkingBounding.png')}
game = {state = 'newGame', maxTime = 60, }

backgrounds = {}




---------------------------------------------------------------------------------------------------------
------------------------------------------Game Functions-----------------------------------------------
---------------------------------------------------------------------------------------------------------

function game:run() --calls the game state 
	if game.state == 'running' then 
		if cam then
			cam:draw(function() if game then game:draw() end end)
		end
	end
	game[game.state]()
end

function game:running(paused) --is run when the game is `running`
	--if not paused then
		game.timer = game.maxTime - (os.time()-time)	
		game:gravity(player)
		for i,v in ipairs(items) do
			game:gravity(v)
		end
		if player.style > player.maxStyle then player.style = player.maxStyle end
		if game.timer < 1 then game.state = 'playerDeath' game.timer = 0 end
		
		cam:setPos(vector( player.getX(),(love.graphics.getHeight()/2)))
		
--	end 
	
	--there is a bug in the timer where even when paused it will count down, I'll fix this a little later
	
	
	hud:draw()

end


function game:draw()
		player:update()
		item:update()
	game:backgrounds()
end

function game:backgrounds()
	--paralaxingBG()
	love.graphics.draw(backgrounds[2].image,backgrounds[2].x ,0)
	player:draw()
	

	r,g,b,a = love.graphics.getColor()

	love.graphics.setColor(r,g,b,160)
	love.graphics.draw(backgrounds[1].image,backgrounds[1].x,0)
	love.graphics.setColorMode( 'modulate' )
	love.graphics.setColor(r,g,b,a)
	
	
	love.graphics.draw(backgrounds[3].image,backgrounds[3].x,0)
	love.graphics.draw(backgrounds[4].image, backgrounds[4].x, 0)
end

function game:start() --called when you start a game
	
end

function game:newGame() --called when you start a NEW game
	player.left = newImageAnimation('img/player/left/', 0.08, 9)
	player.right =  newImageAnimation('img/player/right/', 0.08, 9)
	game:buildMap()
	game.state = 'running'
	cam = Camera(vector(player.x, (love.graphics.getWidth()/2)))
	--int = game:buildItemsFromMap('img/maps/1/1/3.png', 'img/items/coinBlock/1.png')
end

function game:loadGame() --called when you start LOAD a game
	
end

function game:paused()
	game:running(true)
end

function game:buildMap()
		
	local temp = 'img/maps/'..player.world..'/'..player.stage..'/'
	backgrounds = {
		{colMap = false, image = love.graphics.newImage( temp..'1.gif'),x=0,y=0},
		{colMap = false, image = love.graphics.newImage( temp..'2.gif'),x=0,y=0},
		{colMap = collision:newCollisionMap(temp..'3.gif'),image = love.graphics.newImage( temp..'3.gif'),x=0,y=0},
		{colMap = collision:newCollisionMap(temp..'4.gif'),image = love.graphics.newImage( temp..'4.gif'),x=0,y=0},

	}

end

function game:buildItemsFromMap(item,map )
	
	

	
	local X,Y = intersection2(collision:newRGBMap(map), collision:newRGBMap(item))
	
	local newTable = {}
	
	X = table.sort(X)

	for i = 1, #X do
		newTable[i] = {x = X[i], y =Y[X[i]]}
		i = i +15
	end
	
	

	return newTable

	
	
	
	--item:add(index, action, colMap)

end

function table.sort(tableVal)
	local t = {}
	--print(table.save(X))
	for i = 1, 99999 do
		if tableVal[i] then
			t[#t+1] = tableVal[i]
		end
	end	
	return t
end

function game:gravity(object)
	
	local findGround = false
	
	if object.isPlayer then --This only effects the player
		if object.isJumping < 1 then
			object.isJumping = 0
			local temp = object.y+game.determineSpeed(object.gravitySpeed)
			if not player:isColliding( false, temp ) then
				object.y = temp
			
			else
				game:findGround(object)
				object.falling = false
			end
			
			if player:isColliding(false,(object.y+1)) then
				object.falling = false
			end
		end
	
	else --This only effects items
	
	end
end

function game:findGround(object)
local y = 2
local xVal = 2
local x = 1
if object.isPlayer then xVal = player.x end
	for x = 1, x+1 do
		if not player:isColliding(object.x,(object.y+1),object.colMap) then
			object.y = object.y+1
			y = y + 1
		else
			break
		end
		
	end
end

function game.determineSpeed(speed)
	return math.ceil(math.round((speed * dt),0))
end

function game:playerDeath()
	error('Times Up!!!!!')
end





function paralaxingBG()
	if (player.maxPosition - player.x) <0 then 
		x = (player.maxPosition - player.x)
	else
		x = 0
	end
		backgrounds[4].x = x
	if (math.abs(backgrounds[4].x)+1)  > (backgrounds[4].image:getWidth() - love.graphics.getWidth()) then
		x = (backgrounds[4].image:getWidth() - love.graphics.getWidth() ) * (-1)
	end	
	
	for i,v in pairs(backgrounds) do
		if i == 2 then --bushes
			--v.x = math.round(0 - (x*0.95))*-1
		elseif i == 1 then --clouds
			--v.x = 0 + math.round(0 - (x*0.09))*-1
		else --interactables
			
		end
	end
	
	for i,v in pairs(items) do
		v.x =  v.origX + (backgrounds[4].x) * 1
		
	end


end

function doParalax()
	if player.x > player.maxPosition then return true else return false end
end

function intersection2(table1, table2)
    local values = {}
    for y, xtable in ipairs(table1) do -- use ipairs when tables are arrays
        for x,v in pairs(xtable) do
            values[v] = {x,y}
        end
    end
   
    local Y = {}
    local X = {}
	local index = 1
    for y, xtable in pairs(table2) do
        for x,v in pairs(xtable) do
            if v then
				X[x] = x--{t1 = values[v], t2 = {x=x,y=y}, value = v}
                Y[x] = y--{t1 = values[v], t2 = {x=x,y=y}, value = v}
				index = index+1
			else
				index = index +1
            end
        end
    end

    return X,Y
end











