-- Hanz

function vehKit(thePlayer)
	--[[
			local veh = getPedOccupiedVehicle(thePlayer)
			
			if (veh) then
						if not (veh) then
							outputChatBox("[-]#f9f9f9 Araçtan ayrıldığın için işlemin iptal edildi.", thePlayer, 255, 102, 102, true)
						return end
						
						if getElementData(thePlayer, "tamir:durum") then
							outputChatBox("[-]#f9f9f9 Aracın şu anda tamir ediliyor, lütfen sabırla bekle.", thePlayer, 255, 102, 102, true)
						return end
						if (getElementData(veh, "engine") == 1) then
								outputChatBox("[-]#f9f9f9 Tamir kitini kullanabilmen için aracının motorunu durdurman gerekiyor.",thePlayer,255,102,102,true)
						return end
					
						setTimer(function()
							
							if (getElementData(veh, "engine") == 1) then
								
								outputChatBox("[-]#f9f9f9 Aracın motorunu çalıştırdığın için aracın tamir edilemedi.",thePlayer, 255, 102, 102,true)
								
							return end
						
						fixVehicle(veh)
						setElementData(veh, "enginebroke", 0, true)
						outputChatBox("[-]#f9f9f9 Başarıyla aracınız tamir edildi, dikkatli kullanın.", thePlayer, 107, 156, 255, true)
						setElementFrozen(veh, false)
						setElementFrozen(thePlayer, false)
						if (getElementData(veh, "Impounded") == 0) then
							setVehicleDamageProof(veh, false)
							setElementData(veh, "engine", 0, false)
						end
						
						for i = 0, 5 do
							setVehicleDoorState(veh, i, 0)
						end
						
						exports.titan_logs:dbLog(thePlayer, 6, { thePlayer, veh  }, "TAMIR KITI")
						setElementData(thePlayer, "tamir:durum", false)
						end, 30000, 1) 
						setElementData(veh, "handbrake", 0, false)
						setElementData(thePlayer, "tamir:durum", true)
						outputChatBox("[-]#f9f9f9 Aracını tamir ediliyor, lütfen 30 saniye sabırla bekle.", thePlayer, 107, 156, 255,true)
						setElementFrozen(thePlayer, true)
						setElementFrozen(veh, true)
			else
				outputChatBox("[-]#f9f9f9 Bu işlemi yapabilmek için araçta olman gerekiyor.", thePlayer, 255, 102, 102, true)
			end
--]]
end
addEvent("tamir->aracTamirEt",true)
addEventHandler("tamir->aracTamirEt", root, vehKit)


function kitYardim(thePlayer)
outputChatBox("[-]#f9f9f9 Tamir kiti kullanırken aracınızın motorunu kapalı durumda olsun.",thePlayer,255,102,102,true)
outputChatBox("[-]#f9f9f9 Tamir kiti kullanırken aracınızı hareket ettirmeye çalışmayın.",thePlayer,255,102,102,true)
outputChatBox("-#f9f9f9 Başka bir sorun yok, iyi oyunlar.",thePlayer,255,102,102,true)

end
addCommandHandler("kityardim", kitYardim)