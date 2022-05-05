local miktar = 2450

function trashparaVer(thePlayer)
	if getElementData(thePlayer, "vipver") == 1 then
	miktar = 3500
	elseif getElementData(thePlayer, "vipver") == 2 then
	miktar = 4550
	elseif getElementData(thePlayer, "vipver") == 3 then
	miktar = 5600
	elseif getElementData(thePlayer, "vipver") == 4 then
	miktar = 6650
	end
	exports.titan_global:giveMoney(thePlayer, miktar)
	outputChatBox("#822828"..exports["titan_pool"]:getServerName()..": #FFFFFFTebrikler, bu turdan $"..miktar.." kazandınız!", thePlayer, 0, 255, 0, true) -- 520
end
addEvent("trashparaVer", true)
addEventHandler("trashparaVer", getRootElement(), trashparaVer)

function trashBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, 1661.994140625, -1882.75, 13.546875)
	setElementRotation(thePlayer, 0, 0, 270.43533325195)
end
addEvent("trashBitir", true)
addEventHandler("trashBitir", getRootElement(), trashBitir)