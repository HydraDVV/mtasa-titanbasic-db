Interaction.Interactions = {}

function addInteraction(type, model, name, image, executeFunction)
	if not Interaction.Interactions[type][model] then
		Interaction.Interactions[type][model] = {} 
	end
 
	table.insert(Interaction.Interactions[type][model], {name, image, executeFunction})
end

addEventHandler("onClientResourceStart", resourceRoot, function()

end)

addCommandHandler("iptal",
function()
	if getElementData(localPlayer, "degisdurum") then
		setElementData(localPlayer, "degisdurum", nil)
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Başarıyla işlemin iptal edildi.", 0, 255, 0, true)
	else
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Şu anda her hangi bir istekte bulunmamışsın.", 255, 0, 0, true)	
	end
end)

function getInteractions(element, durum)
	local interactions = {}
	local type = getElementType(element)
	local model = getElementModel(element)
		table.insert(interactions, {"Kapat", "icons/cross_x.png",
		function ()
			Interaction.Close()
		end
	})
	if durum == "home" then
		if getElementData(localPlayer, "loggedin") ~= 1 then return end					
		table.insert(interactions, {"Karakter Değiştir", "icons/tagok.png",
			function (player, target)
				if getElementData(localPlayer, "loggedin") ~= 1 then outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Giriş yapmadan karakterini değiştiremezsin.", 255, 0, 0, true) return end
				if getElementData(localPlayer, "dead") == 1 or getElementData(localPlayer, "isleme:durum") or getElementData(localPlayer, "kazma:durum") or getElementData(localPlayer, "tutun:durum") then 
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Bu durumdayken F10 Karakter Değiştir butonunu kullanamazsın.", 255, 14, 14 ,true) 
				return end
				if getElementData(localPlayer,"degisdurum") then 
					outputChatBox("[-]#f9f9f9 Şu anda zaten karakter değiştirme işlemini gerçekleştiriyorsun.", 255,0,0,true) 
				return end 
				
				
				triggerServerEvent("karakterDegistirmeStart", localPlayer)
				exports["titan_infobox"]:addBox("info", "20 saniye sonra karakter değiştirme ekranına gideceksin. İptal etmek için: /iptal")
				setElementData(localPlayer, "degisdurum", true)

				setTimer(function()
					if getElementData(localPlayer, "degisdurum") then
						triggerServerEvent("karakterDegistirme", localPlayer)
						setElementData(localPlayer, "degisdurum", nil)
						exports["titan_account"]:options_logOut(localPlayer)
					else
						outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Karakter değiştirme işlemini iptal ettiğinden dolayı işlemin gerçekleştirilmedi.", 255, 0, 0, true)
					end
				end, 20000, 1)
			end })
			

		table.insert(interactions, {"OOC Market", "icons/tl.png",
			function (player, target)
				executeCommandHandler("market")
			end })	

		if exports.titan_integration:isPlayerTrialAdmin(localPlayer) then 
		
		table.insert(interactions, {"Yetkili Arayüzü", "icons/tagok.png",
			function (player, target)
				executeCommandHandler("staffs")
			end })		

		table.insert(interactions, {"Araç Kütüphanesi", "icons/lock.png",
			function (player, target)
				triggerServerEvent("vehlib:sendLibraryToClient", localPlayer)
			end })	
		end
		
	return interactions end
		if type == "ped" then
		table.insert(interactions, {"Konuş", "icons/detector.png",
			function (player, target)
				triggerEvent("npc:konus",localPlayer,element)
			end
			
			
		})
	
		elseif type == "player" then
		
		table.insert(interactions, {"Karakter Bilgileri", "icons/eyemask.png",
			function (player, target)
				exports["titan_social"]:showPlayerInfo(target)
			end
		})		

		if exports["titan_social"]:isFriendOf(getElementData(element, "account:id")) then
			table.insert(interactions, {"Arkadaşlıktan Çıkar", "icons/delete.png",
				function (player, target)
					exports["titan_social"]:cremoveFriend(target)
				end
			})
		else
			table.insert(interactions, {"Arkadaş Ekle", "icons/add.png",
				function (player, target)
					exports["titan_social"]:caddFriend(target)
				end
			})
		end
		
		table.insert(interactions, {"Üst Ara", "icons/glass.png",
			function (player, target)
				exports["titan_social"]:cfriskPlayer(target)
			end
		})




		if getElementData(element, "restrain") == 0 then
			table.insert(interactions, {"Kelepçele", "icons/cuff.png",
				function (player, target)
					exports["titan_social"]:crestrainPlayer(target)
				end
			})
		else
			table.insert(interactions, {"Kelepçeyi Çıkar", "icons/uncuff.png",
				function (player, target)
					exports["titan_social"]:cunrestrainPlayer(target)
				end
			})
		end	
	elseif type == "vehicle" then
		table.insert(interactions, {"Araç Envanteri", "icons/trunk.png",
			function (player, target)
				--triggerServerEvent( "openFreakinInventory", player, element, 500, 500 )
				exports["titan_vehicle"]:requestInventory(target)
			end
		})

		table.insert(interactions, {"Kapı Kontrolü", "icons/doorcontrol.png",
			function (player, target)
				exports["titan_vehicle"]:fDoorControl(target)	
			end
		})
		
		table.insert(interactions, {"Araç Hoparlörü", "icons/test1.png",
			function (player, target)
				exports["titan_musicbox"]:fVehicleHoparlor(target)	
			end
		})		

		table.insert(interactions, {"Aracın İçine Gir", "icons/stair1.png",
			function (player, target)
				triggerServerEvent( "enterVehicleInterior", player, element)
	
			end
		})



        if getElementData(localPlayer, "job") == 5 then
			table.insert(interactions, {"Tamir Et & Geliştir", "icons/mechanic.png",
				function (player, target)
					exports["titan_vehicle"]:openMechanicWindow(target)
				end
			})
	    end

        if getElementData(localPlayer, "job") == 5 then
			table.insert(interactions, {"Mekanik Arayüzü", "icons/mechanic.png",
				function (player, target)
					triggerEvent("mechanic:gui", target, target)
				end
			})
	    end

	    if exports['titan_items']:hasItem(element, 117) then
			table.insert(interactions, {"Rampa", "icons/ramp.png",
				function (player, target)
					exports["titan_vehicle"]:toggleRamp(target)
				end
			})
	    end

	    if exports['titan_items']:hasItem(localPlayer, 57) then
			table.insert(interactions, {"Benzin Doldur", "icons/fuel.png",
				function (player, target)
					exports["titan_vehicle"]:fillFuelTank(target)
				end
			})
	    end


		if ( getPedSimplestTask(localPlayer) == "TASK_SIMPLE_CAR_DRIVE" and getPedOccupiedVehicle(localPlayer) == element ) then
			table.insert(interactions, {"Açıklama", "icons/info.png",
				function (player, target)
					if (getElementData(target, "dbid") > 0 ) then
						exports["titan_vehicle"]:fLook(target)
					end
				end
			})
	    end


	    if (exports.titan_global:isStaffOnDuty(localPlayer) and exports.titan_integration:isPlayerSeniorAdmin(localPlayer)) then
			table.insert(interactions, {"ADM: Respawn", "icons/adm.png",
				function (player, target)
					if (exports.titan_global:isStaffOnDuty(localPlayer) or exports.titan_integration:isPlayerScripter(localPlayer)) then
						exports["titan_vehicle"]:fRespawn(target)
					end
				end
			})
	    end

     	if (exports.titan_global:isStaffOnDuty(localPlayer) and exports.titan_integration:isPlayerSeniorAdmin(localPlayer)) then
			table.insert(interactions, {"ADM: Texture", "icons/adm.png",
				function (player, target)
     	if exports.titan_integration:isPlayerSeniorAdmin(localPlayer) then
						exports["titan_vehicle"]:fTextures(target)
					end
				end
			})
	    end	    

		if getElementData(element, "isFuelPump") then
			local tempActions = exports["titan_fuel-system"]:getCurrentInteractionList(model)

			for k,v in pairs(tempActions) do
				table.insert(interactions, v)
			end

			tempActions = nil
		
		end
	end

	return interactions
end


function isFriendOf( accountID )
	for _, data in ipairs( {online, offline} ) do
		for k, v in ipairs( data ) do
			if v.accountID == accountID then
				return true
			end
		end
	end
	return false
end