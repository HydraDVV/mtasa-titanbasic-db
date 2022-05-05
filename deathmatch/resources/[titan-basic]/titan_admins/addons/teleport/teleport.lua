function AdminLoungeTeleport(sourcePlayer)
	if (exports.titan_integration:isPlayerTrialAdmin(sourcePlayer) or exports.titan_integration:isPlayerSupporter(sourcePlayer)) then
		setElementPosition(sourcePlayer, 219.9208984375, 1822.841796875, 7.5325832366943 )
		--setElementFrozen(sourcePlayer, true)
		setPedGravity(sourcePlayer, 0.008)
		setElementDimension(sourcePlayer, 0)
		setElementInterior(sourcePlayer, 0)
		triggerEvent("texture-system:loadCustomTextures", sourcePlayer)
	end
end

addCommandHandler("adminlounge", AdminLoungeTeleport)
addCommandHandler("gmlounge", AdminLoungeTeleport)

function setX(sourcePlayer, commandName, newX)
	if (exports.titan_integration:isPlayerTrialAdmin(sourcePlayer) or exports.titan_integration:isPlayerScripter(sourcePlayer)) then
		if not (newX) then
			outputChatBox("KULLANIM: /" .. commandName .. " [x coordinate]", sourcePlayer, 255, 194, 14)
		else
			x, y, z = getElementPosition(sourcePlayer)
			setElementPosition(sourcePlayer, newX, y, z)
			x, y, z = nil
		end
	end
end

addCommandHandler("setx", setX)

function setY(sourcePlayer, commandName, newY)
	if (exports.titan_integration:isPlayerTrialAdmin(sourcePlayer) or exports.titan_integration:isPlayerScripter(sourcePlayer)) then
		if not (newY) then
			outputChatBox("KULLANIM: /" .. commandName .. " [y coordinate]", sourcePlayer, 255, 194, 14)
		else
			x, y, z = getElementPosition(sourcePlayer)
			setElementPosition(sourcePlayer, x, newY, z)
			x, y, z = nil
		end
	end
end

addCommandHandler("sety", setY)

function setZ(sourcePlayer, commandName, newZ)
	if (exports.titan_integration:isPlayerTrialAdmin(sourcePlayer) or exports.titan_integration:isPlayerScripter(sourcePlayer)) then
		if not (newZ) then
			outputChatBox("KULLANIM: /" .. commandName .. " [z coordinate]", sourcePlayer, 255, 194, 14)
		else
			x, y, z = getElementPosition(sourcePlayer)
			setElementPosition(sourcePlayer, x, y, newZ)
			x, y, z = nil
		end
	end
end

addCommandHandler("setz", setZ)

function setXYZ(sourcePlayer, commandName, newX, newY, newZ)
	if (exports.titan_integration:isPlayerTrialAdmin(sourcePlayer) or exports.titan_integration:isPlayerScripter(sourcePlayer)) then
		if (newX) and (newY) and (newZ) then
			setElementPosition(sourcePlayer, newX, newY, newZ)
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [x coordnate] [y coordinate] [z coordinate]", sourcePlayer, 255, 194, 14)
		end
	end
end

addCommandHandler("setxyz", setXYZ)

function setXY(sourcePlayer, commandName, newX, newY)
	if (exports.titan_integration:isPlayerTrialAdmin(sourcePlayer) or exports.titan_integration:isPlayerScripter(sourcePlayer)) then
		if (newX) and (newY) then
			setElementPosition(sourcePlayer, newX, newY)
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [x coordnate] [y coordinate]", sourcePlayer, 255, 194, 14)
		end
	end
end

addCommandHandler("setxy", setXY)

function setXZ(sourcePlayer, commandName, newX, newZ)
	if (exports.titan_integration:isPlayerTrialAdmin(sourcePlayer) or exports.titan_integration:isPlayerScripter(sourcePlayer)) then
		if (newX) and (newZ) then
			setElementPosition(sourcePlayer, newX, newZ)
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [x coordnate] [z coordinate]", sourcePlayer, 255, 194, 14)
		end
	end
end

addCommandHandler("setxz", setXZ)

function setYZ(sourcePlayer, commandName, newY, newZ)
	if (exports.titan_integration:isPlayerTrialAdmin(sourcePlayer) or exports.titan_integration:isPlayerScripter(sourcePlayer)) then
		if (newY) and (newZ) then
			setElementPosition(sourcePlayer, newY, newZ)
		else
			outputChatBox("KULLANIM: /" .. commandName .. " [y coordinate] [z coordinate]", sourcePlayer, 255, 194, 14)
		end
	end
end

addCommandHandler("setyz", setYZ)