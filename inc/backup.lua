

player = {
	facing = 'left',
	isJumping = 0,
	x = 100,
	y = 100,
	speed = 140,
	gravitySpeed = 250,
	falling = false,
	world = 1,
	stage = 1,
	colMap = collision:newCollisionMap('img/player/collision.png'),
	coins = 0,
	isPlayer = true,
}
--local bound = {right = love.graphics.newImage('img/player/right/walkingBounding.png'), left = love.graphics.newImage('img/player/left/walkingBounding.png')}
game = {state = 'newGame'}

local backgrounds = {}



---------------------------------------------------------------------------------------------------------
------------------------------------------Game Functions-----------------------------------------------
---------------------------------------------------------------------------------------------------------

function game:run() --calls the game state 
	game[game.state]()
end

function game:running() --is run when the game is `running`
	player:update()
	item:update()
	game:gravity(player)
	for i,v in ipairs(items) do
		game:gravity(v)
	end
	game:backgrounds()
	--debugVal = 'X:'..mouse.X()..' - Y:'..mouse.Y()
	
end

function game:backgrounds()
	love.graphics.draw(backgrounds[2].image,0,0)
	player:draw()
	r,g,b,a = love.graphics.getColor()

	love.graphics.setColor(r,g,b,160)
	love.graphics.draw(backgrounds[1].image,0,0)
	love.graphics.setColorMode( 'modulate' )
	love.graphics.setColor(r,g,b,a)
	
	
	love.graphics.draw(backgrounds[3].image,0,0)
	love.graphics.draw(backgrounds[4].image,0,0)

end

function game:start() --called when you start a game
	
end

function game:newGame() --called when you start a NEW game
	player.left = newImageAnimation('img/player/left/', 0.08, 9)
	player.right =  newImageAnimation('img/player/right/', 0.08, 9)
	game:buildMap()
	game.state = 'running'
	int = game:buildItemsFromMap('img/maps/1/1/3.png', 'img/items/coinBlock/1.png')
end

function game:loadGame() --called when you start LOAD a game
	
end

function game:paused()
	
end

function game:buildMap()
		
	local temp = 'img/maps/'..player.world..'/'..player.stage..'/'
	backgrounds = {
		{colMap = collision:newCollisionMap(temp..'1.png'),image = love.graphics.newImage( temp..'1.png')},
		{colMap = collision:newCollisionMap(temp..'2.png'),image = love.graphics.newImage( temp..'2.png')},
		{colMap = collision:newCollisionMap(temp..'3.png'),image = love.graphics.newImage( temp..'3.png')},
		{colMap = collision:newCollisionMap(temp..'4.png'),image = love.graphics.newImage( temp..'4.png')},

	}

			table.insert(backgrounds,{
			image = love.graphics.newImage( temp..x..'.png'), 
			collide = coll, collisionMap = colMap, 
			x=0,
			y=0,
			})
		end
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
			if not player:isColliding(object.x,(object.y+game.determineSpeed(object.gravitySpeed)),object.colMap) then
				object.y = object.y+game.determineSpeed(object.gravitySpeed)
			
			else
				game:findGround(object)
			end
			
			if player:isColliding(object.x,(object.y+1),object.colMap) then
				object.falling = false
			end
		end
	
	else --This only effects items
	
	end
end

function game:findGround(object)
	for x = 1, 99 do
		if not player:isColliding(object.x,(object.y+1),object.colMap) then
			object.y = object.y+1
		else
			break
			end
		end
end

function game.determineSpeed(speed)
	return math.ceil(math.round((speed * dt),0))
end





---------------------------------------------------------------------------------------------------------
------------------------------------------Player Functions-----------------------------------------------
---------------------------------------------------------------------------------------------------------



function player:jumping()
	local tempY = player.y - game.determineSpeed(player.gravitySpeed)
	local tempJ = player.isJumping - game.determineSpeed(player.gravitySpeed)
	if player.isJumping > 0 and not player:isColliding(player.x,tempY,player.colMap) then
		player.y = tempY
		player.isJumping = tempJ
	elseif 	player:isColliding(player.x,tempY, player.colMap) then
		player.isJumping = true
		player.isJumping = 0
	end
end

function player:die()
	error('nawwww....')
end

function player:update(dt)
	love.graphics.draw(images.playerColMap,player.x,player.y)
	player.sprite():update(dt)
	player:jumping()
	player:walking()

end

function player:walking()
	
	local mathDelta = game.determineSpeed(player.speed)

	if love.keyboard.isDown( 'left')  then
	
		if not (player.facing == 'left') then
			player.facing = 'left' 
		end
		
		if not player:isColliding(player.x-mathDelta,player.y,player.colMap) then
			player.x = player.x - mathDelta
			player:sprite():toggle(true)
		else
			if not player:isColliding(player.x-mathDelta,player.y-1,player.colMap) then
				player.x = player.x - mathDelta
				player.y = player.y - 1
				player:sprite():toggle(true)
			else
				player:sprite():toggle(false)
				player:sprite():reset(3)
			end
		end
		
		if not player:isColliding((player.x-1),player.y, player.colMap) then
			player.x = player.x-1
			player:sprite():toggle(true)
		else
			if not player:isColliding(player.x-1,player.y-1,player.colMap) then
				player.x = player.x - 1
				player.y = player.y - 1
				player:sprite():toggle(true)
			else
				player:sprite():toggle(false)
				player:sprite():reset(3)
			end
		end
		
    end

    if love.keyboard.isDown('right') then
		if not (player.facing == 'right') then
			player.facing = 'right' 
		end
	
	
		
		if not player:isColliding(player.x+mathDelta,player.y,player.colMap) then
			player.x = player.x + mathDelta
			player:sprite():toggle(true)
		else
			if not player:isColliding(player.x+mathDelta,player.y-1,player.colMap) then
				player.x = player.x + mathDelta
				player.y = player.y - 1
				player:sprite():toggle(true)
			else
				player:sprite():toggle(false)
				player:sprite():reset(3)
			end
		end
		
		if not player:isColliding((player.x+1),player.y, player.colMap) then
			player.x = player.x+1
			player:sprite():toggle(true)
		else
			if not player:isColliding(player.x+1,player.y-1,player.colMap) then
				player.x = player.x + 1
				player.y = player.y - 1
				player:sprite():toggle(true)
			else
				player:sprite():toggle(false)
				player:sprite():reset(3)
			end
		end
			

   end

    if love.keyboard.isDown('up') and player.falling == false then
		player.falling = true
		player.isJumping = 65
		player:sprite():toggle(false)
    end

    if love.keyboard.isDown('down') then
		--this is really just a place holder; I'll probably never add anything here.
    end
	
	if not love.keyboard.isDown('down') and not love.keyboard.isDown('up') and not love.keyboard.isDown('right') and not love.keyboard.isDown( 'left') then
		player:sprite():toggle(false)
		player:sprite():reset(3)
	end
	
	
end

function player:draw()
	 player:sprite():draw(player.x, player.y, 0,1,1,0,0)
	 --love.graphics.draw(bound[player.facing],player.x, player.y, 0,1,1,0,0)
end

function player:isColliding(x,y, CM)
	local sprite1 = player:sprite():getImage()
	if CM then
		sprite1.collisionMap = CM
	end
	sprite1.x = x
	sprite1.y = y
	for x = 1,4 do	
		if backgrounds[x].collide and collision:checkCollision( sprite1, backgrounds[x] ) then
			return collision:checkCollision( sprite1, backgrounds[x] )
		end
	end
end

function player:sprite()
	return player[player.facing]
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











