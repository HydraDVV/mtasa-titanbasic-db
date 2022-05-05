local specialWeapons = {
	[30] = {true, 2},
	[31] = {true, 3}
}

local allowedFactions = {
	[1] = true,
	[59] = true,
	[163] = true,
	[148] = true,
}

function antiWeapon(preSlot)
	
	local currentWeaponID = getPedWeapon(localPlayer)

	if specialWeapons[currentWeaponID] then
		if specialWeapons[currentWeaponID][1] then

			local myFaction = getElementData(source, "faction") or -1
			if allowedFactions[myFaction] then
				return 
			end

			local vipLevel = (getElementData(localPlayer, "vipver") or 0)
			local gerekliLevel = specialWeapons[currentWeaponID][2] or 1
			if not (vipLevel >= 2) then
				setPedWeaponSlot(localPlayer, preSlot)
				outputChatBox("► #FFFFFF"..getWeaponNameFromID(currentWeaponID).." markalı silahı eline alabilmen için minimum VIP ["..gerekliLevel.."] olmalısın.", 255, 194, 100, true)
			end
		end
	end
end
addEventHandler("onClientPlayerWeaponSwitch", localPlayer, antiWeapon)