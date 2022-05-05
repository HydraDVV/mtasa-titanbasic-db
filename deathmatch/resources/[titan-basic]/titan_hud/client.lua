function bindSomeHotKey()
	bindKey("F5", "down", function()
		if getElementData(localPlayer, "vehicle_hotkey") == "0" then 
			return false
		end
		triggerServerEvent('realism:seatbelt:toggle', localPlayer, localPlayer)
	end) 

	bindKey("x", "down", function() 
		if getElementData(localPlayer, "vehicle_hotkey") == "0" then 
			return false
		end
		triggerServerEvent('vehicle:togWindow', localPlayer)
	end)
end
addEventHandler("onClientResourceStart", resourceRoot, bindSomeHotKey)

local screenSize = Vector2( guiGetScreenSize() )

function getScreenRotationFromWorldPosition( targetX, targetY, targetZ )
    -- Get camera position and rotation
    local camX, camY, _, lookAtX, lookAtY = getCameraMatrix()
    local camRotZ = math.atan2 ( ( lookAtX - camX ), ( lookAtY - camY ) )

    -- Calc direction to
    local dirX = targetX - camX
    local dirY = targetY - camY

    -- Calc rotation to
    local dirRotZ = math.atan2(dirX,dirY)

    -- Calc relative rotation to
    local relRotZ = dirRotZ - camRotZ

    -- Return rotation in degrees
    return math.deg(relRotZ)
end

setTimer(
         function()
			for key, value in ipairs(getElementsByType("player"), root, true) do
				local rot = getPedCameraRotation(value)
				local x, y, z = getElementPosition(value)
				local sx, sy = getScreenFromWorldPosition ( x, y, z )
				local sxx, syy = guiGetScreenSize()
				local vx = x + math.sin(math.rad(rot)) * 10
				local vy = y + math.cos(math.rad(rot)) * 10
				local _, _, vz = getWorldFromScreenPosition ( sxx, syy, 1 )
				if getElementData(value, "kafa") == 1 then
				
				else
				setPedAimTarget(value, vx, vy, vz )
				setPedLookAt(value, vx, vy, vz)
			end
			end
         end
, 90, 0)

function deneme ()
	if getElementData(getLocalPlayer(), "kafa") == 1 then
	 setElementData(localPlayer, "kafa", 0)
	 outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#ffffff Kafa çevirme açıldı.", 0, 255, 0, true)
	else
	setElementData(getLocalPlayer(), "kafa", 1)
	outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#ffffff Kafa çevirme kapatıldı.", 255, 0, 0, true)
	end
end
addCommandHandler("kafacevir", deneme)


function isActive()
	return getElementData(localPlayer, "hide_hud") ~= "0"
end


--[[ 
addEventHandler("onClientPreRender", root, 
	function()
		for key, value in ipairs(getElementsByType("player"), root, true) do
			x, y, z, lx, ly, lz = triggerServerEvent("getPedLookAt", value) -- value, 
			setPedAimTarget(value, x, y, z )
			setPedLookAt(value, x, y, z)
		end
	end
)]]
