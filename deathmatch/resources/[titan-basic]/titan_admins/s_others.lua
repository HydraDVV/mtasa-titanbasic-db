-- Hanz 19 mayıs
function getKey(thePlayer, commandName)
	if exports.titan_integration:isPlayerHeadAdmin(thePlayer) then
		local adminName = getPlayerName(thePlayer):gsub(" ", "_")
		local veh = getPedOccupiedVehicle(thePlayer)
		if veh then
			local vehID = getElementData(veh, "dbid")
			
			givePlayerItem(thePlayer, "giveitem" , adminName, "3" , tostring(vehID))
			
			return true
		else
			local intID = getElementDimension(thePlayer)
			if intID then
				local foundIntID = false
				local keyType = false
				local possibleInteriors = getElementsByType("interior")
				for _, theInterior in pairs (possibleInteriors) do
					if getElementData(theInterior, "dbid") == intID then
						local intType = getElementData(theInterior, "status")[1] 
						if intType == 0 or intType == 2 or intType == 3 then
							keyType = 4 --Yellow key
						else
							keyType = 5 -- Pink key
						end
						foundIntID = intID
						break
					end
				end
				
				if foundIntID and keyType then
					givePlayerItem(thePlayer, "giveitem" , adminName, tostring(keyType) , tostring(foundIntID))
					
					return true
				else
					outputChatBox(" You're not in any vehicle or possible interior.", thePlayer, 255,0 ,0 )
					return false
				end
			end
		end
	end
end
addCommandHandler("getkey", getKey, false, false)

function generateFakeIdentity(player, cmd)
	local birlik = getElementData(player, "faction")
	if birlik == 4 then
		if getElementData(player, "fakename") then
			exports.titan_anticheat:changeProtectedElementDataEx(player, "fakename", false, true)
			exports["titan_infobox"]:addBox(player, "error", "Sahte kimliğini sildin.")
			return false
		end
		
		local name = exports.titan_global:createRandomMaleName()
		
		exports.titan_anticheat:changeProtectedElementDataEx(player, "fakename", name, true)
		exports["titan_infobox"]:addBox(player, "success", "Başarıyla sahte kimliğini aktif ettin.")
		triggerEvent("fakemyid", player)
	end
end
addCommandHandler("sahtekimlik", generateFakeIdentity, false, false)

function setSvPassword(thePlayer, commandName, password)
	if exports.titan_integration:isPlayerHeadAdmin(thePlayer)	then
		outputChatBox("Kullanım: /" .. commandName .. " [Sunucu Şifresi] - Boş bırakırsanız sunucu şifresini kaldırır.", thePlayer, 255, 194, 14)
		if password and string.len(password) > 0 then
			if setServerPassword(password) then
				exports.titan_global:sendMessageToStaff("[SYSTEM] "..exports.titan_global:getPlayerFullIdentity(thePlayer).." isimli yetkili sunucu şifresini '"..password.."' olarak ayarladı.", true)
			end
		else
			if setServerPassword('') then
				exports.titan_global:sendMessageToStaff("[SYSTEM] "..exports.titan_global:getPlayerFullIdentity(thePlayer).." isimli yetkili sunucu şifresini kaldırdı.", true)
			end
		end
	end
end
addCommandHandler("setserverpassword", setSvPassword, false, false)
addCommandHandler("setserverpw", setSvPassword, false, false)


