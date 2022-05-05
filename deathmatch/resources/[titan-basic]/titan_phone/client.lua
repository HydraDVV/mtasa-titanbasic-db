local players_scroll, maxPlayersShow = 0, 5
local inHeritsResource = {}
local drawApps, appsHeight, lastClick = 0, 0, 0
local appSettings = {}

--0: Yeni Alınmış, 1: Kurulum, 2: OK
addEvent("phone:createSetup", true)
addEventHandler("phone:createSetup", root, 
	function(isState, pass, activePassword, calling)
		phoneSetupState = isState
		phonePasswordActive = activePassword

				triggerEvent("phone:completeSetup",localPlayer,localPlayer,calling)
	end
)

addEvent("phone:completeSetup", true)
addEventHandler("phone:completeSetup", root,
	function(calling)
		phoneSetupState = 2
		removePhoneSetup()
		if not calling then
			toggleOffEverything()
			togglePhoneHome(true)
		end
	end
)

function drawPhoneGUI()
	if isPhoneGUICreated() then
		return true
	end
	wPhoneMenu = guiCreateWindow(posX, posY,w,h,"",false)
	setElementData(wPhoneMenu,"disableGUI", true)
	guiWindowSetSizable(wPhoneMenu,false)
	guiSetAlpha(wPhoneMenu,0)

	local btnW, btnH = 105, 30
	local btnM = 25
	local btnPosY = 495
	
	bHome = guiCreateButton(btnM+btnW/2,btnPosY,btnW,btnH+10,"Anasayfa",false,wPhoneMenu)
	guiSetAlpha(bHome, 0)

	addEventHandler("onClientGUIClick", getRootElement(), onGuiClick)
	guiSetEnabled(wPhoneMenu, false)

	if not renderedDX then
		addEventHandler("onClientRender", root, drawnPhone)
		renderedDX = true
	end

	if wRingSMS and isElement(wRingSMS) then
		guiSetEnabled(bRingingSMSOK, false)
	    addEventHandler("onClientRender", getRootElement(), slideRingingSMSOut)
	end

	return true
end

function createPhoneSetup()
	if isTimer(timer) then return end
	timer = setTimer(function()
		if phoneSetupState == 0 then
			phoneSetupState = 1
			createSetupGUIs()
		end
	end, 6500, 1)
end

function createSetupGUIs()
	guiSetInputEnabled( true )
	setupEdit = guiCreateEdit(0.32, 0.77,0.4,0.038,"",true,wPhoneMenu)

	setupBtn = guiCreateButton(0.32, 0.83,0.4,0.032,"Telefonu Kur",true, wPhoneMenu)
	guiEditSetMaxLength(setupEdit, 4)

	curSetupNumber = ""
	addEventHandler("onClientGUIChanged", setupEdit, function(element) 
		if guiGetText(element) == "" or tonumber(guiGetText(element)) then
		   	curSetupNumber = guiGetText(element)
		else
		    guiSetText(element, curSetupNumber)
		end
	end)

	addEventHandler("onClientGUIClick", setupBtn, function(state)
		if state == "left" then
			text = guiGetText(setupEdit)
			if text:len() == 4 then
				outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#ffffff Şifreniz kabul edildi, lütfen bekleyin.", 0, 255, 0, true)
				triggerServerEvent("completePhoneSetup", localPlayer, localPlayer, phone, text)
				guiSetInputEnabled( false )
			end
		end
	end)
end

function createLockSetup()
	setupEdit = guiCreateEdit(0.32, 0.77,0.4,0.038,"",true,wPhoneMenu)
	setupBtn = guiCreateButton(0.32, 0.83,0.4,0.032,"Telefona Gir",true, wPhoneMenu)
	guiEditSetMaxLength(setupEdit, 4)

	curSetupNumber = ""
	addEventHandler("onClientGUIChanged", setupEdit, function(element) 
		if guiGetText(element) == "" or tonumber(guiGetText(element)) then
		   	curSetupNumber = guiGetText(element)
		else
		    guiSetText(element, curSetupNumber)
		end
	end)

	addEventHandler("onClientGUIClick", setupBtn, function(state)
		if state == "left" then
			text = guiGetText(setupEdit)
			--outputChatBox(text.. " -> "..phonePassword)
			if (tonumber(text) == tonumber(phonePassword)) then
				--outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#ffffff Şifreniz kabul edildi, lütfen bekleyin.", 0, 255, 0, true)
				phoneSetupState = 2
				removePhoneSetup()
				toggleOffEverything()
				togglePhoneHome(true)

			else
				outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#ffffff Hatalı şifre girdiniz, tekrar deneyin.", 255, 0, 0, true)
			end
		end
	end)
end


function removePhoneSetup()
	if isElement(setupEdit) then
		destroyElement(setupEdit)
	end
	if isElement(setupBtn) then
		destroyElement(setupBtn)
	end
end

function drawnPhone()
	if not isElement(wPhoneMenu) then
		removeEventHandler("onClientRender",root,drawnPhone)
		renderedDX = false
	end
	x,y = guiGetPosition(wPhoneMenu, false)

	dxDrawImage(x,y,w,h,"components/images/iphone_front.png",0,0,0,tocolor(255,255,255))
	for _, memo in ipairs(getElementsByType("gui-edit")) do
		if getElementData(memo, "inMessageGUI") then
			if isElement(memo) and guiGetVisible(memo) == true then
				inMessage = true
			else
				inMessage = false
			end
		end
	end

	for _, v in ipairs({"gui-scrollpane", "gui-checkbox", "gui-combobox", "gui-label", "gui-gridlist", "gui-radiobutton", "gui-edit", "gui-combobox", "gui-memo", "gui-staticimage"}) do
		for _, element in ipairs(getElementsByType(v,wPhoneMenu)) do
			if not inHeritsResource[element] then
				guiSetProperty(element, "InheritsAlpha", "FF000000")
				if getElementType(element) == "gui-edit" or getElementType(element) == "gui-memo" then
					guiSetProperty(element, "NormalTextColour", "FF000000")
				else
					guiSetProperty(element, "NormalTextColour", "FFFFFFFF")
				end
				guiSetProperty(element, "ActiveSelectionColour", "FF545454")
				guiSetAlpha(element, guiGetAlpha(element))
				--guiSetFont(element, fonts[7])

				inHeritsResource[element] = true
			end
		end
	end

	if phoneSetupState == 2 then
		guiSetEnabled(bHome, true)
		if appstoreActive then
			dxDrawImage(x,y,w,h,"components/images/iphone_front_white.png")
			dxDrawText("17 Temmuz, Cuma", x+30, y+100, w, h, tocolor(80, 80, 80), 1, fonts[5], "left", "top")
			dxDrawText("Bugün", x+30, y+114, w, h, tocolor(0, 0, 0), 1, fonts[1], "left", "top")
			--@draw AppStore
			c_apps = { ['twitter'] = false, ['safari'] = false, ['vergi'] = false, ['spotify'] = false, ['emails'] = false, ['flappy-bird'] = false }
			appsHeight, appsLimit = 0, 0
			y = y + 90
		
			for index, data in pairs(c_apps) do
				if not (custom_apps[phone][index]) then
					local app, name = index, appNames[index]
					dxDrawRectangle(x+15,y+63+appsHeight,w-30,1,tocolor(150,150,150,170))
					
					if isInSlot(x+15,y+63+appsHeight,w-30,45) then
						dxDrawRectangle(x+15,y+63+appsHeight,w-30,45,tocolor(160,160,160,50))
						if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
							lastClick = getTickCount()
							--custom_apps[phone][app] = true
							triggerServerEvent("installApp", localPlayer, {localPlayer, custom_apps[phone], phone, app})
						end
					end
					dxDrawImage(x+30,y+70+appsHeight,30,30,"components/images/"..app..".png")
					dxDrawText(name,x+70,y+60+appsHeight,30,30+(y+60+appsHeight),tocolor(30,30,30),1,fonts[4],"left","center")
					dxDrawText("Ücretsiz",x+70,y+80+appsHeight,30,30+(y+80+appsHeight),tocolor(30,30,30,100),1,fonts[5],"left","center")
		

					appsHeight = appsHeight + 45
				else
					local app, name = index, appNames[index]
					dxDrawRectangle(x+15,y+63+appsHeight,w-30,1,tocolor(150,150,150,170))
					
					if isInSlot(x+15,y+63+appsHeight,w-30,45) then
						dxDrawRectangle(x+15,y+63+appsHeight,w-30,45,tocolor(160,160,160,50))
						if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
							lastClick = getTickCount()
							if app == "history" then
								toggleOffEverything()
								toggleHistory(true)
							elseif app == "contacts" then
								guiSetEnabled(wPhoneMenu, false)
								outputChatBox("1")
								if not contactList[phone] then
									triggerServerEvent("phone:requestContacts", localPlayer, phone)
								else
									openPhoneContacts(phone)
								end
							elseif app == "settings" then
								toggleOffEverything()
								settingPageActive = true
								toggleSettingsGUI(true)
							elseif app == "appstore" then
								toggleOffEverything()
								appstoreActive = true
							elseif app == "safari" then
								toggleOffEverything()
								toggleSafari(true)
							elseif app == "vergi" then
								toggleOffEverything()
								toggleVergi(true)
							elseif app == "flappy-bird" then
							elseif app == "spotify" then
								toggleOffEverything()
								toggleSpotify(true)
							end
						end
					end
					dxDrawImage(x+30,y+70+appsHeight,30,30,"components/images/"..app..".png")
					dxDrawText(name,x+70,y+60+appsHeight,30,30+(y+60+appsHeight),tocolor(30,30,30),1,fonts[4],"left","center")
					dxDrawText("Yüklü",x+70,y+80+appsHeight,30,30+(y+80+appsHeight),tocolor(30,30,30,100),1,fonts[5],"left","center")
		

					appsHeight = appsHeight + 45			
				end
			end
			dxDrawRectangle(x+15,y+63+appsHeight,w-30,1,tocolor(150,150,150,170))
		elseif settingPageActive then
			dxDrawImage(x,y,w,h,"components/images/iphone_front_settings.png",0,0,0,tocolor(255,255,255))	
		elseif safariActive then
			dxDrawImage(x,y,w,h,"components/images/iphone_front_safari.png",0,0,0,tocolor(255,255,255))	
		elseif vergiActive then
			dxDrawImage(x,y,w,h,"components/images/iphone_front_vergi.png",0,0,0,tocolor(255,255,255))	
		elseif flappyShow then
		--	dxDrawImage(x,y,w,h,"components/images/iphone_front_status_bar1.png",0,0,0,tocolor(255,255,255),true)
		elseif twitterActive then
			dxDrawImage(x,y,w,h,"components/images/iphone_front_twitter.png",0,0,0,tocolor(255,255,255))
			dxDrawImage(x,y,w,h,"components/images/iphone_front_status_bar.png")
			dxDrawText(getNavbarTime(), x, y+69, x+w, y, tocolor(255,255,255),1,fonts[5],"center","top")
		elseif shownSpotify then
			dxDrawImage(x,y,w,h,"components/images/iphone_front_spotify.png",0,0,0,tocolor(255,255,255))
		else
			dxDrawImage(x,y,w,h,"components/images/iphone_setup_2.png",0,0,0,tocolor(255,255,255))
			--dxDrawRectangle(x+50,y+h-150,180,75,tocolor(0,0,0))
			dxDrawImage(x,y,w,h,"components/images/iphone_front_status_bar.png")
			dxDrawText(getNavbarTime(), x, y+69, x+w, y, tocolor(255,255,255),1,fonts[5],"center","top")
		end
	else
		guiSetEnabled(bHome, false)
		if isElement(setupEdit) then
			guiEditSetMasked(setupEdit, true )
			guiSetProperty(setupEdit, 'MaskCodepoint', '8226' )
		end
		if not phoneSetupState then phoneSetupState = 0 end
		if phoneSetupState == 3 then
			guiSetEnabled(bHome, true)
			dxDrawImage(x,y,w,h,"components/images/iphone_setup_"..(phoneSetupState)..".png",0,0,0,tocolor(255,255,255))
		else
			dxDrawImage(x,y,w,h,"components/images/iphone_setup_"..(phoneSetupState+1)..".png",0,0,0,tocolor(255,255,255))
		end
	end

	for k,v in ipairs(getElementsByType("gui-button",wPhoneMenu)) do
		bx,by = guiGetPosition(v,false)
		bw,bh = guiGetSize(v,false)
		bx,by = bx+x,by+y
		parent = getElementParent(v)
		if not alpha[v] then alpha[v] = 0 end
		if parent == wPhoneMenu then
			if guiGetVisible(v) == true and isElement(v) then
				if (tonumber(guiGetAlpha(v)) ~= 0) then
					if guiGetEnabled(v) == true then
						
						if isInSlot(bx,by,bw,bh) then
							alpha[v] = alpha[v] + 3
							if alpha[v] >= 35 then alpha[v] = 35 end
						else
							alpha[v] = alpha[v] - 3
							if alpha[v] <= 0 then alpha[v] = 0 end
						end
						dxDrawRectangle(bx,by,bw,bh,tocolor(245,245,245,220+alpha[v]))
					else
						dxDrawRectangle(bx,by,bw,bh,tocolor(245,245,245,150))
					end
					dxDrawText(guiGetText(v), bx,by,bw+bx,bh+by, tocolor(20,20,20),1,fonts[4],"center","center")
				end
			end
		else
			guiSetProperty(v, "InheritsAlpha", "FF000000")
		end
	end
	for _, edit in ipairs(getElementsByType("gui-edit", wPhoneMenu)) do
		parent = getElementParent(edit);
		enabled = guiGetEnabled(edit)
		if (parent == wPhoneMenu) and guiGetVisible(edit) == true and not getElementData(edit, "disabledDX") then
			ex,ey = guiGetPosition(edit,false);
			ew,eh = guiGetSize(edit,false);
			ex,ey = ex+x,ey+y

			if enabled == true and guiGetAlpha(edit) > 0 then

				dxDrawRectangle(ex,ey,ew,5,tocolor(255,255,255,255),true);--üst
				dxDrawRectangle(ex,ey+eh-5,ew,5,tocolor(255,255,255,255),true);--alt

				dxDrawRectangle(ex,ey,5,eh,tocolor(255,255,255,255),true);--sol
				dxDrawRectangle(ex+ew-5,ey,5,eh,tocolor(255,255,255,255),true);--sağ
			end
		end
	end
	if drawApps then
		appsHeight, appsLimit = 0, 0
		y = y + 30
		apps = {"history","contacts","settings","appstore"}
		c_apps = {"twitter", "safari", "vergi", "spotify", "emails", "flappy-bird"}
		-- First check it:
		if custom_apps[phone] then
			for app, data in pairs(custom_apps[phone]) do
				if (data) then
					table.insert(apps, app)
				end
			end
		end
		
		for index, data in pairs(apps) do
			local app, name = data, appNames[data]
			if fileExists("components/images/"..app..".png") then
				
				if appsLimit >= 4 then
					appsLimit = 0
					appsHeight = 0
					y = y + 70
				end

				dxDrawImage(x+23+appsHeight,y+70,45,45,"components/images/"..app..".png")
				if isInSlot(x+23+appsHeight,y+70,45,45) then
					if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
						lastClick = getTickCount()
						if app == "history" then
							toggleOffEverything()
							toggleHistory(true)
						elseif app == "contacts" then
							guiSetEnabled(wPhoneMenu, false)
							--outputChatBox("12")
							if contactList[phone] then
								--outputChatBox("başarılı")
								triggerServerEvent("phone:requestContacts", localPlayer, phone)
							else
								--outputChatBox("başarısız")
								openPhoneContacts(contactList[phone])
							end
						elseif app == "settings" then
							toggleOffEverything()
							settingPageActive = true
							toggleSettingsGUI(true)
						elseif app == "appstore" then
							toggleOffEverything()
							appstoreActive = true
						elseif app == "safari" then
							toggleOffEverything()
							toggleSafari(true)
						elseif app == "vergi" then
							toggleOffEverything()
							--toggleVergi(true)
							triggerServerEvent("phone:serverTax", localPlayer)
							--triggerServerEvent("carshop:serverTax", localPlayer)
						elseif app == "flappy-bird" then
							toggleOffEverything()
							toggleFlappyBird(true)
						elseif app == "spotify" then
							toggleOffEverything()
							toggleSpotify(true)
						elseif app == "twitter" then
							toggleOffEverything()
							toggleTwitter(true)
						end
					elseif getKeyState("mouse2") and lastClick+200 <= getTickCount() then
						lastClick = getTickCount()
						if not showAppSett then
							appSettings[app] = true
							showAppSett = true
						end
					end
				end
				if appSettings[app] then
					dxDrawText(name, x+23+appsHeight,y+80,45+(x+23+appsHeight),45+(y+90), tocolor(255,255,255), 1, fonts[4], "center", "bottom")
				else
					dxDrawText(name or "", x+23+appsHeight,y+80,45+(x+23+appsHeight),45+(y+90), tocolor(225,225,225), 1, fonts[4], "center", "bottom")
				end
				if appSettings[app] then
					rectangle(x+15, y+h-200, w-30, 25, tocolor(200, 200, 200, 170), 4)
					dxDrawText("Yüklemeyi Kaldır", x+15, y+h-200, w-30+(x+15), 25+(y+h-200), tocolor(232, 65, 24), 1, fonts[4], "center", "center")
					
					if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
						lastClick = getTickCount()
						if isInSlot(x+15, y+h-200, w-30, 25) then

						else
							appSettings[app] = false
							showAppSett = false
						end
					end
				end
				appsHeight = appsHeight + 58
				appsLimit = appsLimit + 1
			end
		end
	end

end

addEvent("reloadApps", true)
addEventHandler("reloadApps", root,
	function(apps)
		custom_apps[phone] = apps
	end
)

function updatePhoneGUI(action, data, c_apps)
	if isPhoneGUICreated() and action then
		if action == "initiate" then
			if data[1] and tonumber(data[1]) ~= tonumber(phone) then
				slidePhoneOut()
				return false
			end
			toggleOffEverything()
			if data[2] and tonumber(data[2]) == 1 then
				guiSetVisible(bHome, true)
				drawPhoneHome()
			else
				guiSetVisible(bHome, false)
			end
			guiSetEnabled(wPhoneMenu, true)
			phone = tonumber(data[1])

			custom_apps[phone] = c_apps
			updateClientPhoneSettingsFromServer(phone, data)
		elseif action == "popOutOnPhoneCall" then
			toggleOffEverything()
			guiSetVisible(bHome, true)
			--outputChatBox(dialingContactFrom)
			startDialing(phone, dialingContactFrom, true)
			guiSetEnabled(bHome, false)
			guiSetEnabled(wPhoneMenu, true)
		elseif tonumber(action) then
			toggleOffEverything()
			guiSetVisible(bHome, true)
			--outputChatBox(action)
			startDialing(phone, action)
			guiSetEnabled(bHome, false)
			guiSetEnabled(wPhoneMenu, true)
		end
	end
end
addEvent("phone:updatePhoneGUI", true)
addEventHandler("phone:updatePhoneGUI", root, updatePhoneGUI)

function updateClientPhoneSettingsFromServer(fromPhone, data)
	if data and #data>0 and tonumber(fromPhone) then
		fromPhone = tonumber(fromPhone)
		setPhoneSettings(fromPhone, "phone", data[1])
		setPhoneSettings(fromPhone, "powerOn", data[2])
		setPhoneSettings(fromPhone, "ringtone", data[3])
		setPhoneSettings(fromPhone, "isSecret", data[4])
		setPhoneSettings(fromPhone, "isInPhonebook", data[5])
		setPhoneSettings(fromPhone, "boughtBy", data[6])
		setPhoneSettings(fromPhone, "boughtByName", data[7])
		setPhoneSettings(fromPhone, "boughtDate", data[8])
		setPhoneSettings(fromPhone, "sms_tone", data[9])
		setPhoneSettings(fromPhone, "keypress_tone", data[10])
		setPhoneSettings(fromPhone, "tone_volume", data[11])
	end
end
addEvent("phone:updateClientPhoneSettingsFromServer", true)
addEventHandler("phone:updateClientPhoneSettingsFromServer", root, updateClientPhoneSettingsFromServer)

function triggerSlidingPhoneIn(thePhoneNumber, popOutOnPhoneCall, callingNumberFromCommand, c_apps)
	if not canPlayerSlidePhoneIn(localPlayer) then
		outputChatBox("You can not use cellphone at the moment.")
		return false
	end

	triggerServerEvent("fetchApps", localPlayer, thePhoneNumber)

	if thePhoneNumber and tonumber(thePhoneNumber) then
		phone = tostring(thePhoneNumber)
		custom_apps[phone] = c_apps
	end

	if not phone then
		return false
	else
		if not popOutOnPhoneCall and tonumber(phone) ~= tonumber(thePhoneNumber) then
			return false
		end
	end

	if drawPhoneGUI() then
		removeEventHandler("onClientRender", root, slidePhoneOut)
		addEventHandler("onClientRender", root, slidePhoneIn)
		setED(localPlayer, "exclusiveGUI", true)
	end

	local powerOn = getPhoneSettings(thePhoneNumber, "powerOn") or 1
	local ringtone = getPhoneSettings(thePhoneNumber, "ringtone") or 1
	local isSecret = getPhoneSettings(thePhoneNumber, "isSecret") or 1
	local isInPhonebook = getPhoneSettings(thePhoneNumber, "isInPhonebook") or 0
	local boughtBy = getPhoneSettings(thePhoneNumber, "boughtBy") or 0
	local boughtByName = getPhoneSettings(thePhoneNumber, "boughtByName") or 0
	local boughtDate = getPhoneSettings(thePhoneNumber, "boughtDate") or 0
	local sms_tone = getPhoneSettings(thePhoneNumber, "sms_tone") or 0
	local keypress_tone = getPhoneSettings(thePhoneNumber, "keypress_tone") or 0
	local tone_volume = getPhoneSettings(thePhoneNumber, "tone_volume") or 1

	if powerOn or popOutOnPhoneCall or tonumber(callingNumberFromCommand) then
		updatePhoneGUI(popOutOnPhoneCall and "popOutOnPhoneCall" or tonumber(callingNumberFromCommand) or "initiate", {thePhoneNumber, powerOn, ringtone, isSecret, isInPhonebook, boughtBy, boughtByName, boughtDate, sms_tone, keypress_tone})
		triggerServerEvent("phone:applyPhone", localPlayer, "phone_in")
		if not powerOn then
			triggerServerEvent("phone:requestPhoneSettingsFromServer", localPlayer, thePhoneNumber)
		end
	else
		triggerServerEvent("phone:initiatePhoneGUI", getLocalPlayer(), phone,  popOutOnPhoneCall or callingNumberFromCommand, initiatePhoneGUI)
	end
	triggerServerEvent("receivePhoneSetupCache", localPlayer, localPlayer, phone)
	togglePhoneDial(false)
end
addEvent("phone:slidePhoneIn", true)
addEventHandler("phone:slidePhoneIn", root, triggerSlidingPhoneIn)

function slidePhoneIn()
	if isPhoneGUICreated() then
		if guiSetPosition(wPhoneMenu, curX, curY, false) and canSlideIn()  then
			curX = curX - slidingSpeed
		else
			removeEventHandler("onClientRender", root, slidePhoneIn)
		end
	else
		removeEventHandler("onClientRender", root, slidePhoneIn)
	end
end

function slidePhoneOut()
	if isPhoneGUICreated() then
		if guiSetPosition(wPhoneMenu, curX, curY, false) and canSlideOut() then
			curX = curX + slidingSpeed
		else
			removeEventHandler("onClientRender", root, slidePhoneOut)
			renderedDX = false
			removeEventHandler("onClientRender", root, drawnPhone)
			hidePhoneGUI()
		end
	else
		removeEventHandler("onClientRender", root, slidePhoneOut)
	end
end
function triggerSlidingPhoneOut(DontTriggerApplyPhone)
	if drawPhoneGUI() then
		
		removeEventHandler("onClientRender", root, slidePhoneIn)
		addEventHandler("onClientRender", root, slidePhoneOut)
		setED(localPlayer, "exclusiveGUI", false)
	end
	
	finishPhoneCall()
	
	if not DontTriggerApplyPhone then
		triggerServerEvent("phone:applyPhone", localPlayer, "phone_out")
	end
end
addEvent("phone:slidePhoneOut", true)
addEventHandler("phone:slidePhoneOut", root, triggerSlidingPhoneOut)

function canSlideIn()
	return curX > posX-xoffset
end

function canSlideOut()
	return curX < posX
end

function initiatePhoneGUI(thePhoneNumber)
	
end


addEvent("phone:initiatePhoneGUI", true)
addEventHandler("phone:initiatePhoneGUI", getRootElement(), initiatePhoneGUI)

function drawPhoneHome()
	if isPhoneGUICreated() then
		drawPhoneDial()
		if not togglePanesOfApps(true) then
			drawApps = true
		end
	end
end

function togglePhoneHome(state)
	if isPhoneGUICreated() then
		if ePhoneNumber and isElement(ePhoneNumber) then
			--togglePhoneDial(state)
		else
			if state then
				--drawPhoneHome()
			end
		end
		if not togglePanesOfApps(state) then
			if state then
				drawApps = true
			end
		end
	end
end

function toggleOffEverything()
	toggleSpotify(false)
	appstoreActive = false
	settingPageActive = false
	drawApps = false
	inDetails = false
	togglePhoneDial(false)
	toggleFlappyBird(false)
	togglePhoneHome(false)
	togglePhoneContacts(false)
	toggleHistory(false)
	guiNewContactClose()
	toggleSafari(false)
	toggleVergi(false)
	toggleTwitter(false)
	closeContactDetails()
	togglePanesOfApps(false)
	toggleSettingsGUI(false)
	closeDialing()
	toggleHotlines(false)
	removePhoneSetup()
end

hotlineIndexes = {}
function drawHomeMidBlock()
	if isPhoneGUICreated() then
		cHotlines = guiCreateComboBox ( 30,155+40+5,204,20, "Most Common Hotlines", false, wPhoneMenu )
		guiComboBoxAddItem(cHotlines, "Most Common Hotlines")
		selectedHotline = ""
		for hotline, hName in pairs(hotlines) do
			local text = hName.." ("..hotline..")"
			guiComboBoxAddItem(cHotlines, text )
			hotlineIndexes[text] = hotline
		end
		exports.titan_global:guiComboBoxAdjustHeight(cHotlines, 12)

		addEventHandler ( "onClientGUIComboBoxAccepted", guiRoot,
		    function ( comboBox )
		        if ( comboBox == cHotlines ) and ePhoneNumber and isElement(ePhoneNumber) then
		            local item = guiComboBoxGetSelected ( cHotlines )
		            local text = tostring ( guiComboBoxGetItemText ( cHotlines , item ) )
		            if ( text ~= "" and text ~= "Most Common Hotlines") then
		                 guiSetText ( ePhoneNumber , hotlineIndexes[text] )
		            end
		        end
		    end
		)
		local rawSize = 128*0.5
		iPowerOff = guiCreateStaticImage( 100,155+40*2+5,rawSize,rawSize, "components/images/power_off.png", false, wPhoneMenu )
		--guiSetAlpha(iPowerOff, 0.5)
		bPowerOff = guiCreateButton( 100,155+40*2+5,rawSize,rawSize, "", false, wPhoneMenu )
		guiSetAlpha(bPowerOff, 0.2)
	end
end

function toggleHomeMidBlock(state)
	if cHotlines and isElement(cHotlines) then
		guiSetVisible(cHotlines, state)
		guiSetVisible(iPowerOff, state)
		guiSetVisible(bPowerOff, state)
	end
end


function drawPhoneIcons(yOffset)
	if isPhoneGUICreated() then
		

		iContacts = guiCreateStaticImage(posX,posY,iconSize,iconSize,"components/images/contacts.png",false,wPhoneMenu)
		btnContacts = guiCreateButton(posX,posY,iconSize,iconSize,"",false,wPhoneMenu)
		guiSetAlpha(btnContacts, btnAlpha)
		posX = posX + iconSize+iconSpacing

		iMessages = guiCreateStaticImage(posX,posY,iconSize,iconSize,"components/images/messages.png",false,wPhoneMenu)
		btnMessages = guiCreateButton(posX,posY,iconSize,iconSize,"",false,wPhoneMenu)
		guiSetAlpha(btnMessages, btnAlpha)
		posX = posX + iconSize+iconSpacing

		posY = posY + iconSize + iconSpacing
		posX = 30

		iMusic = guiCreateStaticImage(posX,posY,iconSize,iconSize,"components/images/music.png",false,wPhoneMenu)
		btnMusic = guiCreateButton(posX,posY,iconSize,iconSize,"",false,wPhoneMenu)
		guiSetAlpha(btnMusic, btnAlpha)
		posX = posX + iconSize+iconSpacing

		iWeather = guiCreateStaticImage(posX,posY,iconSize,iconSize,"components/images/weather.png",false,wPhoneMenu)
		btnWeather = guiCreateButton(posX,posY,iconSize,iconSize,"",false,wPhoneMenu)
		guiSetAlpha(btnWeather, btnAlpha)
		posX = posX + iconSize+iconSpacing

		iSettings = guiCreateStaticImage(posX,posY,iconSize,iconSize,"components/images/settings.png",false,wPhoneMenu)
		btnSettings = guiCreateButton(posX,posY,iconSize,iconSize,"",false,wPhoneMenu)
		guiSetAlpha(btnSettings, btnAlpha)
		posX = posX + iconSize+iconSpacing
	end
end

function togglePhoneIcons(state)
	if isPhoneGUICreated() and iHistory and isElement(iHistory) then
		if state then
			guiSetVisible(iHistory, true)
			guiSetVisible(btnHistory, true)
			guiSetVisible(iContacts, true)
			guiSetVisible(btnContacts, true)
			guiSetVisible(iMessages, true)
			guiSetVisible(btnMessages, true)
		--	guiSetVisible(iMusic, true)
		--	guiSetVisible(btnMusic, true)
		--	guiSetVisible(iWeather, true)
		--	guiSetVisible(btnWeather, true)
			guiSetVisible(iSettings, true)
			guiSetVisible(btnSettings, true)
		else
			guiSetVisible(iHistory, false)
			guiSetVisible(btnHistory, false)
			guiSetVisible(iContacts, false)
			guiSetVisible(btnContacts, false)
			guiSetVisible(iMessages, false)
			guiSetVisible(btnMessages, false)
		--	guiSetVisible(iMusic, false)
		--	guiSetVisible(btnMusic, false)
		--	guiSetVisible(iWeather, false)
		--	guiSetVisible(btnWeather, false)
			guiSetVisible(iSettings, false)
			guiSetVisible(btnSettings, false)
		end
	end
end




function hidePhoneGUI()
	guiConfirmDeleteClose()
	guiNewContactClose()
	if isPhoneGUICreated() then
		toggleOffEverything()
		destroyElement(wPhoneMenu)
		wPhoneMenu = nil
		showCursor(false)
		guiSetInputEnabled(false)
		
		removeEventHandler("onClientGUIClick", getRootElement(), onGuiClick)
		setElementData(localPlayer, "exclusiveGUI", false, false)
		setElementData(localPlayer, "cellphoneGUIState", "slidedOut", false)
	end
	closeConfirmBox()
	killSettingSounds()
	--exports.titan_ed_OwlGamingLogs:closeInfoBox()
end


function guiConfirmDelete(name, number)
	guiSetEnabled( wPhoneMenu, false )
	local sx, sy = guiGetScreenSize() 
	wDelete = guiCreateWindow(sx/2 - 150,sy/2 - 50,300,100,"Delete entry", false)
	lQuestion = guiCreateLabel(0.05,0.25,0.9,0.3, "Are you sure you want to delete '"..name.."' from your contacts list?",true,wDelete)
	guiLabelSetHorizontalAlign (lQuestion,"center",true)
	bButtonDeleteYes = guiCreateButton(0.1,0.65,0.37,0.23,"Yes",true,wDelete)
	bButtonDeleteNo = guiCreateButton(0.53,0.65,0.37,0.23,"No",true,wDelete)
	saveDeleteName = name
	saveDeleteNumber = number
end


function guiConfirmDeleteClose()
	if wDelete and isElement(wDelete) then
		destroyElement(wDelete)
	end
	if isPhoneGUICreated() then
		guiSetEnabled( wPhoneMenu, true )
	end
end

function onGuiClick(button)
	if button == "right" then
		if source == bHome then
			triggerSlidingPhoneOut()
		end
	elseif button == "left" and phoneSetupState == 2 then
		if p_Sound["playing"] then
			stopSound(p_Sound["playing"])
		end
		if source == bCall then
			startDialing(phone, guiGetText(ePhoneNumber))
		elseif source == bKonumAt then
			if tonumber(guiGetText(ePhoneNumber)) then
				x,y,z = getElementPosition(localPlayer)
				location = getZoneName ( x, y, z )
			--	outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#ffffff Konum başarıyla atıldı!",0,255,0,true)
				--element,bendekiNO,gidenNO,text,false
				triggerServerEvent("phone:konumAt",localPlayer,localPlayer,phone,tonumber(guiGetText(ePhoneNumber)),"Size konum yolladı! Konum bilgileri: "..location, false)
				--triggerServerEvent("phone:sendSMS", localPlayer,localPlayer, 3131, tonumber(guiGetText(ePhoneNumber)), "Size konum yolladı! Konum bilgileri: "..location, false)
			
			end
		elseif source ==  bHome then
			toggleOffEverything()
			togglePhoneHome(true)
		elseif source == bCancel2 then -- Cancel contact details
			toggleOffEverything()
			togglePhoneContacts(true)
			togglePhoneDial(true)
		elseif source == bAddContact then
			if isPhoneGUICreated() then
				guiSetEnabled(wPhoneMenu, false)
				local name = guiGetText(fName_contacts_new)
				local phoneNumber = guiGetText(fNumber_contacts_new)
				triggerServerEvent("phone:addContact", localPlayer , localPlayer , name, phoneNumber, phone or "-1")
			end
		elseif source == gRingtones then
			if guiGridListGetSelectedItem(gRingtones) ~= -1 then
				p_Sound["playing"] = playSound(ringtones[guiGridListGetSelectedItem(gRingtones)])
			end
		elseif source == bCancel then
			triggerSlidingPhoneOut()
		elseif source == bOK then
			if guiGridListGetSelectedItem(gRingtones) ~= -1 then
				triggerServerEvent("saveRingtone", getLocalPlayer(), guiGridListGetSelectedItem(gRingtones), tonumber(phone) or 1)
			end
			hidePhoneGUI()
		elseif source == bButtonDeleteYes then
			triggerServerEvent("phone:deleteContact", getLocalPlayer(), saveDeleteName, saveDeleteNumber, tonumber(phone) or 1)
			guiConfirmDeleteClose()
		elseif source == bButtonDeleteNo then
			guiConfirmDeleteClose()
		elseif source == bCancelContact then
			guiNewContactClose()
			togglePhoneContacts(true)
			if isPhoneGUICreated() then
				guiSetEnabled(wPhoneMenu, true)
			end
			if gPhoneBook and isElement(gPhoneBook) then
				guiSetEnabled(gPhoneBook, true)
			end
		end
		if source ~= wPhoneMenu and source ~= bEndCall and source ~=wHistory then
			playToggleSound()
		end
		
	end
end

function showSettingsGui(itemValue)
	addEventHandler("onClientGUIClick", getRootElement(), onGuiClick)
	showCursor(true)

	wPhoneMenu = guiCreateWindow(sx/2 - 125,sy/2 - 175,250,310,"Phone Settings Menu",false)
	gRingtones = guiCreateGridList(0.0381,0.1977,0.9153,0.6706,true,wPhoneMenu)
	guiGridListAddColumn(gRingtones,"ringtones",0.85)
	guiGridListSetItemText(gRingtones, guiGridListAddRow(gRingtones), 1, "vibrate mode", false, false)
	for i, filename in ipairs(ringtones) do
		guiGridListSetItemText(gRingtones, guiGridListAddRow(gRingtones), 1, filename:sub(1,-5), false, false)
	end
	guiGridListSetSelectedItem(gRingtones, itemValue, 1)
	bOK = guiCreateButton(0.0381,0.8821,0.4492,0.0742,"OK",true,wPhoneMenu)
	bCancel = guiCreateButton(0.5212,0.8821,0.4322,0.0742,"Cancel",true,wPhoneMenu)
end

function radioDispatchBeep()
	playSound("components/sounds/dispatch.mp3", false)
end
addEvent("phones:radioDispatchBeep", true)
addEventHandler("phones:radioDispatchBeep", getRootElement(), radioDispatchBeep)
local turningOn = 1
function powerOnPhone()
	if isPhoneGUICreated() then
		turningOn = 1
		local ratio = 0.8
		local rawW, rawH = 257*ratio, 120*ratio
		alphaTmp = nil
		powerOnPhone_logo = guiCreateStaticImage(30, 200, rawW, rawH, ":resources/OGLogo.png", false, wPhoneMenu)
		--guiSetAlpha(logo, alpha)
		powerOnPhone_text = guiCreateLabel(80, 180+rawH+5, rawW, rawH, "Starting up...0%", false, wPhoneMenu)
		--guiSetAlpha(text, alpha)
		guiSetEnabled(wPhoneMenu, false)
		addEventHandler("onClientRender", root, fadeInLogo)
	end
end

function powerOffPhone()
	if isPhoneGUICreated() then
		turningOn = 0
		toggleOffEverything()
		local ratio = 0.8
		local rawW, rawH = 257*ratio, 120*ratio
		alphaTmp = nil
		powerOnPhone_logo = guiCreateStaticImage(30, 200, rawW, rawH, ":resources/OGLogo.png", false, wPhoneMenu)
		--guiSetAlpha(logo, alpha)
		powerOnPhone_text = guiCreateLabel(80, 180+rawH+5, rawW, rawH, "Starting up...0%", false, wPhoneMenu)
		--guiSetAlpha(text, alpha)
		guiSetEnabled(wPhoneMenu, false)
		addEventHandler("onClientRender", root, fadeInLogo)
	end
end

function fadeInLogo()
	if isPhoneGUICreated() then
		if powerOnPhone_logo and isElement(powerOnPhone_logo) then
			if not alphaTmp then
				alphaTmp = 0
			end
			if alphaTmp <= 1 then
				guiSetAlpha(powerOnPhone_logo, alphaTmp)
				alphaTmp = alphaTmp + 0.01
				guiSetText(powerOnPhone_text, (turningOn == 1 and "Starting up" or "Shutting down").."..."..(alphaTmp*100).."%")
			else
				removeEventHandler("onClientRender", root, fadeInLogo)
				triggerServerEvent("phone:powerOn", localPlayer, phone, turningOn)
			end
		end
	end
end

function powerOnResponse(success, turnedOn)
	if isPhoneGUICreated() then
		if turnedOn == 1 then
			if success then
				destroyElement(powerOnPhone_logo)
				powerOnPhone_logo = nil
				destroyElement(powerOnPhone_text)
				powerOnPhone_text = nil
				drawPhoneHome()
				guiSetVisible(bHome, true)
				--outputChatBox(phone.."-"..turnedOn)
				setPhoneSettings(phone, "powerOn", turnedOn)
			else
				guiSetText(powerOnPhone_text, "Starting up...Failed!")
			end
		else
			if success then
				destroyElement(powerOnPhone_logo)
				powerOnPhone_logo = nil
				destroyElement(powerOnPhone_text)
				powerOnPhone_text = nil
				toggleOffEverything()
				guiSetVisible(bHome, false)
				--outputChatBox(phone.."-"..turnedOn)
				setPhoneSettings(phone, "powerOn", turnedOn)
			else
				guiSetText(powerOnPhone_text, "Shutting down...Failed!")
			end
		end
		guiSetEnabled(wPhoneMenu, true)
	end
end
addEvent("phone:powerOn:response", true)
addEventHandler("phone:powerOn:response", getRootElement(), powerOnResponse)


--------------------------------------------------------------------------------------------
function isPhoneGUICreated()
	if wPhoneMenu and isElement(wPhoneMenu) then
		return true
	else
		return false
	end
end

function validateContactNameAndNumber(name, number, id)
	if #contactList[phone] >= contactListLimit[phone] then
		return false
	end 
	if (string.len(name) > 1 and name ~= "Yeni Kişi Kaydet") and (string.len(number) > 1 and tonumber(number)) then
		for i, contact in pairs(contactList[phone]) do
			if not id then
				if (contact.entryName and string.lower(contact.entryName) == string.lower(name)) or ( contact.entryNumber and tonumber(contact.entryNumber) == tonumber(number)) then
					return false
				end
			else
				if (tonumber(id) ~= tonumber(contact.id)) then
					if (contact.entryName and string.lower(contact.entryName) == string.lower(name)) or ( contact.entryNumber and tonumber(contact.entryNumber) == tonumber(number)) then
						return false
					end
				end
			end
		end
   		return true
   	else
   		return false
   	end
end

function playToggleSound()
	if getPhoneSettings(phone, "keypress_tone") == 0 then
		return false
	end
	playSound(":resources/toggle.mp3")
end

function cleanUp()
	setElementData(localPlayer, "exclusiveGUI", false, false)
	setElementData(localPlayer, "cellphoneGUIState", "slidedOut", false)
	setElementData(localPlayer, "phoneRingingShowing", nil)
end
addEventHandler("onClientResourceStart", resourceRoot, cleanUp)
setElementData(localPlayer,"konum->attigiKisi",false)
function clearAllCaches(fromPhone)
	fromPhone = tonumber(fromPhone)
	if fromPhone then
		resetHistory(fromPhone)
		if contactList[fromPhone] then
			contactList[fromPhone] = nil
		end
		cleanSettings(fromPhone)
		resetSMSThreads(fromPhone)
		smsComposerCache[fromPhone] = nil
	end
end
addEvent("phone:clearAllCaches", true)
addEventHandler("phone:clearAllCaches", root, clearAllCaches)

--jesse
local marker = {}
local blip = {}
addEvent("konum:markerAc",true)--p1: atan kişi, p2: işlemi gerçeklitşrlcek olan kişi
addEventHandler("konum:markerAc",root,function(p1,p2,x,y,z)
	marker[p2] = createMarker(x,y,z-1,"checkpoint",1.6,255,153,0,155)
	blip[p2] = createBlip(x,y,z,41)--waypoint blip
 	addEventHandler("onClientMarkerHit",marker[p2],function(hitElement)
		if hitElement ~= p2 then
			return
		end
		destroyElement(blip[p2])
		destroyElement(marker[p2])
		--marker[p2] = {}
		setElementData(p1,"konum->attigiKisi",false)
		outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#ffffff Konuma ulaştınız!",0,255,0,true)
	end)
end)

function isInSlot(xS, yS, wS, hS)
	if(isCursorShowing()) then
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*sx, cursorY*sy
		if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
			return true
		else
			return false
		end
	end	
end

function getNavbarTime()
	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second
	if (hours < 10) then
		hours = "0"..hours
	end
	if (minutes < 10) then
		minutes = "0"..minutes
	end
	if (seconds < 10) then
		seconds = "0"..seconds
	end
	return hours..":"..minutes
end

function rectangle(x, y, rx, ry, color, radius)
    rx = rx - radius * 2
    ry = ry - radius * 2
    x = x + radius
    y = y + radius

    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color)
        dxDrawRectangle(x, y - radius, rx, radius, color)
        dxDrawRectangle(x, y + ry, rx, radius, color)
        dxDrawRectangle(x - radius, y, radius, ry, color)
        dxDrawRectangle(x + rx, y, radius, ry, color)

        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
    end
end

--@ Notification Class
--@ Author Disco

addEvent("playPhoneSound", true)
addEventHandler("playPhoneSound", root,
	function(name)
		if isElement(sound) then destroyElement(sound) end
		sound = playSound("components/sounds/"..name..".mp3")
	end
)

--@ Add New Notification:
local notifications = {}
function addNotify(appName, context, text)
	if (localPlayer:getData('notifications->disabled')) then return false end
	local insertID = #notifications + 1
	notifications[insertID] = {appName, context, text, getTickCount(), 0};
end
addEvent("addNotify", true)
addEventHandler("addNotify", root, addNotify)

--@ Commands
addCommandHandler('bildirim',
	function(cmd,state)
		if (not state) then
			outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#ffffff /bildirim [aç/kapat]",0,0,255,true)
			return
		end
		if (state == "aç") then
			outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#ffffff Bildirimler başarıyla açıldı.", 0, 255, 0, true)
			localPlayer:setData('notifications->disabled', false)
		elseif (state == "kapat") then
			outputChatBox("#575757"..exports["titan_pool"]:getServerName()..":#ffffff Bildirimler başarıyla kapatıldı.", 0, 255, 0, true)
			localPlayer:setData('notifications->disabled', true)
		end
	end
)

--@ Let's Draw
addEventHandler('onClientRender', root,
	function()
		if #notifications > 0 then
			for i, v in ipairs(notifications) do
				local w, h = dxGetTextWidth(v[3], 1, fonts[9])+120, 40
				local x, y = -w, (sy-10)-(h*i)
				--@animation:
				local now = getTickCount()
				local endTime = v[4] + 1000
				local elapsedTime = now - v[4]
				local duration = endTime - v[4]
				local progress = elapsedTime / duration
				local r, g, b = unpack(appColors[v[1]])
				local x, y = interpolateBetween(x,y,0,0,y,0,progress,'OutBounce')
				gradient(x,y,w,h,0,0,0,170,false,true)
				if (x >= 0) then
					dxDrawRectangle(x,y+h-1,w-v[5],1,tocolor(r,g,b))
					v[5] = v[5] + 0.5
					if v[5] >= w then
						v[5] = w;
						table.remove(notifications, i)
					end
				end
				if (v[1] == 'twitter') then
					dxDrawText(' twitter', x-15, y-5, w+x-15, h+y-5, tocolor(r,g,b),1,fonts[10],'right','bottom')
				elseif (v[1] == 'police') then
					dxDrawText(' Acil Arama Operatörü', x-15, y-5, w+x-15, h+y-5, tocolor(r,g,b),1,fonts[10],'right','bottom')
				end
				dxDrawText(v[2]..':', x+5, y+5, w, h, tocolor(255,255,255),1, fonts[4], 'left', 'top')
				dxDrawText(v[3], x+5, y+17, w, h, tocolor(255,255,255,220),1, fonts[5], 'left', 'top')
			end
		end
	end
)