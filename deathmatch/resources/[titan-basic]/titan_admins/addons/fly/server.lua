function fly(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	if exports.titan_global:isStaffOnDuty(thePlayer) then
		if veh then outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Bir araç içerisinde /fly komutunu kullanamazsınız.", thePlayer, 255, 0, 0, true) return end
		triggerClientEvent(thePlayer, "onClientFlyToggle", thePlayer)
	end
end
addCommandHandler("fly", fly, false, false)