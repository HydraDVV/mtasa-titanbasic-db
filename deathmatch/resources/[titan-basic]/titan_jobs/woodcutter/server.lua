local price = 850

function cpay(thePlayer)
	if getElementData(thePlayer, "vipver") == 1 then
		price = 900
	elseif getElementData(thePlayer, "vipver") == 2 then
		price = 950
	elseif getElementData(thePlayer, "vipver") == 3 then
		price = 1000
	elseif getElementData(thePlayer, "vipver") == 4 then
		miktar = 1050
	end
	exports.titan_global:giveMoney(thePlayer, price)
	exports["titan_infobox"]:addBox(thePlayer, "buy", "Tebrikler, başarıyla odunculuk mesleğinden $"..price.." kazandın.")
end
addEvent("wooder:pay", true)
addEventHandler("wooder:pay", getRootElement(), cpay)

function cstopJob(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, -345.2177734375, -1048.18359375, 59.281131744385)
	setElementRotation(thePlayer, 0, 0, 180)
end
addEvent("wooder:exitVeh", true)
addEventHandler("wooder:exitVeh", getRootElement(), cstopJob)