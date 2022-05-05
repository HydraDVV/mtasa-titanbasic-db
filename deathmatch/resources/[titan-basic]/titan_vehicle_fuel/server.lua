local mysql = exports.titan_mysql

local loadedPoints = 0
local fuelGun = {}

function playerAnimationToServer (localPlayer, animName, animtoName)
	setPedAnimation(localPlayer, animName, animtoName, -1, true, false, false, false)
end
addEvent("playerAnimationToServer", true)
addEventHandler("playerAnimationToServer", getRootElement(), playerAnimationToServer)


function syncPlayertoFuelGun(player, state)
	if not state then 
		fuelGun[player] = createObject(14463,0,0,0)
		exports.titan_bone_attach:attachElementToBone(fuelGun[player],player,12,0,0,0.06,-180,0,0)
	else
		if isElement(fuelGun[player]) then 
			destroyElement(fuelGun[player])
		end
	end
end
addEvent("syncPlayertoFuelGun", true)
addEventHandler("syncPlayertoFuelGun", getRootElement(), syncPlayertoFuelGun)

function syncPlayereffect (player, state )
	triggerClientEvent(root, "createEffectstoClient", root, player , fuelGun[player], tostring(state) )
end
addEvent("syncPlayereffect", true)
addEventHandler("syncPlayereffect", getRootElement(), syncPlayereffect)

addEventHandler("onPlayerQuit",getRootElement(),function()
	if isElement(fuelGun[source]) then 
		destroyElement(fuelGun[source])
	end
end)

addEvent("vehicle_fuel:takeMoneyGiveFuel", true)
addEventHandler("vehicle_fuel:takeMoneyGiveFuel", root,
	function(player, vehicle, pTaken, vGiven)
		if exports.titan_global:hasMoney(player, pTaken) then
			exports.titan_global:takeMoney(player, vGiven*4)
			vehicle:setData("fuel", vehicle:getData("fuel") + vGiven)
		else
			outputChatBox(exports.titan_pool:getServerSyntax(false, "e").."Yeterli paranız olmadığı için yakıt doldurulamıyor.", player, 255, 255, 255, true)
		end
	end
)