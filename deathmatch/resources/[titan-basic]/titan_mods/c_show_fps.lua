local font = exports.titan_fonts:getFont("RobotoB", 12)

showfps = false
lastfps = 0
fps = 0
timer = nil


function toggleShowFPS()
	showfps = not showfps
	
	if (showfps) then
		fps = 0
		lastfps = 0
		addEventHandler("onClientRender", getRootElement(), countFPS)
		timer = setTimer(resetFPS, 1000, 0)
	else
		killTimer(timer)
		timer = nil
		removeEventHandler("onClientRender", getRootElement(), countFPS)
	end
end
addCommandHandler("showfps", toggleShowFPS, false)

local setknockoff = false
function resetFPS()
	if ( lastfps ~= ".." ) then
		if lastfps < 20 then
			setPedCanBeKnockedOffBike(getLocalPlayer(), false)
			setknockoff = true
		elseif setknockoff then
			setPedCanBeKnockedOffBike(getLocalPlayer(), true)
			setknockoff = false
		end
	end
	lastfps = fps
	fps = 0
end

function countFPS()
	local r = 255
	local g = 255
	local b = 255
	
	fps = fps + 1
	width, height = guiGetScreenSize()
	
	if ( lastfps == 0 ) then
		lastfps = ".."
	end
	
	if ( lastfps ~= ".." ) then
		if (lastfps > 35) then
			r = 0
			g = 255
			b = 0
		elseif (lastfps > 20) then
			r = 255
			g = 255
			b = 0
		elseif (lastfps <= 20) then
			r = 255
			g = 0
			b = 0
		end
	end
	if exports.titan_global:isStaffOnDuty(localPlayer) then
	height = height - 62
	end
	dxDrawText("FPS: " .. tostring(lastfps), 190+74, height-30, 50, height-30, tocolor(r, g, b, 125), 1, font)
end

--addEventHandler("onClientRender", getRootElement(), countFPS)