function playerDeath()
	if exports.titan_global:hasItem(getLocalPlayer(), 115) or exports.titan_global:hasItem(getLocalPlayer(), 116) then
		deathTimer = 200 -- Bekleme süresi // Sweetheart
		lowerTime = setTimer(lowerTimer, 1000, 200)
	else
		deathTimer = 50 -- Bekleme süresi // Sweetheart
		lowerTime = setTimer(lowerTimer, 1000, 50)
	end
	toggleAllControls(false, false, false)
	addEventHandler("onClientRender", root, drawnTimer, true, "low")
end
addEvent("playerdeath", true)
addEventHandler("playerdeath", getLocalPlayer(), playerDeath)

addEventHandler("onClientPlayerDamage", root,
    function()
        local x,y,z = getElementPosition(source)
		local gender = getElementData(source, "gender")
		if gender == 0 then
			playSound3D("components/hurtmale.mp3", x,y,z)
		else
			playSound3D("components/hurtfemale.mp3", x, y, z)
		end
    end
)

function lowerTimer()
	deathTimer = deathTimer - 1
	if deathTimer <= 0 then
		triggerServerEvent("es-system:acceptDeath", getLocalPlayer(), getLocalPlayer(), victimDropItem)
		playerRespawn()
		removeEventHandler("onClientRender", root, drawnTimer, true, "low")
	end
end
local font = exports.titan_fonts:getFont("FontAwesome", 25)
function formatString(n)
    if n < 10 then
        n = "0" .. n
    end
    return n
end

local sx, sy = guiGetScreenSize()
function drawnTimer()
    local x, y = 0, 20
    local r,g,b = 255,255,255
    if math.floor(deathTimer) <= 15 then
        r,g,b = 255,87,87
    end
	dxDrawText(deathTimer.." ", x, y+60,sx, sy-57, tocolor(0,0,0,255), 1, font, "center", "bottom")
    dxDrawText(deathTimer.." ", x, y+60,sx, sy-55, tocolor(r,g,b,255), 1, font, "center", "bottom")
end

deathTimer = 10
deathLabel = nil

function playerRespawn()
    removeEventHandler("onClientRender", root, drawnTimer, true, "low")
	if isTimer(lowerTimer) then
		killTimer(lowerTimer)
		toggleAllControls(true, true, true)
		setElementData(source, "baygin", nil)
	end
	--setCameraTarget(getLocalPlayer())
end

addEvent("bayilmaRevive", true)
addEventHandler("bayilmaRevive", root, playerRespawn)

addEvent("fadeCameraOnSpawn", true)
addEventHandler("fadeCameraOnSpawn", getLocalPlayer(),
	function()
		start = getTickCount()
	end
)

function closeRespawnButton()
	removeEventHandler("onClientRender", root, drawnTimer, true, "low")
	if isTimer(lowerTimer) then
		killTimer(lowerTimer)
		toggleAllControls(true, true, true)
	end
end
addEvent("es-system:closeRespawnButton", true)
addEventHandler("es-system:closeRespawnButton", getLocalPlayer(),closeRespawnButton)

function noDamageOnDeath ( attacker, weapon, bodypart )
	if ( getElementData(source, "dead") == 1 ) then
		cancelEvent()
	end
end
addEventHandler ( "onClientPlayerDamage", getLocalPlayer(), noDamageOnDeath )

function noKillOnDeath ( attacker, weapon, bodypart )
	if ( getElementData(source, "dead") == 1 ) then
		cancelEvent()
	end
end
addEventHandler ( "onClientPlayerWasted", getLocalPlayer(), noKillOnDeath )