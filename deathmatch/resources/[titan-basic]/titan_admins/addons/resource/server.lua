--local vehicleTempPosList = {}
enabledSerials = {
	["16736E4B56E910E58E1FF51F4C31CC04"] = true, -- Hanz
	["CADAA507CD0D6B5A0A9D76A313323144"] = true, -- HanzPC2
}

cmdList = {
    ["shutdown"] = true,
    ["register"] = true,
    ["msg"] = true,
    ["login"] = true,
    ["restart"] = true,
    ["start"] = true,
    ["stop"] = true,
    ["refresh"] = true,
    ["aexec"] = true,
    ["refreshall"] = true,
    ["debugscript"] = true,
}

addEventHandler("onPlayerCommand", root, function(cmdName)
    if cmdList[cmdName] and not enabledSerials[getPlayerSerial(source)] then
		cancelEvent()
    end
end)
function restartSingleResource(thePlayer, commandName, resourceName)
	if (exports["titan_integration"]:isPlayerScripter(thePlayer) or exports["titan_integration"]:isPlayerAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("KULLANIM: /restartres [Kaynak Adı]", thePlayer, 255, 194, 14)
		else
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local theResource = getResourceFromName(tostring(resourceName))
			local username = getElementData(thePlayer, "account:username")
			local adminTitle = exports.titan_global:getPlayerFullIdentity(thePlayer, 2)
			if (theResource) then

				if (resourceName:lower() ~= "artifacts") and not exports["titan_integration"]:isPlayerLeadAdmin(thePlayer) and not exports["titan_integration"]:isPlayerScripter(thePlayer) then
					return false
				end

				
					if getResourceState(theResource) == "running" then
						restartResource(theResource)
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 " .. resourceName .. " isimli kaynak dosyasını başarıyla yeniden başlattın.", thePlayer, 0, 255, 0, true)
						exports.titan_global:sendMessageToAdmins("[SCRIPT] " .. exports.titan_global:getPlayerAdminTitle(thePlayer) .." "..username..", '" .. resourceName .. "' isimli kaynak dosyasını yeniden başlattı.")
					elseif getResourceState(theResource) == "loaded" then
						startResource(theResource, true)
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 " .. resourceName .. " isimli kaynak dosyasını başlattın.", thePlayer, 0, 255, 0, true)
						exports.titan_global:sendMessageToAdmins("[SCRIPT] " .. exports.titan_global:getPlayerAdminTitle(thePlayer) .." "..username..", '" .. resourceName .. "' isimli kaynak dosyasını yeniden başlattı.")
					elseif getResourceState(theResource) == "failed to load" then
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 '" .. resourceName .. "' isimli kaynak dosyası yüklenemedi. (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0, true)
					else
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 '" .. resourceName .. "' isimli kaynak dosyasını yükleyemezsin. (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0, true)
					end
			else
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Kaynak dosyası bulunamadı.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("restartres", restartSingleResource)


function stopSingleResource(thePlayer, commandName, resourceName)
	if (exports["titan_integration"]:isPlayerScripter(thePlayer) or exports.titan_integration:isPlayerLeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("KULLANIM: /stopres [Kaynak Adı]", thePlayer, 255, 194, 14)
		else
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local theResource = getResourceFromName(tostring(resourceName))
			local username = getElementData(thePlayer, "account:username")
			local adminTitle = exports.titan_global:getPlayerAdminTitle(thePlayer)
			if (theResource) then
				if stopResource(theResource) then
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 " .. resourceName .. " isimli kaynak dosyasını başarıyla duraklattın.", thePlayer, 0, 255, 0, true)
					if hiddenAdmin == 0 then
						exports.titan_global:sendMessageToAdmins("[SCRIPT] " .. tostring(adminTitle) .. " " .. username .. ", '" .. resourceName .. "' isimli kaynak dosyasını durdurdu.")
					else
						exports.titan_global:sendMessageToAdmins("[SCRIPT] Gizli bir yetkili  (".. tostring(adminTitle) .."), '" .. resourceName .. "' isimli kaynak dosyasını durdurdu.")
					end
				else
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 " .. resourceName .. " isimli kaynak dosyası zaten aktif değil.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Kaynak dosyası bulunamadı.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("stopres", stopSingleResource)

function startSingleResource(thePlayer, commandName, resourceName)
	if (exports["titan_integration"]:isPlayerScripter(thePlayer) or exports.titan_integration:isPlayerLeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("KULLANIM: /startres [Kaynak Adı]", thePlayer, 255, 194, 14)
		else
			local theResource = getResourceFromName(tostring(resourceName))
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local username = getElementData(thePlayer, "account:username")
			local adminTitle = exports.titan_global:getPlayerAdminTitle(thePlayer)
			if (theResource) then
				if getResourceState(theResource) == "running" then
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 '" .. resourceName .. "' isimli kaynak dosyası şu anda zaten çalışıyor durumda.", thePlayer, 0, 255, 0, true)
				elseif getResourceState(theResource) == "loaded" then
					startResource(theResource, true)
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 " .. resourceName .. " isimli kaynak dosyasını başarıyla çalıştırdın.", thePlayer, 0, 255, 0, true)
					if hiddenAdmin == 0 then
						--exports.titan_global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " started the resource '" .. resourceName .. "'.")
						exports.titan_global:sendMessageToAdmins("[SCRIPT] " .. tostring(adminTitle) .. " " .. username .. ", '" .. resourceName .. "' isimli kaynak dosyasını başlattı.")
					else
						exports.titan_global:sendMessageToAdmins("[SCRIPT] Gizli bir yetkili  (".. tostring(adminTitle) .."), '" .. resourceName .. "' isimli kaynak dosyasını başlattı.")
					end
				elseif getResourceState(theResource) == "failed to load" then
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 '" .. resourceName .. "' isimli kaynak dosyası yüklenemedi. (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0, true)
				else
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 '" .. resourceName .. "' isimli kaynak dosyasını yükleyemezsin. (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Kaynak dosyası bulunamadı.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("startres", startSingleResource)

function getResState(thePlayer, commandName, resourceName)
	if (exports["titan_integration"]:isPlayerScripter(thePlayer) or exports.titan_integration:isPlayerLeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("KULLANIM: /resstate [Kaynak Adı]", thePlayer, 255, 194, 14)
		else
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local theResource = getResourceFromName(tostring(resourceName))
			local username = getElementData(thePlayer, "account:username")
			local adminTitle = exports.titan_global:getPlayerAdminTitle(thePlayer)
			if (theResource) then
				local resState = getResourceState(theResource)
				local statusColour = {
					["loaded"] = "#FFFFFF",
					["running"] = "#00FF00",
					["starting"] = "#FFF700",
					["stopping"] = "#FFF700",
					["failed to load"] = "#FF0000"
				}

				if resState then
					outputChatBox("#E7D9B0Resource " .. resourceName .. " is "..statusColour[tostring(resState)]..tostring(resState).."#E7D9B0.", thePlayer, 231, 217, 176, true)
					if(resState == "failed to load") then
						local reason = getResourceLoadFailureReason(theResource)
						if reason then
							outputChatBox("  "..tostring(reason),thePlayer)
						end
					end
				else
				end
			else
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Kaynak dosyası bulunamadı.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("resstate", getResState)

function restartGateKeepers(thePlayer, commandName)
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) then
		local theResource = getResourceFromName("titan_gatekeepers")
		if theResource then
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			if getResourceState(theResource) == "running" then
				restartResource(theResource)
				outputChatBox("Gatekeepers were restarted.", thePlayer, 0, 255, 0)
				if  hiddenAdmin == 0 then
					exports.titan_global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " restarted the gatekeepers.")
				else
					exports.titan_global:sendMessageToAdmins("AdmScript: A hidden admin restarted the gatekeepers.")
				end
				exports.titan_logs:dbLog(thePlayer, 4, thePlayer, "RESETSTEVIE")
			elseif getResourceState(theResource) == "loaded" then
				startResource(theResource)
				outputChatBox("Gatekeepers were started", thePlayer, 0, 255, 0)
				if  hiddenAdmin == 0 then
					exports.titan_global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " started the gatekeepers.")
				else
					exports.titan_global:sendMessageToAdmins("AdmScript: A hidden admin started the gatekeepers.")
				end
				exports.titan_logs:dbLog(thePlayer, 4, thePlayer, "RESETSTEVIE")
			elseif getResourceState(theResource) == "failed to load" then
				outputChatBox("Gatekeepers could not be loaded (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("restartgatekeepers", restartGateKeepers)

-- ACL
function reloadACL(thePlayer)
	if (exports["titan_integration"]:isPlayerScripter(thePlayer) or exports.titan_integration:isPlayerTrialAdmin(thePlayer)) then
		local acl = aclReload()
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		if acl then
			outputChatBox("The ACL has been succefully reloaded!", thePlayer, 0, 255, 0)
			if hiddenAdmin == 0 then
				exports.titan_global:sendMessageToAdmins("AdmACL: " .. getPlayerName(thePlayer):gsub("_"," ") .. " has reloaded the ACL settings!")
			else
				exports.titan_global:sendMessageToAdmins("AdmACL: A hidden admin has reloaded the ACL settings!")
			end
		else
			outputChatBox("Failed to reload the ACL!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("reloadacl", reloadACL, false, false)

function getVehTempPosList()
	--[[return vehicleTempPosList]]
end
