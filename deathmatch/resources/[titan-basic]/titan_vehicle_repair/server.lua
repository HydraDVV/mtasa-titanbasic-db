local aractamiryeri = createColSphere (1911.2216796875, -1776.3671875, 13.3828125, 7)
function aractamir(thePlayer)
local bir = "100"
local bir2 = "125"
local bir3 = "175"
local bir4 = "225"
local bir5 = "275"
local bir6 = "325"
local bir7 = "375"
local bir8 = "425"
local bir9 = "475"
local bir10 = "525"
	if (isElementWithinColShape(thePlayer, aractamiryeri)) then
local vehicle= getPedOccupiedVehicle(thePlayer)
local fact = getElementData(vehicle, "faction")
        if ( vehicle ) then
			if fact == 1 then
				fixVehicle(vehicle)
		        playSoundFrontEnd(thePlayer, 46)
				for i = 0, 5 do
					setVehicleDoorState(vehicle, i, 0)
				end
				outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9  #ffffffAracınız başarılı bir şekilde tamir edildi.",thePlayer,30,30,30,true)
			return end
			if (getElementHealth(vehicle) >= 1000) then		
			outputChatBox("#cc0000[!]#ffffffAracınızda hasar yok.", thePlayer, 255, 255, 255, true)
			elseif (getElementHealth(vehicle) >= 900) then
			                    if 	exports.titan_global:takeMoney(thePlayer, bir) then
								fixVehicle(vehicle)
		                        playSoundFrontEnd(thePlayer, 46)
								for i = 0, 5 do
							    setVehicleDoorState(vehicle, i, 0)
							--	outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9  #ffffffAracınız başarılı bir şekilde tamir edildi."thePlayer,30,30,30,true)
								end
								outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9  #ffffffAracınız başarılı bir şekilde tamir edildi.",thePlayer,30,30,30,true)
						        
								else
								outputChatBox("#cc0000[!]#ffffffYeterli miktarda paranız yok.", thePlayer, 255, 255, 255, true)
								end
			elseif  (getElementHealth(vehicle) >= 800) then
			                    if 	exports.titan_global:takeMoney(thePlayer, bir2) then
								fixVehicle(vehicle)
		                        playSoundFrontEnd(thePlayer, 46)
								for i = 0, 5 do
							    setVehicleDoorState(vehicle, i, 0)
							--	outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9  #ffffffAracınız başarılı bir şekilde tamir edildi."thePlayer,30,30,30,true)
							end
								outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9  #ffffffAracınız başarılı bir şekilde tamir edildi.",thePlayer,30,30,30,true)
						        
								else
outputChatBox("#cc0000[!]#ffffffYeterli miktarda paranız yok.", thePlayer, 255, 255, 255, true)
								end
			elseif  (getElementHealth(vehicle) >= 700) then
			                    if 	exports.titan_global:takeMoney(thePlayer, bir3) then
								fixVehicle(vehicle)
		                        playSoundFrontEnd(thePlayer, 46)
								for i = 0, 5 do
							    setVehicleDoorState(vehicle, i, 0)
							    end
																outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9  #ffffffAracınız başarılı bir şekilde tamir edildi.",thePlayer,30,30,30,true)
						        
								else
outputChatBox("#cc0000[!]#ffffffYeterli miktarda paranız yok.", thePlayer, 255, 255, 255, true)
								end					
			elseif  (getElementHealth(vehicle) >= 600) then
			                    if 	exports.titan_global:takeMoney(thePlayer, bir4) then
								fixVehicle(vehicle)
		                        playSoundFrontEnd(thePlayer, 46)
								for i = 0, 5 do
							    setVehicleDoorState(vehicle, i, 0)
							    end
																outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9  #ffffffAracınız başarılı bir şekilde tamir edildi.",thePlayer,30,30,30,true)
						        
								else
outputChatBox("#cc0000[!]#ffffffYeterli miktarda paranız yok.", thePlayer, 255, 255, 255, true)
								end
			elseif  (getElementHealth(vehicle) >= 500) then
			                    if 	exports.titan_global:takeMoney(thePlayer, bir5) then
								fixVehicle(vehicle)
		                        playSoundFrontEnd(thePlayer, 46)
								for i = 0, 5 do
							    setVehicleDoorState(vehicle, i, 0)
							    end
																outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9  #ffffffAracınız başarılı bir şekilde tamir edildi.",thePlayer,30,30,30,true)
						        
								else
outputChatBox("#cc0000[!]#ffffffYeterli miktarda paranız yok.", thePlayer, 255, 255, 255, true)
								end
			elseif  (getElementHealth(vehicle) >= 400) then
			                    if 	exports.titan_global:takeMoney(thePlayer, bir6) then
								fixVehicle(vehicle)
		                        playSoundFrontEnd(thePlayer, 46)
								for i = 0, 5 do
							    setVehicleDoorState(vehicle, i, 0)
							    end
																outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9  #ffffffAracınız başarılı bir şekilde tamir edildi.",thePlayer,30,30,30,true)
						        
								else
outputChatBox("#cc0000[!]#ffffffYeterli miktarda paranız yok.", thePlayer, 255, 255, 255, true)
								end
			elseif  (getElementHealth(vehicle) >= 300) then
			                    if 	exports.titan_global:takeMoney(thePlayer, bir7) then
								fixVehicle(vehicle)
		                        playSoundFrontEnd(thePlayer, 46)
								for i = 0, 5 do
							    setVehicleDoorState(vehicle, i, 0)
							    end
																outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9  #ffffffAracınız başarılı bir şekilde tamir edildi.",thePlayer,30,30,30,true)
						        
								else
outputChatBox("#cc0000[!]#ffffffYeterli miktarda paranız yok.", thePlayer, 255, 255, 255, true)
								end
			elseif  (getElementHealth(vehicle) >= 200) then
			                    if 	exports.titan_global:takeMoney(thePlayer, bir8) then
								fixVehicle(vehicle)
		                        playSoundFrontEnd(thePlayer, 46)
								for i = 0, 5 do
							    setVehicleDoorState(vehicle, i, 0)
							    end
																outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9  #ffffffAracınız başarılı bir şekilde tamir edildi.",thePlayer,30,30,30,true)
						        
								else
outputChatBox("#cc0000[!]#ffffffYeterli miktarda paranız yok.", thePlayer, 255, 255, 255, true)
								end	
			elseif  (getElementHealth(vehicle) >= 100) then
			                    if 	exports.titan_global:takeMoney(thePlayer, bir9) then
								fixVehicle(vehicle)
		                        playSoundFrontEnd(thePlayer, 46)
								for i = 0, 5 do
							    setVehicleDoorState(vehicle, i, 0)
							    end
																outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9  #ffffffAracınız başarılı bir şekilde tamir edildi.",thePlayer,30,30,30,true)
						        
								else
outputChatBox("#cc0000[!]#ffffffYeterli miktarda paranız yok.", thePlayer, 255, 255, 255, true)
								end
			elseif  (getElementHealth(vehicle) >= 0) then
			                    if 	exports.titan_global:takeMoney(thePlayer, bir10) then
								fixVehicle(vehicle)
		                        playSoundFrontEnd(thePlayer, 46)
								for i = 0, 5 do
							    setVehicleDoorState(vehicle, i, 0)
							    end
																outputChatBox(""..exports["titan_pool"]:getServerName()..":#f9f9f9  #ffffffAracınız başarılı bir şekilde tamir edildi.",thePlayer,30,30,30,true)
						        
								else
outputChatBox("#cc0000[!]#ffffffYeterli miktarda paranız yok.", thePlayer, 255, 255, 255, true)
								end
end
end
end
end								
addCommandHandler("tamiret",aractamir)