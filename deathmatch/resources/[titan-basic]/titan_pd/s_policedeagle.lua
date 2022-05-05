function tazerFired(x, y, z, target)
	local px, py, pz = getElementPosition(source)
	local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)

	if (distance<20) then
		if (isElement(target) and getElementType(target)=="player") then
			for key, value in ipairs(exports.titan_global:getNearbyElements(target, "player", 20)) do
				if (value~=source) then
					triggerClientEvent(value, "showTazerEffect", value, x, y, z) -- show the sparks
				end
			end
			
			exports.titan_anticheat:changeProtectedElementDataEx(target, "tazed", true, false)
			toggleAllControls(target, false, true, false)
			triggerClientEvent(target, "onClientPlayerWeaponCheck", target)
			exports.titan_global:applyAnimation(target, "ped", "FLOOR_hit_f", 0, false, true, true, true, true)
			--setElementData(target, "tazed", true)
			setTimer(removeAnimation, 300000, 1, target)
		end
	end
end
addEvent("tazerFired", true )
addEventHandler("tazerFired", getRootElement(), tazerFired)

addCommandHandler("tazerkaldir", 
	function(thePlayer, cmd, targetPlayer)
		local theTeam = getPlayerTeam(thePlayer)
		if getElementData(theTeam, "type") == 2 or exports.titan_integration:isPlayerAdmin(thePlayer) then
			if targetPlayer then
				local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				if getElementData(targetPlayer, "tazed") then
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Oyuncunun tazer etkisi kaldırıldı.", thePlayer, 0, 255, 0, true)
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0" .. getPlayerName(thePlayer) .. " tarafından kaldırıldınız.", targetPlayer, 0, 255, 0, true)
					removeAnimation(targetPlayer)
					
				else
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0Kişi tazerlanmamış.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #f0f0f0/" .. cmd .. " [oyuncu ID]", thePlayer, 255, 0, 0, true)
			end
		end
	end
)

function removeAnimation(thePlayer)
	if (isElement(thePlayer) and getElementType(thePlayer)=="player") then
		exports.titan_global:applyAnimation(target, "ped", "FLOOR_hit_f", -1, false, true, true, true, true)
		exports.titan_global:removeAnimation(thePlayer, true)
		toggleAllControls(thePlayer, true, true, true)
		triggerClientEvent(thePlayer, "onClientPlayerWeaponCheck", thePlayer)
	end
end

function updateDeagleMode(mode)
	if ( tonumber(mode) and (tonumber(mode) >= 0 and tonumber(mode) <= 2) ) then
		exports.titan_anticheat:changeProtectedElementDataEx(client, "deaglemode", mode, true)
	end
end
addEvent("deaglemode", true)
addEventHandler("deaglemode", getRootElement(), updateDeagleMode)