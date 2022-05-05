function getNearbyElements(root, type, distance)
	local x, y, z = getElementPosition(root)
	local elements = {}
	
	if getElementType(root) == "player" and exports['titan_freecam']:isPlayerFreecamEnabled(root) then return elements end
	
	for index, nearbyElement in ipairs(getElementsByType(type)) do
		if isElement(nearbyElement) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyElement)) < ( distance or 20 ) then
			if getElementDimension(root) == getElementDimension(nearbyElement) then
				table.insert( elements, nearbyElement )
			end
		end
	end
	return elements
end

local gpn = getPlayerName
function getPlayerName(p)
	local name = getElementData(p, "fakename") or gpn(p) or getElementData(p, "name")
	return string.gsub(name, "_", " ")
end

function sendWrnToStaff(msg, prefix1, r1, g1, b1, toScripters)
	if msg then
		local r, g, b = (r1 or 255), (g1 or 0) , (b1 or 0)
		local prefix = prefix1 and ("["..prefix1.."] ") or ""
		local players = getElementsByType("player")
		for i, player in pairs(players) do
			if exports.titan_global:isStaff(player) or (toScripters and exports.titan_integration:isPlayerScripter(player)) then
				if getElementData(player, "loggedin") == 1 then
					if getElementData(player, "report_panel_mod") == "2" or getElementData(player, "report_panel_mod") == "3" then
						exports["titan_reports"]:showToAdminPanel(prefix..msg, player, r, g, b)
					else
						if getElementData(player, "wrn:style") == 1 then
							triggerClientEvent(player, "sendWrnMessage", player, prefix..msg)
						else
							outputChatBox(prefix..msg, player, r, g, b)
						end
					end
				end
			end
		end
	end
end

function sendWrnToStaffOnDuty(msg, prefix1, r1, g1, b1)
	if msg then
		local r, g, b = (r1 or 255), (g1 or 0) , (b1 or 0)
		local prefix = prefix1 and ("["..prefix1.."] ") or ""
		local players = getElementsByType("player")
		for i, player in pairs(players) do
			if exports.titan_global:isStaffOnDuty(player) then
				if getElementData(player, "loggedin") == 1 then
					if getElementData(player, "report_panel_mod") == "2" or getElementData(player, "report_panel_mod") == "3" then
						exports["titan_reports"]:showToAdminPanel(prefix..msg, player, r, g, b)
					else
						if getElementData(player, "wrn:style") == 1 then
							triggerClientEvent(player, "sendWrnMessage", player, prefix..msg)
						else
							outputChatBox(prefix..msg, player, r, g, b)
						end
					end
				end
			end
		end
	end
end

function getPlayerFullIdentity(thePlayer, type, doNotUseFakeName)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "player" then
		return "Unknown person"
	end
	if not type then --For common chat channels | (id) Rank Username Characrtername
		local hidden = getElementData(thePlayer, "hiddenadmin")
		if hidden == 1 and exports.titan_integration:isPlayerSeniorAdmin(thePlayer) then
			return "Gizli Görevli"
		else
			local playerid = getElementData(thePlayer, "playerid")
			local rank = "Player"
			local username = getElementData(thePlayer, "account:username")
			local characterName = doNotUseFakeName and string.gsub(gpn(thePlayer), "_", " ") or getPlayerName(thePlayer)
			if exports.titan_integration:isPlayerIA( thePlayer ) then
				rank = "Internal Affairs"
			elseif exports.titan_integration:isPlayerTrialAdmin(thePlayer) then
				rank = getAdminTitles()[getPlayerAdminLevel(thePlayer)]
			elseif exports.titan_integration:isPlayerSupporter(thePlayer) then
				rank = "Rehber"
			elseif exports.titan_integration:isPlayerScripter(thePlayer) then 
				rank = "Scripter"
			elseif exports.titan_integration:isPlayerVCTMember(thePlayer) then 
				rank = "VCT"
			elseif exports.titan_integration:isPlayerMappingTeamMember(thePlayer) then 
				rank = "Mapper"
			else
				local hasAccess, isEnabled = exports.titan_donators:hasPlayerPerk(thePlayer, 10)
				if hasAccess and tonumber(isEnabled) ~= 0 then
					rank = "Donor"
				else
					rank = "Player"
				end
			end -- Hanz
			return "("..playerid..") "..rank.." "..characterName
		end
	elseif type == 1 then --Rank Username (Use for achievement system)
		local rank = false
		local username = getElementData(thePlayer, "account:username")
		if exports.titan_integration:isPlayerTrialAdmin(thePlayer) then
			rank = getAdminTitles()[getPlayerAdminLevel(thePlayer)]
		elseif exports.titan_integration:isPlayerSupporter(thePlayer) then
			rank = "Rehber"
		end
		
		if rank then
			return rank.." "..username
		else
			return username
		end
	elseif type == 2 then --Rank Username
		local rank = "Player"
		local username = getElementData(thePlayer, "account:username")
		local characterName = doNotUseFakeName and string.gsub(gpn(thePlayer), "_", " ") or getPlayerName(thePlayer)
		if exports.titan_integration:isPlayerTrialAdmin(thePlayer) then
			rank = getAdminTitles()[getPlayerAdminLevel(thePlayer)]
		elseif exports.titan_integration:isPlayerSupporter(thePlayer) then
			rank = "Rehber"
		elseif exports.titan_integration:isPlayerScripter(thePlayer) then 
			rank = "Scripter"
		else
			local hasAccess, isEnabled = exports.titan_donators:hasPlayerPerk(thePlayer, 10)
			if hasAccess and tonumber(isEnabled) ~= 0 then
				rank = "Donor"
			else
				rank = "Player"
			end
		end
		
		return
	elseif type == 3 then --(id) Rank Username (Charactername) | (Use for admin system)
		local playerid = getElementData(thePlayer, "playerid")
		local rank = ""
		local username = getElementData(thePlayer, "account:username")
		local characterName = doNotUseFakeName and string.gsub(gpn(thePlayer), "_", " ") or getPlayerName(thePlayer)
		if exports.titan_integration:isPlayerIA( thePlayer ) then
			rank = "Internal Affairs"
		elseif exports.titan_integration:isPlayerTrialAdmin(thePlayer) then
			rank = getAdminTitles()[getPlayerAdminLevel(thePlayer)]
		elseif exports.titan_integration:isPlayerSupporter(thePlayer) then
			rank = "Rehber"
		elseif exports.titan_integration:isPlayerScripter(thePlayer) then 
			rank = "Scripter"
		elseif exports.titan_integration:isPlayerVCTMember(thePlayer) then 
			rank = "VCT"
		elseif exports.titan_integration:isPlayerMappingTeamMember(thePlayer) then 
			rank = "Mapper"
		end
		
		return "["..playerid.."] "..rank.." "..username.." ("..characterName..")"
	end
end


local firstName = { "Kerem","Mehmet","Can","Teoman","Sehmus","Tunahan","Alp","Emircan","Remzican","Burak","Ege","Furkan","Mert","Faruk","Eymen","Atahan","Berkcan","Berke","Kemal","Alper", "Harun", "Huseyin", "Abdullah", "", "Necati", "Tamer", "Kadir", "Umutcan", "Melih", "Yunus", "Emre", "Enes", "Ersin", "Eren", "Mucahit", "Erdem"}
local lastName = { "Karaca","Akgul","Demir","Hunsoy","Demirci","Yiginli","Sune","Yaman","Mutlu","Sargin","Cakir","Ilgar","Kivanc","Usakligil","Yilmaz","Yilmazer","Guler","Dogan","Kahveci","Ergun", "Ziya", "Kor", "Celik", "Cetin", "Marti", "Kilic", "Yesildag", "Uslu", "Kus", "Uzuner", "Uzun", "Candan", "Ercetin", "Arslan", "Aslan", "Erarslan", "Kemal", "Ulusoy", "Gursoy", "Cilek", "Corbaci" }

function createRandomMaleName()
	local random1 = math.random(1, #firstName)
	local random2 = math.random(1, #lastName)
	local name = firstName[random1].." "..randomLetter()..". "..lastName[random2]
	local ciftisim = math.random(1,2)
	--if ciftisim == 1 then
	--	return exports["titan_ped"]:getRandomName("first", "male") .. " " .. exports["titan_ped"]:getRandomName("first", "male") .. " " .. exports["titan_ped"]:getRandomName("last", "male")--name
	--else
		return exports["titan_ped"]:getRandomName("full", "male")--name
	--end
end

function randomLetter()
	return string.upper(string.char(math.random(97, 122)));
end