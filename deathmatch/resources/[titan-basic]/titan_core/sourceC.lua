local screenX, screenY = guiGetScreenSize()

addEvent("vehicleSpawnProtect", true)
addEventHandler("vehicleSpawnProtect", getRootElement(),
	function (vehicle)
		if isElement(vehicle) then
			local cols = {}

			setElementAlpha(vehicle, 150)

			for k, v in ipairs(getElementsByType("vehicle", getRootElement(), true)) do
				setElementCollidableWith(vehicle, v, false)

				table.insert(cols, v)
			end

			for k, v in ipairs(getElementsByType("player", getRootElement(), true)) do
				setElementCollidableWith(vehicle, v, false)

				table.insert(cols, v)
			end

			setTimer(
				function ()
					if isElement(vehicle) then
						for i = 1, #cols do
							if isElement(cols[i]) then
								v = cols[i]
								
								setElementCollidableWith(vehicle, v, true)
							end
						end

						setElementAlpha(vehicle, 255)
					end
				end,
			15000, 1)
		end
	end
)

local quitReasons = {
	unknown = "Bilinmeyen",
	quit = "/quit",
	kicked = "Sunucudan Atıldı.",
	banned = "Sunucudan Uzaklaştırıldı.",
	["bad connection"] = "Kötü İnternet Bağlantısı.",
	["timed out"] = "Zaman Aşımı."
}

addEventHandler("onClientPlayerQuit", getRootElement(),
	function (reason)
		if getElementData(source, "loggedin") == 1 then
			local playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
			local sourcePosX, sourcePosY, sourcePosZ = getElementPosition(source)
			local distance =  getDistanceBetweenPoints3D(playerPosX, playerPosY, playerPosZ, sourcePosX, sourcePosY, sourcePosZ)

			if distance <= 20 then
				local playerName = getElementData(source, "visibleName"):gsub("_", " ")
				local quitReason = quitReasons[string.lower(reason)]

				outputChatBox(">> " .. playerName .. " oyundan ayrıldı. [" .. quitReason .. "] Mesafe: " .. math.floor(distance) .. " metre.", 215, 89, 89, true)
			end
		end
	end
)

local currentDimension = getElementDimension(localPlayer)
local currentInterior = getElementInterior(localPlayer)

addEvent("onClientDimensionChange", true)
addEvent("onClientInteriorChange", true)

local playerDoingAnimation = false
local attachedElementStartRot = false
local rotateableAnims = {}

addEventHandler("onClientRender", getRootElement(),
	function ()
		local activeInterior = getElementInterior(localPlayer)
		local activeDimension = getElementDimension(localPlayer)

		if currentInterior ~= activeInterior then
			triggerEvent("onClientInteriorChange", localPlayer, activeInterior, currentInterior)
			currentInterior = activeInterior
		end

		if currentDimension ~= activeDimension then
			triggerEvent("onClientDimensionChange", localPlayer, activeDimension, currentDimension)
			currentDimension = activeDimension
		end

		local block, anim = getPedAnimation(localPlayer)

		if block then
			playerDoingAnimation = true

			if block == "ped" and rotateableAnims[anim] then
				local cx, cy, cz, lx, ly = getCameraMatrix()
				local angle = math.deg(math.atan2(ly - cy, lx - cx)) - 90

				setPedRotation(localPlayer, angle)
			end
		elseif not block and playerDoingAnimation then
			playerDoingAnimation = false
			toggleAllControls(true, true, false)
		end

		local attachedTo = getElementAttachedTo(localPlayer)

		if attachedTo and getElementType(attachedTo) == "vehicle" then
			local rx, ry, rz = getElementRotation(attachedTo)

			if attachedElementStartRot then
				setPedRotation(localPlayer, rz + attachedElementStartRot)
			else
				attachedElementStartRot = getPedRotation(localPlayer) - rz
			end
		elseif attachedElementStartRot then
			attachedElementStartRot = false
		end
	end
)

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		setHeatHaze(0)
		setBlurLevel(0)
		setCloudsEnabled(false)
		setBirdsEnabled(false)
		setInteriorSoundsEnabled(false)
		setPedTargetingMarkerEnabled(false)
		setPlayerHudComponentVisible("all", false)
		setPlayerHudComponentVisible("crosshair", true)
		setWorldSpecialPropertyEnabled("randomfoliage", false)
		setWorldSpecialPropertyEnabled("extraairresistance", false)
		
		for k, v in ipairs(getElementsByType("player")) do
			setPedVoice(v, "PED_TYPE_DISABLED")
			setPlayerNametagShowing(v, false)
		end
		
		for k, v in ipairs(getElementsByType("ped")) do
			setPedVoice(v, "PED_TYPE_DISABLED")
		end
		
		setAmbientSoundEnabled("general", true)
		setAmbientSoundEnabled("gunfire", false)
		
		if getElementData(localPlayer, "loggedIn") then
			fadeCamera(true)
		end

		toggleControl("next_weapon", false)
		toggleControl("previous_weapon", false)

		setTimer(
			function()
				setPedControlState("walk", true)
			end,
		500, 0)

		setWorldSoundEnabled(0, 0, false, true)
		setWorldSoundEnabled(0, 29, false, true)
		setWorldSoundEnabled(0, 30, false, true)
	end
)

addEventHandler("onClientPlayerJoin", getRootElement(),
	function ()
		setPlayerNametagShowing(source, false)
	end
)

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		if getElementType(source) == "ped" or getElementType(source) == "player" then
			setPedVoice(source, "PED_TYPE_DISABLED")
		end
	end
)


addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName)
		if source == localPlayer then
			if dataName == "acc.adminLevel" then
				if getElementData(source, dataName) >= 9 then
					setDevelopmentMode(true)
				else
					setDevelopmentMode(false)
				end
			elseif dataName == "adminDuty" then
				if getElementData(source, "acc.adminLevel") >= 9 then
					setDevelopmentMode(true)
				else
					setDevelopmentMode(false)
				end
			end
		end
	end
)

local currentPlayingSound = false
local currentPlayingSound3D = false

addEvent("playClientSound", true)
addEventHandler("playClientSound", getRootElement(),
	function (audioPath)
		if isElement(currentPlayingSound) then
			stopSound(currentPlayingSound)
		end

		currentPlayingSound = playSound(audioPath)
		setSoundVolume(currentPlayingSound, 1.5)
	end
)

function playSoundForElement(element, path)
	triggerEvent("playClientSound", element, path)
end

addEvent("playClient3DSound", true)
addEventHandler("playClient3DSound", getRootElement(),
	function (audioPath, x, y, z, looped, elementCheck)
		if isElement(currentPlayingSound3D) and elementCheck then
			stopSound(currentPlayingSound3D)
		end
		
		currentPlayingSound3D = playSound3D(audioPath, x, y, z, looped)
	end
)

function minutesToHours(minutes)
	local totalMin = tonumber(minutes)
	if totalMin then
		local hours = math.floor(totalMin/60)
		local minutes = totalMin - hours*60
		if hours and minutes then
			return hours,minutes
		else
			return 0,0
		end
	end
end

function milisecondsToSeconds(miliseconds)
	local totalMilisecs = tonumber(miliseconds)
	if totalMilisecs then
		local secs = math.floor(totalMilisecs/1000)
		local milisecs = totalMilisecs - secs*1000
		if secs and milisecs then
			return secs,milisecs
		else
			return 0,0
		end
	end
end

function secondsToMinutes(seconds)
	local totalSec = tonumber(seconds)
	if totalSec then
		local seconds = math.fmod(math.floor(totalSec), 60)
		local minutes = math.fmod(math.floor(totalSec/60), 60)
		if seconds and minutes then
			return seconds,minutes
		end
	end
end

addEvent("onCoreStarted", true)

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		triggerEvent("onCoreStarted", localPlayer, interfaceFunctions())
	end
)

--[[

*********** Interface elementek meghívása (szkriptek elejére): ***********

	pcall(loadstring(base64Decode(exports.titan_core:getInterfaceElements())));addEventHandler("onCoreStarted",root,function(functions) for k,v in ipairs(functions) do _G[v]=nil;end;collectgarbage();pcall(loadstring(base64Decode(exports.titan_core:getInterfaceElements())));end)

*********** Szükséges elemek onClientRender-be: ***********
	
	buttons = {}

	-- ide jön a te kódod, e két kis rész közé.
	-- csekkolni, hogy aktív-e a gomb: if activeButton == "btn:gombNeve" then -- a btn: előtagot minden gomb elé odateszi!
	-- inputnál: if activeInput == "input:inputNeve" then -- input: előtagot mindig oda teszi automatikusan!!

	local relX, relY = getCursorPosition()

	activeButton = false

	if relX and relY then
		relX = relX * screenX
		relY = relY * screenY

		for k, v in pairs(buttons) do
			if relX >= v[1] and relY >= v[2] and relX <= v[1] + v[3] and relY <= v[2] + v[4] then
				activeButton = k
				break
			end
		end
	end

]]

function interfaceFunctions()
	return {"colorInterpolation", "drawButton", "drawInput", "drawButton2"}
end

local wErTzu666iop = base64Encode


local sm = {}
sm.moov = 0
sm.object1, sm.object2 = nil, nil

local function camRender()
	local x1, y1, z1 = getElementPosition(sm.object1)
	local x2, y2, z2 = getElementPosition(sm.object2)
	setCameraMatrix(x1, y1, z1, x2, y2, z2)
end

local function removeCamHandler()
	if (sm.moov == 1) then
		sm.moov = 0
		removeEventHandler("onClientPreRender", root, camRender)
	end
end

function stopSmoothMoveCamera()
	if (sm.moov == 1) then
		if (isTimer(sm.timer1)) then killTimer(sm.timer1) end
		if (isTimer(sm.timer2)) then killTimer(sm.timer2) end
		if (isTimer(sm.timer3)) then killTimer(sm.timer3) end
		if (isElement(sm.object1)) then destroyElement(sm.object1) end
		if (isElement(sm.object2)) then destroyElement(sm.object2) end
		removeCamHandler()
		sm.moov = 0
	end
end

function smoothMoveCamera(x1, y1, z1, x1t, y1t, z1t, x2, y2, z2, x2t, y2t, z2t, time, easing)
	if (sm.moov == 1) then return false end
	sm.object1 = createObject(1337, x1, y1, z1)
	sm.object2 = createObject(1337, x1t, y1t, z1t)
	setElementAlpha(sm.object1, 0)
	setElementAlpha(sm.object2, 0)
    setElementCollisionsEnabled(sm.object1, false)
    setElementCollisionsEnabled(sm.object2, false)
	setObjectScale(sm.object1, 0.01)
	setObjectScale(sm.object2, 0.01)
	moveObject(sm.object1, time, x2, y2, z2, 0, 0, 0, (easing and easing or "InOutQuad"))
	moveObject(sm.object2, time, x2t, y2t, z2t, 0, 0, 0, (easing and easing or "InOutQuad"))
	
	addEventHandler("onClientPreRender", root, camRender, true, "low")
	sm.moov = 1
	sm.timer1 = setTimer(removeCamHandler, time, 1)
	sm.timer2 = setTimer(destroyElement, time, 1, sm.object1)
	sm.timer3 = setTimer(destroyElement, time, 1, sm.object2)
	
	return true
end
	
screenSize = {guiGetScreenSize()}
getCursorPos = getCursorPosition
function getCursorPosition()

    --outputChatBox(tostring(isCursorShowing()))
    if isCursorShowing() then
        --outputChatBox("asd")
        local x,y = getCursorPos()
        --outputChatBox("x"..tostring(x))
        --outputChatBox("y"..tostring(y))
        x, y = x * screenSize[1], y * screenSize[2] 
        return x,y
    else
        return -5000, -5000
    end
end

cursorState = isCursorShowing()
cursorX, cursorY = getCursorPosition()

function isInBox(dX, dY, dSZ, dM, eX, eY)
    if eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM then
        return true
    else
        return false
    end
end

function isInSlot(xS,yS,wS,hS)
    if isCursorShowing() then
        local cursorX, cursorY = getCursorPosition()
        if isInBox(xS,yS,wS,hS, cursorX, cursorY) then
            return true
        else
            return false
        end
    end 
end

cursorDisabled = false
cursorState = isCursorShowing()


function intCursor(state, force)
    cursorState = state
    showCursor(cursorState)
    if cursorState then
        setCursorAlpha(255)
    end
    cursorDisabled = force
end

function getFonts()
    return fonts
end
