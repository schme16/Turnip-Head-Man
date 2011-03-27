item = {}
items = {}
predefinedItems = {
	coin = {colMap = collision:newCollisionMap('img/items/coinBlock/1.png'), onHit = 'addCoin', image = images.coin, cost = 10}
}


function item:add(index, x, y)
	local toAdd = deepcopy(predefinedItems[index])
		  toAdd.x = (x)
		  toAdd.origX = (math.abs(backgrounds[4].x) +x)
		  toAdd.y = y
		  toAdd.gravitySpeed = 0 
		  toAdd.isJumping = 0
		  toAdd.offset = backgrounds[4].x
	table.insert(items,toAdd)
end

function item:remove(x)
	x = nil
end

function item:update()
	for i,v in pairs(items) do
		love.graphics.draw(v.image,v.x,v.y)
	end
end

function item:addCoin()
	player.coins = player.coins + 1
end

