local animation = {}
animation.__index = animation

function newImageAnimation(image, delay, frames)
local a = {}
	a.img = image
	a.timer = 0
	a.playing = true
	a.speed = delay
	a.frames = {}
	a.frameCollisions = {}
	a.currentFrame = 1
	a.step = 1
	for x = 1, frames do
		local frameName = image..x..'.gif'
		a.frames[x] = love.graphics.newImage(frameName)
		a.frameCollisions[x] =  collision:newCollisionMap( frameName )
	end

	return setmetatable(a, animation)

end

function animation:update(dt)
	if self.playing then
		self.step = self.step + 1
		if self.step > 60*self.speed then
			self.currentFrame = self.currentFrame + 1
			self.step = 1
			if self.currentFrame > #self.frames then
				self.currentFrame = 1
			end
		end
	end
end

function animation:toggle(state)
	self.playing = state
end

function animation:reset(frame)
	self.currentFrame = frame
end

function animation:draw(x, y, angle, sx, sy, ox, oy)
	love.graphics.draw(self.frames[self.currentFrame], x, y, angle, sx, sy, ox, oy)
end

function animation:getImage()
	return {image = self.frames[self.currentFrame], colMap = self.frameCollisions[self.currentFrame]}
end