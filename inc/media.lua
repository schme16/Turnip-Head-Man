--This is a predefined media area.
images = 
{
	coin = love.graphics.newImage('img/items/coinBlock/1.png'),
	colImage = love.graphics.newImage('img/player/right/colMap.gif'),
}

playerColMap = 
{
	['right'] = collision:newCollisionMap('img/player/right/colMap.gif'),
	['left'] = collision:newCollisionMap('img/player/left/colMap.gif'),
}
