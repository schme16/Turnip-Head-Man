

mouse = {X = love.mouse.getX, Y = love.mouse.getY}

keyboard = {last = '',}
function keyboard.isDown()

	local tempList = {
		'1','2','3','4','5','6','7','8','9','0','a','b','c','e','f','g',
		'h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w',
		'x','y','z','enter','shift','left','right','up','down',
		}

	for i,v in pairs(tempList) do
		if love.keyboard.isDown(v) then return v end
	end
	return ''
end

function keyboard.acceptKey(key)
	local List = {{["a"]=true,["c"]=true,["b"]=true,["e"]=true,["g"]=true,["f"]=true,["i"]=true,["h"]=true,["k"]=true,["j"]=true,["m"]=true,["l"]=true,["o"]=true,["n"]=true,["q"]=true,["p"]=true,["s"]=true,["r"]=true,["u"]=true,["t"]=true,["7"]=true,["6"]=true,["9"]=true,["8"]=true,["z"]=true,["right"]=true,["left"]=true,["5"]=true,["up"]=true,["shift"]=true,["w"]=true,["y"]=true,["x"]=true,["enter"]=true,["v"]=true,["1"]=true,["0"]=true,["3"]=true,["2"]=true,["down"]=true,["4"]=true,},}
	if List[key] then return true else return false	end
end