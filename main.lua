--Turnip Head Man Main File


--Required Files
	require 'inc/pPCollision'
	require 'inc/imageBatch'
	require 'inc/media'
	require 'inc/supportFunctions'
	require 'inc/tablePersistence'
	require 'inc/input'
	require 'inc/vector'
	require 'inc/camera'

playerFile = love.filesystem.load('inc/player.lua')
gameFile = love.filesystem.load('inc/game.lua')
itemsFile = love.filesystem.load('inc/items.lua')
hudFile = love.filesystem.load('inc/hud.lua')


time = os.time()
function love.load()
    font = love.graphics.newFont( 'fonts/segoesc.ttf',16 )
    love.graphics.setFont( font )
	love.graphics.setColorMode( 'replace' )
	love.graphics.setBackgroundColor(255,255,255)
	reloadGame('newGame')

end

function love.update(delta)
	dt = delta
	capFPS(delta, 29)
	keyboard.last = keyboard.isDown()
	
	
	--[[ for e,a,b,c in love.event.poll() do
		if e == "q" then
			love.event.push('q') -- quit the game
		elseif e == "f" then
			if not a and game.state == 'running' then game.state = 'paused' else game.state = 'running'  end
		end
	end ]]
	
end

function love.draw()
	if game then game:run() end
	gameDebug:run()
end
gameDebug = {active = true}

function gameDebug:run()
	if gameDebug.active then
		advPrint(tostring(debugVal), 20,20,{0,0,0})
	end
end

function gameDebug.toggle()
	gameDebug.active = not gameDebug.active
end	

function love.keypressed(key, u)
   --Debug
   if key == "rctrl" then --set to whatever key you want to use
      gameDebug.toggle()
	  reloadGame('newGame', 1, 1)
   end
end

function love.mousepressed( x, y, key )
	if key=='l' then
		if cam then 
			local camX,camY = cam:mousepos():unpack()
			if item and player.style >= predefinedItems.coin.cost then item:add('coin', camX,camY) player.style = player.style - predefinedItems.coin.cost end
		end
	end
end
function capFPS(delta, max)
	local ms = (1000 / 60) - (delta * 1000)
    if ms > 0 then
		love.timer.sleep(ms)
	end 
end

function reloadGame(state, world, stage)

love.graphics.rectangle('fill',0,0,love.graphics.getWidth(), love.graphics.getWidth())	
	cam = nil -- resets the camera
	player = nil
	if playerFile() then
		if world then player.world = world end
		if stage then player.stage = stage end
		advPrint('Loaded: Player',100,100,{0,0,0} )
	end	
		
	items = nil
	item = nil
	if  not itemsFile() then 
		advPrint('Loaded: Items',100,125,{0,0,0} )
	end	
	
	hud = nil
	if  not hudFile() then 
		advPrint('Loaded: HUD',100,150,{0,0,0} )
	end	
	
	game = nil
	if not gameFile() then
		advPrint('Loaded: Game',100,175,{0,0,0} )
		end

	if state and game then game.state = state	end
		time = os.time()
end


