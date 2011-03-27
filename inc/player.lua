
---------------------------------------------------------------------------------------------------------
------------------------------------------Player Functions-----------------------------------------------
---------------------------------------------------------------------------------------------------------
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
	colMap = playerColMap.left,
	image = images.colImage,
	score = 21805,
	style = 100,
	maxStyle = 200,
	isPlayer = true,
	maxPosition = love.graphics.getWidth()/2,
}


function player:isColliding(xVal, yVal)
	local temp ={}
	temp.colMap = player.colMap
	temp.image = player.image

	if not xVal then temp.x = player.x else temp.x = xVal  end
	if not yVal then temp.y = player.y else temp.y = yVal end
	
	for i,v in pairs(items) do
		if v.colMap and collision:checkCollision( temp, v ) then return true end
	end
	
	for i,v in pairs(backgrounds) do
		if v.colMap and collision:checkCollision( temp, v ) then return true end
	end
end

function player:jumping()
	local tempJ = player.isJumping - game.determineSpeed(player.gravitySpeed)
	local check = player:isColliding(false, (player.y - game.determineSpeed(player.gravitySpeed)))
	if player.isJumping > 0 and not check then
		player.y = player.y - game.determineSpeed(player.gravitySpeed)
		player.isJumping = tempJ
	elseif check then
		player.isJumping = true
		player.isJumping = 0
	end
end

function player:update(dt)
	player.sprite():update(dt)
	player:jumping()
	player:walking()

end


function player:walking()
		local check = false
		local check2 = false
	local mathDelta = game.determineSpeed(player.speed)
	
	local check = false
	
	if love.keyboard.isDown( 'left')  then
	
		if not (player.facing == 'left') then
			player.facing = 'left' 
		end
		
		check = player:isColliding(player.x-mathDelta-1,false)
		check2 = player:isColliding(player.x-mathDelta-1,player.y-2)

		if not check then
			player.x = player.x - mathDelta
			player:sprite():toggle(true)
		else
			if not check2 then
				player.x = player.x - mathDelta
				player.y = player.y - 2
				player:sprite():toggle(true)
			else
				player:sprite():toggle(false)
				player:sprite():reset(3)
			end
		end
		
		check = player:isColliding(player.x-2,false)
		check2 = player:isColliding(player.x-2,player.y-2)
		
		if not check then
			player.x = player.x-1
			player:sprite():toggle(true)
		else
			if not check2 then
				player.x = player.x - 1
				player.y = player.y - 2
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
	
	
		check = player:isColliding(player.x+mathDelta+1,false)
		check2 = player:isColliding(player.x+mathDelta+1,player.y-1)

		if not check then
			player.x = player.x + mathDelta
			player:sprite():toggle(true)
		else
			if not check2 then
				player.x = player.x + mathDelta
				player.y = player.y - 1
				player:sprite():toggle(true)
			else
				player:sprite():toggle(false)
				player:sprite():reset(3)
			end
		end
		
		check = player:isColliding(player.x+2,false)
		check2 = player:isColliding(player.x+2,player.y-1)
		
		if not check then
			player.x = player.x+1
			player:sprite():toggle(true)
		else
			if not check2 then
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
	
	if not love.keyboard.isDown('right') and not love.keyboard.isDown( 'left') then
		player:sprite():toggle(false)
		player:sprite():reset(3)
	end
	
	
end

function player:draw()
	player:sprite():draw(player.x, player.y, 0,1,1,0,0)
	--love.graphics.draw(bound[player.facing],player.x, player.y, 0,1,1,0,0)
end

function player.getX()
	local x = player.x
		
	if x >= math.abs(love.graphics.getWidth()-backgrounds[4].image:getWidth()) +love.graphics.getWidth()/2  then
		x = backgrounds[4].image:getWidth()-(love.graphics.getWidth()/2)
	end
		
	
	return x
end

function player:sprite()
	return player[player.facing]
end
