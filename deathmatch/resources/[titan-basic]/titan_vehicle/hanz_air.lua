function Suspensao1(player)
        local vehicle = getPedOccupiedVehicle(player)
                if not vehicle then return end
				if not exports.titan_global:takeMoney(player, 15000) then exports["titan_infobox"]:addBox(player, "error", "Yeterli paranız yok. ($15.000)") return end
                setVehicleHandling ( vehicle, "suspensionLowerLimit", (getVehicleHandling(vehicle)['suspensionLowerLimit'])-0.1 )
				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9Aracı başarıyla kaldırdın.", player, 255, 250, 250,true)
				exports["titan_infobox"]:addBox(player, "buy", "Aracı başarıyla $15.000 karşılığında 5 cm yükselttin.")
end
addCommandHandler("aracyukselt", Suspensao1)


function Suspensao2(player)
        local vehicle = getPedOccupiedVehicle(player)
                if not vehicle then return end
				if not exports.titan_global:takeMoney(player, 15000) then exports["titan_infobox"]:addBox(player, "error", "Yeterli paranız yok. ($15.000)") return end
                setVehicleHandling ( vehicle, "suspensionLowerLimit", (getVehicleHandling(vehicle)['suspensionLowerLimit'])+0.1 )
 				outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9Aracı başarıyla bastın.", player, 255, 250, 255,true)
				exports["titan_infobox"]:addBox(player, "buy", "Aracı başarıyla $15.000 karşılığında 5 cm bastın.")
end
addCommandHandler("aracbas", Suspensao2)
