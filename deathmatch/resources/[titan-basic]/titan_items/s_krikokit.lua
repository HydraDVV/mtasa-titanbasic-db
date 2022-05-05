-- Hanz

function krikoKit(thePlayer)
	
			local veh = getPedOccupiedVehicle(thePlayer)

			if (veh) then
						if not (veh) then
							outputChatBox("[-]#f9f9f9 Araçtan ayrıldığın için işlemin iptal edildi.", thePlayer, 255, 102, 102, true)
						return end
						
						if getElementData(thePlayer, "kriko:durum") then
							outputChatBox("[-]#f9f9f9 Aracını çevirmek için krikonu kullanıyorsun, lütfen sabırla bekle.", thePlayer, 255, 102, 102, true)
						return end
					
						setTimer(function()
						
						local rx, ry, rz = getVehicleRotation(veh)
						setVehicleRotation(veh, 0, ry, rz)
						outputChatBox("[-]#f9f9f9 Başarıyla aracınız çevirildi, dikkatli kullanın.", thePlayer, 107, 156, 255, true)
						setElementFrozen(veh, false)
						setElementFrozen(thePlayer, false)
						
						setElementData(thePlayer, "kriko:durum", false)
						end, 15000, 1) 
						setElementData(thePlayer, "kriko:durum", true)
						outputChatBox("[-]#f9f9f9 Aracını çevirmek için kriko kullanıyorsun, lütfen 15 saniye sabırla bekle.", thePlayer, 107, 156, 255,true)
						setElementFrozen(thePlayer, true)
						setElementFrozen(veh, true)
			else
				outputChatBox("[-]#f9f9f9 Bu işlemi yapabilmek için araçta olman gerekiyor.", thePlayer, 255, 102, 102, true)
			end
end
addEvent("tamir->aracKrikoKit",true)
addEventHandler("tamir->aracKrikoKit", root, krikoKit)
