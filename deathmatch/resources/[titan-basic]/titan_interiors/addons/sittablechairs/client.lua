local chairData =
{
	-- offset = { x, y, z }, rotation = rz, rotateable = degrees in both direction you can turn
	[1720] = { offset = { 0, 0, 1.3 }, rotation = 0 },
	[1716] = { offset = { -0.3, -0.3, 1.5 }, rotation = 270, rotateable = 360 },
	[2125] = { offset = { 0, 0, 1.3 }, rotation = 90, rotateable = 180 },
	[1671] = { offset = { 0, 0, 0.8 }, rotation = 0 },
	[1714] = { offset = { 0, 0, 1.3 }, rotation = 0 },
	[1715] = { offset = { 0, -0.2, 1.3 }, rotation = 0 },
	[1722] = { offset = { 0, 0.3, 1.35 }, rotation = 180, rotateable = 100 },
	[1721] = { offset = { 0, 0.3, 1.35 }, rotation = 180, rotateable = 0 },
	[1704] = { offset = { 0.5, -0.25, 1.4 }, rotation = 0 },
	[1727] = { offset = { 0.5, -0.25, 1.4 }, rotation = 0 },
	[1754] = { offset = { 0, -0.25, 1.4 }, rotation = 0 },
	[2350] = { offset = { 0, 0, 1.3 }, rotation = 90, rotateable = 180 },
	[1663] = { offset = { 0, 0, 0.8 }, rotation = 0 },
}

local unsolidObjects = { }
local localPlayer = getLocalPlayer()
local sitting = false
local myChair = nil
local px, py, pz = nil
local chairPerson = { }

function isValidChair(obj)
	return chairData[getElementModel(obj)] and true
end

function isValidObject(obj)
	return ( obj and isElement(obj) and getElementType(obj) == "object" and isValidChair(obj) )
end

function resourceStop()
	if ( sitting ) then
		attemptToStandUp()
	end
end
addEventHandler("onClientResourceStop", getResourceRootElement(), resourceStop)

function onRemotePlayerQuit()
	for k,v in ipairs(chairPerson) do
		if ( v == source ) then
			chairPerson[k] = nil
			break
		end
	end
end
addEventHandler("onClientPlayerQuit", getRootElement(), onRemotePlayerQuit)

function csit(x, y, z)
	for k,v in ipairs(getElementsByType("object")) do
		local ox, oy, oz = getElementPosition(v)
		if ( ox == x and oy == y and oz == z ) then
			if chairData[getElementModel(v)] then
				chairPerson[v] = source
				attachElements(source, v, unpack(chairData[getElementModel(v)].offset))
				break
			end
		end
	end
end
addEvent("csit", true)
addEventHandler("csit", getRootElement(), csit)

function cstand()
	for k,v in pairs(chairPerson) do
		if ( chairPerson[k] == source ) then
			detachElements(source, k)
			chairPerson[k] = nil
			break
		end
	end
end
addEvent("cstand", true)
addEventHandler("cstand", getRootElement(), cstand)

function resourceStart(res)
	if ( res == getThisResource() ) then
		for k,v in ipairs(getElementsByType("object")) do
			if ( unsolidObjects[getElementModel(v)] ) then
				setElementCollisionsEnabled(v, false)
			else
				setElementCollisionsEnabled(v, true)
			end
		end
	end
end
addEventHandler("onClientResourceStart", getRootElement(), resourceStart)

function useChair(chair)
	px, py, pz = getElementPosition(localPlayer)
	local x, y, z = getElementPosition(chair)
	local rx, ry, rz = getElementRotation(chair)
	local data = chairData[getElementModel(chair)]

	triggerServerEvent("sit", localPlayer, x, y, z, rz + data.rotation)
	sitting = true
	myChair = chair
	attachElements(localPlayer, chair, unpack(data.offset))
	call(getResourceFromName("titan_social"), "toggleCursor")
	if data.rotateable then
		sitGUI(data.rotateable, rz + data.rotation)
	end
	
	outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 ??u anda sandalyeye oturdun. M'ye bas??p kendine sa?? t??klarsan sandalyeden kalkabilirsin.", 0, 255, 0, true)
end

function attemptToSitOnChair(chair)
	if ( canISitOnChair(chair) ) then
		if ( chairPerson[chair] ~= nil ) then
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 ??u an bu koltukta zaten bir ba??kas?? oturuyor.", 255, 0, 0, true)
		else
			useChair(chair)
		end
	else
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Oturmak istedi??in sandalye ??ok uza????nda. Az??c??k yakla??.", 255, 0, 0, true)
	end
end

addEvent("chair:selfsit", true)
addEventHandler("chair:selfsit", root,
	function( )
		useChair(source)
	end
)

function canISitOnChair(chair)
	local x, y, z = getElementPosition(localPlayer)
	local cx, cy, cz = getElementPosition(chair)
	
	return (getDistanceBetweenPoints3D(x, y, z, cx, cy, cz) < 3) and getElementAlpha(chair) == 255
end

function attemptToStandUp()
	sitting = false
	myChair = nil
	triggerServerEvent("stand", localPlayer)
	detachElements(localPlayer, myChair)
	setElementPosition(localPlayer, px, py, pz)
	px, py, pz = nil
	call(getResourceFromName("titan_social"), "toggleCursor")
	unsitGUI()
end

function clickedChair(button, state, absX, absY, wx, wy, wz, chair)
	if ( button == "right" and state == "down" ) then
		if ( isValidObject(chair) and not sitting ) then
			attemptToSitOnChair(chair)
		elseif chair == getLocalPlayer() and sitting then
			attemptToStandUp()
		elseif not sitting then
			local camX, camY, camZ = getCameraMatrix()
			local cursorX, cursorY, endX, endY, endZ = getCursorPosition()
			
			local x = {processLineOfSight(camX, camY, camZ, endX, endY, endZ, true, true, true, true, true, true, false, true, localPlayer, true)}
			local hit, _, _, _, _, _, _, _, mat, _, _, buildingId, bx, by, bz, ba, bb, bc = unpack(x)
			
			if hit and chairData[buildingId] then
				local x, y, z = getElementPosition(getLocalPlayer())
				if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=3) then
					triggerServerEvent("chair:allocate", localPlayer, buildingId, bx, by, bz, ba, bb, bc)
				end
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickedChair)

function onDead()
	sitting = false
	detachElements(localPlayer, myChair)
	myChair = nil
	unsitGUI()
end
addEventHandler("onClientPlayerWasted", getLocalPlayer(), onDead)

local sitScroll = nil
local stuff, stoff


function sitGUI() end
function unsitGUI() end
