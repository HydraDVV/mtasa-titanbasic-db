wPedRightClick = nil
bTalkToPed, bClosePedMenu = nil
ax, ay = nil
closing = nil
sent=false

function pedDamage()
	cancelEvent()
end
addEventHandler("onClientPedDamage", getRootElement(), pedDamage)

function konus (element)
	local ped 		   = getElementData(element, "name")
	local isFuelped    = getElementData(element,"ped:fuelped")
	local isTollped    = getElementData(element,"ped:tollped")
	local isShopKeeper = getElementData(element,"shopkeeper") or false

	if (ped=="Steven Pullman") then
		triggerServerEvent( "startStevieConvo", getLocalPlayer())
		if (getElementData(element, "activeConvo")~=1) then
			triggerEvent ( "stevieIntroEvent", getLocalPlayer())
		end
	elseif (ped=="Hunter") then
		triggerServerEvent( "startHunterConvo", getLocalPlayer())
	elseif (ped=="Rook") then
		triggerServerEvent( "startRookConvo", getLocalPlayer())
	elseif (ped=="Victoria Greene") then
		triggerEvent("cPhotoOption", getLocalPlayer(), ax, ay)
	elseif (ped=="Emma Brewles") then
		triggerEvent("onLicense", getLocalPlayer())
	elseif (ped=="Ocha Rosa") then
		triggerEvent("furniture:panel", getLocalPlayer())						
	elseif (ped=="Edison Pickford") then
		triggerEvent("onWearableShop", getLocalPlayer())						
	elseif (ped=="Bill Take") then
		triggerEvent("truck1:displayJob", getLocalPlayer())							
	elseif (ped=="Stephan Nill") then
		triggerEvent("tutun:panel", getLocalPlayer())							
	--elseif (ped=="Ayarlanacak") then
	--	exports["titan_secimler"]:electionsGUI(getLocalPlayer())
	elseif (ped=="Aaron Thompson") then
        triggerServerEvent("openMarriageMenu", getLocalPlayer())
	elseif (ped=="Slayer Crown") then
		triggerEvent("balik:panel", getLocalPlayer())																																	
	elseif (ped=="Christian Cylar") then
        triggerServerEvent("vergi:sVergiGUI", getLocalPlayer())									
	elseif (ped=="Llayne Tpicord") then
		triggerEvent("stone:displayJob", getLocalPlayer(), getLocalPlayer())							
	elseif (isFuelped == true) then
		triggerServerEvent("fuel:startConvo", element)
	elseif (isTollped == true) then
		triggerServerEvent("toll:startConvo", element)
	elseif (ped=="Novella Iadanza") then
		triggerServerEvent("onSpeedyTowMisterTalk", getLocalPlayer())
	elseif isShopKeeper then
		triggerServerEvent("shop:keeper", element)					
	elseif getElementData(element,"carshop") then
		triggerServerEvent( "vehlib:sendLibraryToClient", localPlayer, element)
	--elseif (ped=="Julie Dupont") then
		--	triggerServerEvent('clothing:list', getResourceRootElement (getResourceFromName("titan_dupont")))
	elseif (ped=="John G. Fox") then
		triggerServerEvent("startPrisonGUI", root, localPlayer)
	elseif (ped=="Justin Borunda") then --PD impounder / Hanz
		triggerServerEvent("tow:openImpGui", localPlayer, ped)
	elseif (ped=="Sergeant K. Johnson") then --PD release / Hanz
		triggerServerEvent("tow:openReleaseGUI", localPlayer, ped)
	elseif (ped=="Bobby Jones") then --HP impounder / Hanz
		triggerServerEvent("tow:openImpGui", localPlayer, ped)
	elseif (ped=="Robert Dunston") then --HP release / Hanz
		triggerServerEvent("tow:openReleaseGUI", localPlayer, ped)						
	elseif (ped=="Daniel Tylor") then
		triggerEvent("cigar:displayJob", getLocalPlayer(), getLocalPlayer())
	elseif (ped=="Steven Pattybird") then
		triggerEvent("wooder:displayJob", getLocalPlayer(), getLocalPlayer())
	elseif (ped=="Pete Robinson") then
		triggerServerEvent("vergi:sVergiGUI", getLocalPlayer())	
	elseif (ped=="Tommy Willson") then
		triggerEvent("cop:displayJob", getLocalPlayer(), getLocalPlayer())							
	elseif (ped=="Stalleh Crawford") then
		triggerEvent("bus:displayJob", getLocalPlayer())
	elseif (ped=="Micheal Sins") then
		triggerEvent("taxi:displayJob", getLocalPlayer())								
	elseif (ped=="Winston Fleming") then
		triggerEvent("onPaymentShop", getLocalPlayer())
	elseif (ped=="Mike Moore") then
		triggerServerEvent("exclusiveGUI", getLocalPlayer())
	elseif (ped=="Galerici R??fat") then
		triggerEvent("galeri:ac", getLocalPlayer())
	elseif (ped=="Julie Dupont") then 
		triggerServerEvent('clothing:list', getResourceRootElement(getResourceFromName("titan_clothes")))
	else
		exports.titan_hud:sendBottomNotification(getLocalPlayer(),(ped or "NPC").." diyor ki:", "'Sana yard??mc?? olabilece??im bir konu yok, ??zg??n??m.'")
	end
end
addEvent("npc:konus",true)
addEventHandler("npc:konus",root,konus)

function hidePedMenu()
	if (isElement(bTalkToPed)) then
		destroyElement(bTalkToPed)
	end
	bTalkToPed = nil

	if (isElement(bClosePedMenu)) then
		destroyElement(bClosePedMenu)
	end
	bClosePedMenu = nil

	if (isElement(wPedRightClick)) then
		destroyElement(wPedRightClick)
	end
	wPedRightClick = nil

	ax = nil
	ay = nil
	sent=false
	showCursor(false)
end
