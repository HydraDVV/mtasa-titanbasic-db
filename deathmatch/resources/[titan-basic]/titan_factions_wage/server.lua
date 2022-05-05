local function addBox(p, boxtype, msg)
	exports['titan_infobox']:addBox(p, boxtype, msg)
end

local function chat(p, msg, r, g, b)
	outputChatBox(msg, p, r, g, b, true)
end

_wageFactions = function(p)
	local playerFaction = p:getData("faction")
	local theTeam = getPlayerTeam(p)
	local factionType = theTeam:getData("type")
	
	if playerFaction > 0 then
		if factionType == 2 or factionType == 3 or factionType == 4 or factionType == 5 or factionType == 6 or factionType == 7 then
			local wages = theTeam:getData("wages")
			local money = theTeam:getData("money")
			local factionRank = p:getData("factionrank")
			local rankWage = tonumber(wages[factionRank])
				
			if exports['titan_global']:takeMoney(theTeam, rankWage) then
				addBox(p, "buy", "Birlik maaşın yatırıldı. Toplam: +$"..rankWage)
				exports['titan_global']:giveMoney(p, rankWage)
			else
				addBox(p, "error", "Birlik maaşın yatırılamadı. Birliğinin ekonomisi çökmek üzere.")
			end
		end
	end
end
addEvent("wage:faction", true)
addEventHandler("wage:faction", root, _wageFactions)