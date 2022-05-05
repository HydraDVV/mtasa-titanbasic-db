local mysql = exports.titan_mysql


ped = createPed(16, -1070.65625, 422.1318359375, 14.539632797241)
setElementFrozen(ped, true)
setElementRotation(ped, 0, 0, 130)
setElementData(ped, "hediye:npc", true)


ped2 = createPed(45, -1069.1025390625, 415.35546875, 14.468962669373)
setElementFrozen(ped2, true)
setElementRotation(ped2, 0, 0, 42)
setElementData(ped2, "hediyebulundu:npc", true)

function gizemBulundu(thePlayer)
exports["titan_infobox"]:addBox(thePlayer, "success", "Başarıyla şüpheli şahısı buldun.")
exports["titan_global"]:giveMoney(thePlayer, 10000)
end
addEvent("gizemliFinish", true)
addEventHandler("gizemliFinish", root, gizemBulundu)

