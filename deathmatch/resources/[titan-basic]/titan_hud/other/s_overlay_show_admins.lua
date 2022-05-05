
local function sortTable( a, b )
	if b[2] < a[2] then
		return true
	end

	if b[2] == a[2] and b[4] > a[4] then
		return true
	end

	return false
end
local dvpUsernames = {
	["ananke"] = true,
	["babanke"] = true,
}
local function getPlayerScripterRank( player )
	local username = getElementData(player, "account:username")
	if dvpUsernames[username] then
		return "Yazılımcı"
	end
	if exports.titan_integration:isPlayerLeadScripter( player ) then
		return "Yazılımcı"
	elseif exports.titan_integration:isPlayerScripter( player ) then
		return "Trial Scripter"
	elseif exports.titan_integration:isPlayerTester( player ) then
		return "Tester"
	else
		return ""
	end
end

local function getPlayerSupportRank( player )
	if exports.titan_integration:isPlayerSupportManager( player ) then
		return "Rehber Yönetimi"
	elseif exports.titan_integration:isPlayerSupporter( player ) then
		return "Rehber"
	else
		return ""
	end
end

function showStaff( thePlayer, commandName )
	local logged = getElementData(thePlayer, "loggedin")
	local info = {}
	local isOverlayDisabled = getElementData(thePlayer, "hud:isOverlayDisabled")

	-- ADMINS --
	if(logged==1) then
		local players = exports.titan_global:getAdmins()
		local counter = 0

		admins = {}

		if isOverlayDisabled then
			outputChatBox("YETKİLİLER:", thePlayer, 255, 194, 14)
		else
			table.insert(info, {" Yetkili Kadrosu:", 255, 194, 14, 255, 1, "title"})
			table.insert(info, {""})
		end

		for k, arrayPlayer in ipairs(players) do
			local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
			local logged = getElementData(arrayPlayer, "loggedin")
			local username = getElementData(arrayPlayer, "account:username")
			if (logged == 1) and not dvpUsernames[username] then
				if tonumber(getElementData( arrayPlayer, "admin_level" )) < 10 then
					if exports.titan_global:isStaffOnDuty(arrayPlayer) then
						if exports.titan_integration:isPlayerTrialAdmin(arrayPlayer) and ( hiddenAdmin == 0 or ( exports.titan_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerScripter(thePlayer) ) ) and not exports.titan_integration:isPlayerIA( arrayPlayer ) then
							admins[ #admins + 1 ] = { arrayPlayer, getElementData( arrayPlayer, "admin_level" ), getElementData( arrayPlayer, "duty_admin" ), exports.titan_global:getPlayerName( arrayPlayer ) }
						end
					end
				end
			end
		end

		table.sort( admins, sortTable )

		for k, v in ipairs(admins) do
			arrayPlayer = v[1]
			local adminTitle = exports.titan_global:getPlayerAdminTitle(arrayPlayer)
			local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
			if exports.titan_global:isStaffOnDuty(arrayPlayer) then
				if hiddenAdmin == 0 and exports.titan_integration:isPlayerTrialAdmin(thePlayer) then
					v[4] = v[4] .. " (" .. tostring(getElementData(arrayPlayer, "account:username")) .. ")"

					if(v[3]==1)then
						if isOverlayDisabled then
							outputChatBox("-    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." - Görevde", thePlayer, 0, 200, 10)
						else
							table.insert(info, {"-    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." - Görevde", 0, 255, 0, 255, 1, "default"})
						end
					else
						if isOverlayDisabled then
							outputChatBox("-    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." - Görevde Değil", thePlayer, 100, 100, 100)
						else
							table.insert(info, {"-    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." - Görevde Değil", 200, 200, 200, 255, 1, "default"})
						end
					end
				end
			end
		end

		if #admins == 0 then
			if isOverlayDisabled then
				outputChatBox("-    Aktif yetkili yok.", thePlayer)
			else
				table.insert(info, {"-    Aktif yetkili yok.", 255, 255, 255, 255, 1, "default"})
			end
		end
		--outputChatBox("Use /gms to see a list of gamemasters.", thePlayer)
	end

	if not isOverlayDisabled then
		table.insert(info, {" ", 100, 100, 100, 255, 1, "default"})
	end

	--GMS--
	if(logged==1) then
		local players = exports.titan_global:getGameMasters()
		local counter = 0

		admins = {}
		if isOverlayDisabled then
			outputChatBox("REHBERLER:", thePlayer, 255, 194, 14)
		else
			table.insert(info, {"Rehber Kadrosu:", 255, 194, 14, 255, 1, "title"})
			table.insert(info, {""})
		end
		for k, arrayPlayer in ipairs(players) do
			local logged = getElementData(arrayPlayer, "loggedin")
			if logged == 1 then
				if exports.titan_integration:isPlayerSupporter(arrayPlayer) and exports.titan_global:isStaffOnDuty(arrayPlayer) then
					admins[ #admins + 1 ] = { arrayPlayer, getElementData( arrayPlayer, "account:gmlevel" ), getElementData( arrayPlayer, "duty_supporter" ), exports.titan_global:getPlayerName( arrayPlayer ) }
				end
			end
		end

		for k, v in ipairs(admins) do
			arrayPlayer = v[1]
			local adminTitle = getPlayerSupportRank(arrayPlayer)

			--if exports.titan_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerScripter(thePlayer) then
				v[4] = v[4] .. " (" .. tostring(getElementData(arrayPlayer, "account:username")) .. ")"
			--end

			if(v[3] == 1)then
				if isOverlayDisabled then
					outputChatBox("-    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." - Görevde", thePlayer, 0, 200, 10)
				else
					table.insert(info, {"-    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." - Görevde", 0, 255, 0, 255, 1, "default"})
				end
			else
				if isOverlayDisabled then
					outputChatBox("-    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." - Görevde Değil", thePlayer, 100, 100, 100)
				else
					table.insert(info, {"-    " .. tostring(adminTitle) .. " " .. tostring(v[4]):gsub("_"," ").." - Görevde Değil", 200, 200, 200, 255, 1, "default"})
				end
			end
		end

		if #admins == 0 then
			if isOverlayDisabled then
				outputChatBox("-    Oyunda aktif rehber yok.", thePlayer)
			else
				table.insert(info, {"-     Oyunda aktif rehber yok.", 255, 255, 255, 255, 1, "default"})
			end
		end

	end

	if not isOverlayDisabled then
		table.insert(info, {" ", 100, 100, 100, 255, 1, "default"})
	end

	--VCTs--
	if(logged==1) then
		local players = exports.titan_pool:getPoolElementsByType("player")
		local counter = 0

		if isOverlayDisabled then
			outputChatBox("ARAÇ VERGİ SORUMLULARI:", thePlayer, 255, 194, 14)
		else
			table.insert(info, {"Araç Vergi Sorumlu Takımı:", 255, 194, 14, 255, 1, "title"})
			table.insert(info, {""})
		end

		for k, arrayPlayer in ipairs(players) do
			local logged = getElementData(arrayPlayer, "loggedin")
			if logged == 1 then
				if exports.titan_integration:isPlayerVCTMember(arrayPlayer) then
					local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
					local stuffToPrint
					if (hiddenAdmin == 1) then
						stuffToPrint = "-    "..(exports.titan_integration:isPlayerVehicleConsultant(arrayPlayer) and "Lider" or "Üye").." (Gizli) "..exports.titan_global:getPlayerName(arrayPlayer).." ("..getElementData(arrayPlayer, "account:username")..")"
					else
						stuffToPrint = "-    "..(exports.titan_integration:isPlayerVehicleConsultant(arrayPlayer) and "Lider" or "Üye").." "..exports.titan_global:getPlayerName(arrayPlayer).." ("..getElementData(arrayPlayer, "account:username")..")"
					end
					if (hiddenAdmin == 0 or ( exports.titan_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerScripter(thePlayer) ) ) then
						local r, g, b = 0, 255, 0 --hud colour
						local cR, cG, cB = 0, 200, 10 --chatbox colour
						if(hiddenAdmin == 1) then
							r, g, b = 200, 200, 200
							cR, cG, cB = 100, 100, 100
						end
						if isOverlayDisabled then
							outputChatBox(stuffToPrint, thePlayer, cR, cG, cB)
						else
							table.insert(info, {stuffToPrint, r, g, b, 255, 1, "default"})
						end
						counter = counter + 1
					end
				end
			end
		end

		if counter == 0 then
			if isOverlayDisabled then
				outputChatBox("-    Aktif araç vergi sorumlusu yok.", thePlayer)
			else
				table.insert(info, {"-    Aktif araç vergi sorumlusu yok.", 255, 255, 255, 255, 1, "default"})
			end
		end

		if not isOverlayDisabled then
			table.insert(info, {" ", 100, 100, 100, 255, 1, "default"})
		end


		-- MAPPING TEAM --
		--[[if isOverlayDisabled then
			outputChatBox("MAPPING TEAM:", thePlayer, 255, 194, 14)
		else
			table.insert(info, {"Mapping Team:", 255, 194, 14, 255, 1, "title"})
			table.insert(info, {""})
		end

		for k, arrayPlayer in ipairs(players) do
			local logged = getElementData(arrayPlayer, "loggedin")
			if logged == 1 then
				if exports.titan_integration:isPlayerMappingTeamMember(arrayPlayer) then
					local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
					local stuffToPrint
					if (hiddenAdmin == 1) then
						stuffToPrint = "-    "..(exports.titan_integration:isPlayerMappingTeamLeader(arrayPlayer) and "Leader" or "Member").." (Hidden) "..exports.titan_global:getPlayerName(arrayPlayer).." ("..getElementData(arrayPlayer, "account:username")..")"
					else
						stuffToPrint = "-    "..(exports.titan_integration:isPlayerMappingTeamLeader(arrayPlayer) and "Leader" or "Member").." "..exports.titan_global:getPlayerName(arrayPlayer).." ("..getElementData(arrayPlayer, "account:username")..")"
					end
					if (hiddenAdmin == 0 or ( exports.titan_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerScripter(thePlayer) ) ) then
						local r, g, b = 0, 255, 0 --hud colour
						local cR, cG, cB = 0, 200, 10 --chatbox colour
						if(hiddenAdmin == 1) then
							r, g, b = 200, 200, 200
							cR, cG, cB = 100, 100, 100
						end
						if isOverlayDisabled then
							outputChatBox(stuffToPrint, thePlayer, cR, cG, cB)
						else
							table.insert(info, {stuffToPrint, r, g, b, 255, 1, "default"})
						end
						counter = counter + 1
					end
				end
			end
		end

		if counter == 0 then
			if isOverlayDisabled then
				outputChatBox("-    Currently no members online.", thePlayer)
			else
				table.insert(info, {"-    Currently no members online.", 255, 255, 255, 255, 1, "default"})
			end
		end]]

		-- SCRIPTERS --
		if isOverlayDisabled then
			outputChatBox("YAZILIMCILAR:", thePlayer, 255, 194, 14)
		else
			table.insert(info, {"Yazılımcılar:", 255, 194, 14, 255, 1, "title"})
			table.insert(info, {""})
		end

		for k, arrayPlayer in ipairs(players) do
			local logged = getElementData(arrayPlayer, "loggedin")
			if logged == 1 then
				if exports.titan_integration:isPlayerScripter(arrayPlayer) then
					local hiddenAdmin = getElementData(arrayPlayer, "hiddenadmin")
					local adminTitle = getPlayerScripterRank( arrayPlayer )
					local stuffToPrint
					if (hiddenAdmin == 1) then
						stuffToPrint = "-    (Gizli) "..tostring(adminTitle).." "..exports.titan_global:getPlayerName(arrayPlayer).." ("..getElementData(arrayPlayer, "account:username")..")"
					else
						stuffToPrint = "-    "..tostring(adminTitle).." "..exports.titan_global:getPlayerName(arrayPlayer).." ("..getElementData(arrayPlayer, "account:username")..")"
					end
					if (hiddenAdmin == 0 or ( exports.titan_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerScripter(thePlayer) ) ) and not dvpUsernames[getElementData(arrayPlayer, "account:username")] then
						local r, g, b = 0, 255, 0 --hud colour
						local cR, cG, cB = 0, 200, 10 --chatbox colour
						if(hiddenAdmin == 1) then
							r, g, b = 200, 200, 200
							cR, cG, cB = 100, 100, 100
						end
						if isOverlayDisabled then
							outputChatBox(stuffToPrint, thePlayer, cR, cG, cB)
						else
							table.insert(info, {stuffToPrint, r, g, b, 255, 1, "default"})
						end
						counter = counter + 1
					end
				end
			end
		end

		if counter == 0 then
			if isOverlayDisabled then
				outputChatBox("-    Currently no scripters online.", thePlayer)
			else
				table.insert(info, {"-    Currently no scripters online.", 255, 255, 255, 255, 1, "default"})
			end
		end

	end

	if logged == 1 then
		if not isOverlayDisabled then
			exports.titan_hud:sendTopRightNotification(thePlayer, info, 350)
		end
	end
end
addCommandHandler("admins", showStaff, false, false)
addCommandHandler("gms", showStaff, false, false)
addCommandHandler("staff", showStaff, false, false)

function toggleOverlay(thePlayer, commandName)
	if getElementData(thePlayer, "hud:isOverlayDisabled") then
		setElementData(thePlayer, "hud:isOverlayDisabled", false)
		outputChatBox("You enabled overlay menus.",thePlayer)
	else
		setElementData(thePlayer, "hud:isOverlayDisabled", true)
		outputChatBox("You disabled overlay menus.", thePlayer)
	end
end
addCommandHandler("toggleOverlay", toggleOverlay, false, false)
addCommandHandler("togOverlay", toggleOverlay, false, false)
