local miktar = 600

function cpay(thePlayer)
	if getElementData(thePlayer, "vipver") == 1 then
	miktar = 650
	elseif getElementData(thePlayer, "vipver") == 2 then
	miktar = 700
	elseif getElementData(thePlayer, "vipver") == 3 then
	miktar = 750
	elseif getElementData(thePlayer, "vipver") == 4 then
	miktar = 800
	end
	exports.titan_global:giveMoney(thePlayer, miktar)
	exports["titan_infobox"]:addBox(thePlayer, "buy", "Tebrikler başarıyla meslekten $"..miktar.." kazandın.")
end
addEvent("cigar:pay", true)
addEventHandler("cigar:pay", getRootElement(), cpay)

function cstopJob(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, -79.2197265625, -1203.4365234375, 2.890625)
	setElementRotation(thePlayer, 0, 0, 70.11743164063)
end
addEvent("cigar:exitVeh", true)
addEventHandler("cigar:exitVeh", getRootElement(), cstopJob)