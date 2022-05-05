local rot = 0
local alpha = 200
local alphaState = "down"
local imgrot = 0
local img = 3
local destroyTimer
local loadingText = ""
local bgb_alpha = 255
local bgb_state = "-"
local sx, sy = guiGetScreenSize()
local playerCharacters = {};
local browser = guiCreateBrowser(0, 60, sx, sy, true, true, false)
guiSetVisible(browser, false)
local theBrowser = guiGetBrowser(browser)

local x1, y1, z1, x1t, y1t, z1t = 784.7138671875, -1289.900390625, 13.5625, -1546.3354492188, 1351.4052734375, 230
local x2, y2, z2, x2t, y2t, z2t = -1546.3354492188, 1351.4052734375, 230, 1546.3354492188, -1351.4052734375, 230

local animation = {}
animation.alpha = {}
animation.step = 1
for i=1, 5 do
	animation.alpha[i] = 0
end

function renderGTAVLoading()
	if alphaState == "down" then
		alpha = alpha - 2
		if alpha <= 100 then
			alphaState = "up"
			if changeTextTo then
				loadingText = changeTextTo
			end
		end
	else
		alpha = alpha + 2
		if alpha >= 200 then
			alphaState = "down"
		end
	end
	--dxDrawText(loadingText,0+10,0,sx,sy,tocolor(255,255,255,alpha),1,RobotoFont,"center","center")
	if rot > 360 then rot = 0 end
	rot = rot + 5
	local minusX = dxGetTextWidth(loadingText)
	--dxDrawImage(sx/2,sy/2,32,32,"img/loading.png",rot)
end
addEventHandler("accounts:login:request", getRootElement(),
	function ()
		setElementDimension ( localPlayer, 0 )
		setElementInterior( localPlayer, 0 )
		--setElementPosition( localPlayer, -262, -1143, 24)
		--setCameraMatrix(-262, -1143, 24, -97, -1167, 2)
		setElementPosition( localPlayer, unpack( defaultCharacterSelectionSpawnPosition ) )

		guiSetInputEnabled(true)
		clearChat()
		triggerServerEvent("onJoin", localPlayer)
		--LoginScreen_openLoginScreen()
	end
);

local wLogin, lUsername, tUsername, lPassword, tPassword, chkRememberLogin, bLogin, bRegister--[[, updateTimer]] = nil
local Exclusive = {}
function LoginScreen_openLoginScreen(title)
	--open_log_reg_pannel()
	Exclusive.loginStart()
end
addEvent("beginLogin", true)
addEventHandler("beginLogin", getRootElement(), LoginScreen_openLoginScreen)

local warningBox, warningMessage, warningOk = nil
local errorMain = {
    button = {},
    window = {},
    label = {}
}
function LoginScreen_showWarningMessage( message )
	if (isElement(errorMain.window[1])) then
		destroyElement(errorMain.window[1])
	end

	errorMain.window[1] = guiCreateWindow(538, 376, 432, 172, "Hata Penceresi", false)
    guiWindowSetSizable(errorMain.window[1], false)
    guiWindowSetMovable(errorMain.window[1], false)
    exports.titan_global:centerWindow(errorMain.window[1]);

    errorMain.label[1] = guiCreateLabel(10, 28, 412, 96, message, false, errorMain.window[1])
    guiLabelSetHorizontalAlign(errorMain.label[1], "center", false)
    guiLabelSetVerticalAlign(errorMain.label[1], "center")
    errorMain.button[1] = guiCreateButton(9, 128, 413, 34, "Tamam", false, errorMain.window[1])
    addEventHandler("onClientGUIClick", errorMain.button[1], function() destroyElement(errorMain.window[1]) end )

	guiBringToFront(errorMain.window[1])
end
addEventHandler("accounts:error:window", getRootElement(), LoginScreen_showWarningMessage)

addEvent("accounts:recieveCharacterlist", true)
addEventHandler("accounts:recieveCharacterlist", root,
	function(list)
		localPlayer:setData("account:characters", list)
		playerCharacters = list
	end
)

addEventHandler("accounts:login:attempt", getRootElement(),
	function (statusCode, additionalData, pChars)
		if (statusCode == 0) then
			if (isElement(warningBox)) then
				destroyElement(warningBox)
			end
			local newAccountHash = localPlayer:getData("account:newAccountHash")
			characterList = localPlayer:getData("account:characters") or playerCharacters
			--Characters_showSelection()
			guiSetVisible(browser, false)
		    --exports.titan_hud:stopBlackWhite();

			--Exclusive.drawnCharacters(characterList)
			loadCharacterSelector(characterList)
		

		elseif (statusCode > 0) and (statusCode < 5) then
			LoginScreen_showWarningMessage( additionalData )
		elseif (statusCode == 5) then
			LoginScreen_showWarningMessage( additionalData )
		end
	end
)

local function onResourceStart()
	--clearChat()
	setPlayerHudComponentVisible("weapon", false)
	setPlayerHudComponentVisible("ammo", false)
	setPlayerHudComponentVisible("vehicle_name", false)
	setPlayerHudComponentVisible("money", false)
	setPlayerHudComponentVisible("clock", false)
	setPlayerHudComponentVisible("health", false)
	setPlayerHudComponentVisible("armour", false)
	setPlayerHudComponentVisible("breath", true)
	setPlayerHudComponentVisible("area_name", false)
	setPlayerHudComponentVisible("radar", false)
	setPlayerHudComponentVisible("crosshair", true)

	engineSetAsynchronousLoading(true, true)
	setWorldSpecialPropertyEnabled("extraairresistance", false)
	setAmbientSoundEnabled( "gunfire", false )
	setDevelopmentMode( false )
	setPedTargetingMarkerEnabled(false) -- Adams
	guiSetInputMode("no_binds_when_editing")
	triggerServerEvent( "accounts:login:request", getLocalPlayer() )
end
addEventHandler( "onClientResourceStart", getResourceRootElement( ), onResourceStart )

--[[ XML STORAGE ]]--
local oldXmlFileName = "settings.xml"
local migratedSettingsFile = "@migratedsettings.empty"
local xmlFileName = "@settings.xml"
function loadSavedData(parameter, default)
	-- migrate existing settings
	if not fileExists(migratedSettingsFile) then
		if not fileExists(xmlFileName) and fileExists(oldXmlFileName) then
			fileRename(oldXmlFileName, xmlFileName)
		end
		fileClose(fileCreate(migratedSettingsFile))
	end
	local xmlRoot = xmlLoadFile( xmlFileName )
	if (xmlRoot) then
		local xmlNode = xmlFindChild(xmlRoot, parameter, 0)
		if xmlNode then
			return xmlNodeGetValue(xmlNode)
		end
	end
	return default or false
end

function appendSavedData(parameter, value)
	localPlayer:setData(parameter, value, false)
	local xmlFile = xmlLoadFile ( xmlFileName )
	if not (xmlFile) then
		xmlFile = xmlCreateFile( xmlFileName, "login" )
	end

	local xmlNode = xmlFindChild (xmlFile, parameter, 0)
	if not (xmlNode) then
		xmlNode = xmlCreateChild(xmlFile, parameter)
	end
	xmlNodeSetValue ( xmlNode, value )
	xmlSaveFile(xmlFile)
	xmlUnloadFile(xmlFile)
end

local BizNoteFont18 = dxCreateFont ( ":titan_fonts/files/Roboto.ttf" , 18 )

fontType = {-- (1)font (2)scale offset
	["default"] = {"default", 1},
	["default-bold"] = {"default-bold",1},
	["clear"] = {"clear",1.1},
	["arial"] = {"arial",1},
	["sans"] = {"sans",1.2},
	["pricedown"] = {"pricedown",3},
	["bankgothic"] = {"bankgothic",4},
	["diploma"] = {"diploma",2},
	["beckett"] = {"beckett",2},
	["BizNoteFont18"] = {"BizNoteFont18",1.1},
}

function loadSavedData2(parameter)

	for key, font in pairs(fontType) do
		local value = loadSavedData(parameter, font[1])
		if value then
			return value
		end
	end

	return false
end

--[[ END XML STORAGE ]]--

--[[ START ANIMATION STUFF ]]--
local happyAnims = {
	{ "ON_LOOKERS", "wave_loop"}
}

local idleAnims = {
	{ "PLAYIDLES", "shift"},
	{ "PLAYIDLES", "shldr"},
	{ "PLAYIDLES", "stretch"},
	{ "PLAYIDLES", "strleg"},
	{ "PLAYIDLES", "time"}
}

local danceAnims = {
	{ "DANCING", "dance_loop" },
	{ "STRIP", "strip_D" },
	{ "CASINO", "manwinb" },
	{ "OTB", "wtchrace_win" }
}

local deathAnims = {
	{ "GRAVEYARD", "mrnF_loop" },
	{ "GRAVEYARD", "mrnM_loop" }
}

function getRandomAnim( animType )
	if (animType == 1) then -- happy animations
		return happyAnims[ math.random(1, #happyAnims) ]
	elseif (animType == 2) then -- idle animations
		return idleAnims[ math.random(1, #idleAnims) ]
	elseif (animType == 3) then -- idle animations
		return danceAnims[ math.random(1, #danceAnims) ]
	elseif (animType == 4) then -- death animations
		return deathAnims[ math.random(1, #deathAnims) ]
	end
end

function clearChat()
	local lines = getChatboxLayout()["chat_lines"]
	for i=1,lines do
		outputChatBox("")
	end
end
addCommandHandler("clearchat", clearChat)

function applyClientConfigSettings()

	local borderVeh = tonumber( loadSavedData("borderVeh", "1") )
	localPlayer:setData("borderVeh", borderVeh, false)

	local bgVeh = tonumber( loadSavedData("bgVeh", "1") )
	localPlayer:setData("bgVeh", bgVeh, false)

	local bgPro = tonumber( loadSavedData("bgPro", "1") )
	localPlayer:setData("bgPro", bgPro, false)

	local borderPro = tonumber( loadSavedData("borderPro", "1") )
	localPlayer:setData("borderPro", borderPro, false)

	local enableOverlayDescription = tonumber( loadSavedData("enableOverlayDescription", "1") )
	localPlayer:setData("enableOverlayDescription", enableOverlayDescription or 1, false)

	local enableOverlayDescriptionVeh = tonumber( loadSavedData("enableOverlayDescriptionVeh", "1") )
	localPlayer:setData("enableOverlayDescriptionVeh", enableOverlayDescriptionVeh or 1, false)

	local enableOverlayDescriptionVehPin = tonumber( loadSavedData("enableOverlayDescriptionVehPin", "1") )
	localPlayer:setData("enableOverlayDescriptionVehPin", enableOverlayDescriptionVehPin, false)

	local enableOverlayDescriptionPro = tonumber( loadSavedData("enableOverlayDescriptionPro", "1") )
	localPlayer:setData("enableOverlayDescriptionPro", enableOverlayDescriptionPro or 1, false)

	local enableOverlayDescriptionProPin = tonumber( loadSavedData("enableOverlayDescriptionProPin", "1") )
	localPlayer:setData("enableOverlayDescriptionProPin", enableOverlayDescriptionProPin or 1, false)

	local cFontPro = loadSavedData2("cFontPro")
	localPlayer:setData("cFontPro", cFontPro or "BizNoteFont18", false)

	local cFontVeh = loadSavedData2("cFontVeh")
	localPlayer:setData("cFontVeh", cFontVeh or "default", false)

	local blurEnabled = tonumber( loadSavedData("motionblur", "1") )
	if (blurEnabled == 1) then
		setBlurLevel(38)
	else
		setBlurLevel(0)
	end

	local skyCloudsEnabled = tonumber( loadSavedData("skyclouds", "1") )
	if (skyCloudsEnabled == 1) then
		setCloudsEnabled ( true )
	else
		setCloudsEnabled ( false )
	end

	local streamingMediaEnabled = tonumber(loadSavedData("streamingmedia", "1"))
	if streamingMediaEnabled == 1 then
		localPlayer:setData("streams", 1, true)
	else
		localPlayer:setData("streams", 0, true)
	end

	local phone_anim = tonumber(loadSavedData("phone_anim", "1"))
	if phone_anim == 1 then
		localPlayer:setData("phone_anim", 1, true)
	else
		localPlayer:setData("phone_anim", 0, true)
	end
end

blackMales = {66,311}
whiteMales = {29,30,60,122,124,125,153,236,240,292}
asianMales = {258,294}
blackFemales = {90}
whiteFemales = {41,45,55,56,91,93}
asianFemales = {40,92}

local screenX, screenY = guiGetScreenSize( )
local label = guiCreateLabel( 0, 0, screenX, 15,"#version:nightly", false )
guiSetSize( label, guiLabelGetTextExtent( label ) + 5, 14, false )
guiSetPosition( label, screenX - guiLabelGetTextExtent( label ) - 5, screenY - 27, false )
guiSetAlpha( label, 0.5 )

addEventHandler('onClientMouseEnter', label, function()
	guiSetAlpha(label, 1)
end, false)

addEventHandler('onClientMouseLeave', label, function()
	guiSetAlpha(label, 0.5)
end, false)

function stopNameChange(oldNick, newNick)
	if (source==getLocalPlayer()) then
		local legitNameChange = getElementData(getLocalPlayer(), "legitnamechange")

		if (oldNick~=newNick) and (legitNameChange==0) then
			triggerServerEvent("resetName", getLocalPlayer(), oldNick, newNick)
			outputChatBox("Karakterinizi değiştirmek isterseniz, karakteri değiştir seçeneğine tıklayın.", 255, 0, 0)
		end
	end
end
addEventHandler("onClientPlayerChangeNick", getRootElement(), stopNameChange)

function update_updateElementData(theElement, theParameter, theValue)
	if (theElement) and (theParameter) then
		if (theValue == nil) then
			theValue = false
		end
		theElement:setData(theParameter, theValue, false)
	end
end
addEventHandler("edu", getRootElement(), update_updateElementData)
	
	function Exclusive.loginStart()
		time = 200000/1.5
		lastClick = 0
		bgMusic = playSound("img/hanzmusic.mp3", true)
		setSoundVolume(bgMusic, 1)
		localPlayer:setData("bgMusic", bgMusic , false)
		fadeCamera ( true, 1, 0,0,0 );	
	
	setCameraMatrix(627.9228515625, -1885.787109375, 7.6546840667725,689.4541015625, -1835.0703125, 13.654700279236);
	
	airRotation, oldAirRotation, airYRotation = 90, 0, 0
	
	setCloudsEnabled(false)
	cameraMatrix, cameraMatrix2 = 0, 0;
	showCursor(true)
	showChat(false)
	addEventHandler("onClientRender", root, drawnLogin)
end

addEvent("hideLoginWindow", true)
addEventHandler("hideLoginWindow", root,
	function()
		--stopSmoothMoveCamera()
		guiSetVisible(browser, false)

		--triggerEvent( 'hud:blur', resourceRoot, 'off' )
		removeEventHandler("onClientRender", root, drawnLogin)
	end
)

addEventHandler("onClientBrowserCreated", theBrowser, 
	function()
		setDevelopmentMode(true,true)
		loadBrowserURL(source, "http://mta/local/html/index.html")
	end
)
-- sendJS(fonksiyonadı, fonksiyon argları)
function sendJS(functionName, ...)
	if (not theBrowser) then
		outputDebugString("Browser is not loaded yet, can't send JS.")
		return false
	end

	local js = functionName.."("
	local argCount = #arg
	for i, v in ipairs(arg) do
		local argType = type(v)
		if (argType == "string") then
			js = js.."'"..addslashes(v).."'"
		elseif (argType == "boolean") then
			if (v) then js = js.."true" else js = js.."false" end
		elseif (argType == "nil") then
			js = js.."undefined"
		elseif (argType == "table") then
			--
		elseif (argType == "number") then
			js = js..v
		elseif (argType == "function") then
			js = js.."'"..addslashes(tostring(v)).."'"
		elseif (argType == "userdata") then
			js = js.."'"..addslashes(tostring(v)).."'"
		else
			outputDebugString("Unknown type: "..type(v))
		end

		argCount = argCount - 1
		if (argCount ~= 0) then
			js = js..","
		end
	end
	js = js .. ");"

	executeBrowserJavascript(theBrowser, js)
end

function addslashes(s)
	local s = string.gsub(s, "(['\"\\])", "\\%1")
	s = string.gsub(s, "\n", "")
	return (string.gsub(s, "%z", "\\0"))
end

function drawnLogin()

	dxDrawRectangle(0, 0, sx, sy, tocolor(5, 5, 5, 120))
		w, h = 376, 81
		if isInBox(10, sy-12, w, h) then
			if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
				lastClick = getTickCount()
				stopSound(bgMusic)
				-- destroyElement(webBrowser)
			end
		end	
	if bgb_state == "-" then
		bgb_alpha = bgb_alpha - 2
		if bgb_alpha <= 130 then
			bgb_alpha = 130
			bgb_state = "+"
		end
	elseif bgb_state == "+" then
		bgb_alpha = bgb_alpha + 2
		if bgb_alpha >= 255 then
			bgb_alpha = 255
			bgb_state = "-"
		end
	end

	if animation.step == 1 then--text
		animation.alpha[animation.step] = animation.alpha[animation.step] + 4
		if animation.alpha[animation.step] > 955 then
			animation.alpha[animation.step] = 0
			animation.step = 2
		end
		dxDrawText("[titan-mta.com] | version:nightly", 2, 2, sx, sy, tocolor(5, 5, 5, math.min(255, animation.alpha[animation.step])), 2, "diploma", 'center', 'center')
		dxDrawText("[titan-mta.com] | version:nightly", 0, 0, sx, sy, tocolor(250,255,255, math.min(255, animation.alpha[animation.step])), 2, "diploma", 'center', 'center')
	elseif animation.step == 2 then--text
		animation.alpha[animation.step] = animation.alpha[animation.step] + 4
		if animation.alpha[animation.step] > 955 then
			animation.alpha[animation.step] = 0
			animation.step = 3
		end
	elseif animation.step == 3 then--logo
		animation.alpha[animation.step] = animation.alpha[animation.step] + 4
		if animation.alpha[animation.step] > 455 then
			animation.alpha[animation.step] = 0
			animation.step = 5
			guiSetVisible(browser, true)
		end
		
		if animation.text then
			dxDrawText(animation.text, 0, 0, sx, sy+450, tocolor(255, 255, 255), 2, "diploma", 'center', 'center')
		end
	end
end

addEvent("sign-in", true)
addEventHandler("sign-in", root,
	function(username, password)
		access, code = checkVariables(1, username, password)
		if access then
			triggerServerEvent("accounts:login:attempt", getLocalPlayer(), username, password, false)
			destroyElement (webBrowser)
			removeEventHandler ("onClientRender", getRootElement(), webBrowserRender)
			-- webBrowser = false
--			exports["titan_infobox"]:addBox("success", "Başarıyla hesabına giriş yaptın.")
		else
			Error_msg("Everyone", code);
		end
	end
);

addEvent("register", true)
addEventHandler("register", root,
	function(username, password, email)
		access, code = checkVariables(2, username, password)
		if access then
			exports["titan_infobox"]:addBox("success", "Başarıyla "..username.." isimli hesabın sahibi oldun.")
			triggerServerEvent("accounts:register:attempt",getLocalPlayer(),username,password,password,email)
		else
			Error_msg("Everyone", code);
		end
	end
);

function Error_msg(Page, message_text)
	--animation.text = message_text;
	-- alert_text kısmı. 
	sendJS("error", message_text); -- dene
end
addEvent("set_warning_text", true)
addEventHandler("set_warning_text", root, Error_msg)
addEvent("set_authen_text", true)
addEventHandler("set_authen_text", root, Error_msg)

function checkVariables(page, username, password)
	if page == 1 then
		if username == "" then
			return false,"Kullanıcı adı boş kalmamalıdır.","blue"
		end

		if password == "" then
			return false,"Şifre boş kalmamalıdır.","blue"
		end

		return true
	elseif page == 2 then
		if username == "" then
			return false,"Kullanıcı adı boş kalmamalıdır!","blue"
		end
		if password == "" then
			return false,"Şifre boş kalmamalıdır!","blue"
		end
		
		if string.find(password, "'") or string.find(password, '"') then
			return false,"Şifrenizde istenmeyen karakter saptandı!","red"
		end
		if string.match(username,"%W") then
			return false,"Kullanıcı adınızda istenmeyen karakter saptandı!","red"
		end
		
		if string.len(password) < 8 then
			return false,"Girdiğiniz şifre en az 8 karakter olmalıdır!","red"
		end
		if string.len(password) > 16 then
			return false,"Girdiğiniz şifre en fazla 16 karakter olmalıdır!","red"
		end
		if string.len(password) < 3 then
			return false,"Girdiğiniz kullanıcı adı en az 3 karakter olmalıdır!","red"
		end
		
		return true
	end
end

function passwordHash(password)
    local length = utfLen(password)

    if length > 23 then
        length = 23
    end
    return string.rep("", length)
end

function getCameraRotation()
	cam = Camera.matrix:getRotation():getZ()
	--cam = tonumber(string.format("%.0f",cam/90))*90
	return cam
end

function Characters_showSelection()
	loadCharacterSelector(getElementData(localPlayer, "account:characters"))
end

local renderData = {
	username = "",
	password = "",
	passwordHidden = "",
	email = "",
	password2 = "",
	password2Hidden = "",
	activeFakeInput = "username",
	canUseFakeInputs = false,
	buttons = {},
	activeButton = false,
	rememberMe = false
}

local maxCreatableChar = 1
local logoSize = 128 * (1 / 75)

local localCharacters = {}
local characterVeriables = {}
local pedData = {}
local pedID = {}



function loadCharacterSelector(characters)

    setElementDimension(localPlayer, 1)
	removeEventHandler("onClientRender", getRootElement(), onClientRender)
	removeEventHandler("onClientCharacter", getRootElement(), onClientCharacter)
	removeEventHandler("onClientKey", getRootElement(), onClientKey)
	removeEventHandler("onClientClick", getRootElement(), onClientClick)

	renderData.characterMakingActive = false

	selectedChar = 1
	pedData = localPlayer:getData("account:characters") or characters

	local playerDimension = getElementDimension(localPlayer)
		
	for k, v in ipairs(pedData) do
		localCharacters[k] = createPed(v[9], 1148.2672119141 - (k - 1) * 6, -1156.669921875, 23.828125, 0)
        characterVeriables[k] = v[2]
		pedID[k] = v[1]
		setElementDimension(localCharacters[k], playerDimension)
		setElementFrozen(localCharacters[k], true)
	end
	
	if not pedID[selectedChar] then
	  removeEventHandler("onClientRender", getRootElement(), characterSelectRender)
				removeEventHandler("onClientKey", getRootElement(), characterSelectKey)
				removeEventHandler("onClientCharacter", getRootElement(), characterSelectCharacter)

				for k,v in pairs(localCharacters) do
					if isElement(v) then
						destroyElement(v)
					end
					localCharacters[k] = nil
				end

				renderData.canUseFakeInputs = false
				renderData.inputDisabled = false

				addEventHandler("onClientRender", getRootElement(), onClientRender)
				addEventHandler("onClientCharacter", getRootElement(), onClientCharacter)
				addEventHandler("onClientKey", getRootElement(), onClientKey)
				addEventHandler("onClientClick", getRootElement(), onClientClick)
                
				startCharReg()
	  
    end
    if pedID[selectedChar] then
	setPedAnimation(localCharacters[1], "ON_LOOKERS", "wave_loop", -1, true, false, false)
	setCameraMatrix(1148.2672119141, -1150.2779541016, 31.311100006104, 1100.8375244141, -1150.2779541016, 31.311100006104)

	addEventHandler("onClientRender", getRootElement(), characterSelectRender)

	renderData.charCamX = 1148.2672119141
	renderData.charCamY = -1150.2779541016
	renderData.charCamZ = 31.311100006104
	renderData.charCamLX = 1148.2672119141
	renderData.charCamLY = -1150.2779541016
	renderData.charCamLZ = 31.311100006104
    
	renderData.charGotInterpolation = getTickCount()
	end
end

function karakterOlustur()
				Exclusive.destroyCharacters()
				newCharacter_init()
				end
				addCommandHandler("karakter", karakterOlustur)

	
	function characterSelectRender()
	
	local tickCount = getTickCount()

	if renderData.charSelectInterpolation then
		local progress = (tickCount - renderData.charSelectInterpolation) / 500

		renderData.charCamX = interpolateBetween(renderData.charCamStartX, 0, 0, renderData.charCamEndX, 0, 0, progress, "OutQuad")

		if progress >= 1 then
			renderData.charSelectInterpolation = false
		end
	end

	if renderData.charGotInterpolation and tickCount >= renderData.charGotInterpolation then
		local progress = (tickCount - renderData.charGotInterpolation) / 2000
		local pedX, pedY, pedZ = getElementPosition(localCharacters[1])

		renderData.charCamX, renderData.charCamY, renderData.charCamZ = interpolateBetween(1148.2672119141, -1150.2779541016, 31.311100006104, 1148.2672119141, -1150.2779541016, pedZ + 5, progress, "OutQuad")
		renderData.charCamLX, renderData.charCamLY, renderData.charCamLZ = interpolateBetween(1148.2672119141, -1150.2779541016, 31.311100006104, pedX, pedY, pedZ, progress, "OutQuad")

		if progress >= 1 then
			renderData.charGotInterpolation = false

			addEventHandler("onClientKey", getRootElement(), characterSelectKey)
		end
	end

	setCameraMatrix(renderData.charCamX, renderData.charCamY, renderData.charCamZ, renderData.charCamX, renderData.charCamLY, renderData.charCamLZ)


	for i = 1, #pedData do
		if isElement(localCharacters[i]) then
	 		local pedX, pedY, pedZ = getElementPosition(localCharacters[i])
			pedZ = pedZ - 0.99

			if selectedChar == i then
				dxDrawMaterialLine3D(pedX, pedY + logoSize / 2, pedZ, pedX, pedY - logoSize / 2, pedZ, logoTexture, logoSize, tocolor(255, 255, 255), pedX, pedY, pedZ + 10)
			else
				dxDrawMaterialLine3D(pedX, pedY + logoSize / 2, pedZ, pedX, pedY - logoSize / 2, pedZ, logoTexture, logoSize, tocolor(255, 255, 255), pedX, pedY, pedZ + 10)
			end
		end
	end

		local charName = characterVeriables[selectedChar]:gsub("_", " ")
		local nameWidth = dxGetTextWidth(charName, 1.85, "default-bold")

		dxDrawText(charName, 0, 0, screenX, screenY - 120, tocolor(255, 255, 255), 1.8, "default-bold", "center", "bottom")
		dxDrawRectangle((screenX - nameWidth) / 2, screenY - 120, nameWidth, 2, tocolor(255, 5, 5))
		local charLimit = getElementData(localPlayer, "charlimit")

		if #pedData > 1 then
			dxDrawText("Giriş yapmak için 'ENTER' tuşuna basınız.\n Yeni Karakter İçin 'SPACE' tuşuna basınız ", 0, 0, screenX, screenY - 60, tocolor(255, 255, 255), 1.6, "default-bold", "center", "bottom")

			local y = screenY - 80 + "default-bold"
			if  not (#getElementData(getLocalPlayer(), "account:characters") >= charLimit) then
				dxDrawText("Yeni karakter oluşturmak için 'SPACE' tuşuna basınız.", 0, 0, screenX, y, tocolor(255, 255, 255), 1, "default-bold", "center", "bottom")
			end

			dxDrawText("Karakterler arası geçiş yapmak için 'OK' tuşlarını kullan.", 0, 0, screenX, y, tocolor(255, 255, 255), 1, "default-bold", "center", "bottom")
		else
			dxDrawText("Giriş yapmak için 'ENTER' tuşuna basınız.\n Yeni Karakter İçin 'SPACE' tuşuna basınız.", 0, 0, screenX, screenY - 60, tocolor(255, 255, 255), 1.6, "default-bold", "center", "bottom")

			if not (#getElementData(getLocalPlayer(), "account:characters") >= charLimit) then
				dxDrawText("Yeni karakter oluşturmak için 'SPACE' tuşuna basınız.", 0, 0, screenX, screenY - 80 + "default-bold", tocolor(255, 255, 255), 1, "default-bold", "center", "bottom")
			else
			    dxDrawText("Karakter limitiniz yok.", 0, 0, screenX, screenY - 80 + "default-bold", tocolor(255, 255, 255), 1, "default-bold", "center", "bottom")
			end
		end
end

function characterSelectKey(key, state)
	if state then
		cancelEvent()
		
		pedData = localPlayer:getData("account:characters") or playerCharacters 

		if not renderData.charSelectInterpolation then
			if key == "arrow_l" and selectedChar > 1 then
				renderData.charCamStartX = 1148.2672119141 - (selectedChar - 1) * 6

				setPedAnimation(localCharacters[selectedChar])
				selectedChar = selectedChar - 1
			
				if selectedChar < 1 then
					selectedChar = 1
					characterVeriables[selectedChar] = selectedChar
				end
			
				setPedAnimation(localCharacters[selectedChar], "ON_LOOKERS", "wave_loop", -1, true, false, false)

				renderData.charCamEndX = 1148.2672119141 - (selectedChar - 1) * 6
				renderData.charSelectInterpolation = getTickCount()
			elseif key == "arrow_r" and selectedChar < #pedData then
				renderData.charCamStartX = 1148.2672119141 - (selectedChar - 1) * 6

				setPedAnimation(localCharacters[selectedChar])
				selectedChar = selectedChar + 1
			
				if selectedChar > #pedData then
					selectedChar = #pedData
                    characterVeriables[selectedChar] = selectedChar				
				end
			
				setPedAnimation(localCharacters[selectedChar], "ON_LOOKERS", "wave_loop", -1, true, false, false)

				renderData.charCamEndX = 1148.2672119141 - (selectedChar - 1) * 6
				renderData.charSelectInterpolation = getTickCount()
			elseif key == "enter" or key == "lshift" and not renderData.charGotSelected and selectedChar then
			renderData.charGotSelected = true
				if pedID[selectedChar] then
					if isElement(loginMusic) then
						destroyElement(loginMusic)
					end
					loginMusic = nil
							
					local spawnTime = math.random(7500, 10000)

					removeEventHandler("onClientRender", getRootElement(), characterSelectRender)
					removeEventHandler("onClientKey", getRootElement(), characterSelectKey)
					
					triggerServerEvent("accounts:characters:spawn", localPlayer, pedID[selectedChar])


					showCursor(false)
					
					renderData.charGotSelected = false
					
					for k,v in pairs(localCharacters) do
						if isElement(v) then
							destroyElement(v)
						end
						localCharacters[k] = nil
					end
				else
					renderData.charGotSelected = false
					
				end
			elseif key == "space" and not renderData.charGotSelected and not (#getElementData(getLocalPlayer(), "account:characters") >= getElementData(getLocalPlayer(), "charlimit")) then
				removeEventHandler("onClientRender", getRootElement(), characterSelectRender)
				removeEventHandler("onClientKey", getRootElement(), characterSelectKey)
				removeEventHandler("onClientCharacter", getRootElement(), characterSelectCharacter)

				for k,v in pairs(localCharacters) do
					if isElement(v) then
						destroyElement(v)
					end
					localCharacters[k] = nil
				end

				renderData.canUseFakeInputs = false
				renderData.inputDisabled = false

				addEventHandler("onClientRender", getRootElement(), onClientRender)
				addEventHandler("onClientCharacter", getRootElement(), onClientCharacter)
				addEventHandler("onClientKey", getRootElement(), onClientKey)
				addEventHandler("onClientClick", getRootElement(), onClientClick)

				startCharReg()
			else
                outputChatBox(exports["titan_pool"]:getServerName()..": #f9f9f9Karakter Limit Artırıcı Almak için /market.", 255, 0, 0, true)			
			end
		end
	end
end


function Exclusive.destroyCharacters()
	removeEventHandler("onClientRender", root, drawnCharacters);
end

function DeleteMoneyItem(thePlayer)
    if exports.titan_global:hasItem(thePlayer, 134) then
	    takeItem(thePlayer, 134)
	end
end

function characters_onSpawn(fixedName, adminLevel, gmLevel, location)
	clearChat()
	showChat(true)
	guiSetInputEnabled(false)
	showCursor(false)
	showCursor(false)
	img = 1
	fadeCamera(false, 0.1)
	showCursor(false)
	addEventHandler("onClientRender", root, renderGTAVLoading)
	setTimer(
		function()
		removeEventHandler("onClientRender", root, renderGTAVLoading)
		fadeCamera ( true, 1, 0,0,0 );
		for i=1, 15 do
			outputChatBox(" ")
		end
		showCursor(false)
		exports["titan_infobox"]:addBox("success", "Sunucuyla bağlantın başarıyla kuruldu.Arayüzleri aktif etmek için. '/samp' ")
		
		triggerServerEvent("item-system:deletemoney", getLocalPlayer(), getLocalPlayer())

		outputChatBox(" ")

		bgMusic = getElementData(localPlayer, "bgMusic")
		if isElement(bgMusic) then
			destroyElement(bgMusic)
		end
		localPlayer:setData("admin_level", adminLevel, false)
		localPlayer:setData("account:gmlevel", gmLevel, false)

		options_enable()
	end,
	8500,1)
end
addEvent("account:character:spawned", true)
addEventHandler("accounts:characters:spawn", getRootElement(), characters_onSpawn)


function isInBox(startX, startY, sizeX, sizeY)
    if isCursorShowing() then
        local cursorPosition = {getCursorPosition()};
        cursorPosition.x, cursorPosition.y = cursorPosition[1] * sx, cursorPosition[2] * sy

        if cursorPosition.x >= startX and cursorPosition.x <= startX + sizeX and cursorPosition.y >= startY and cursorPosition.y <= startY + sizeY then
            return true
        else
            return false
        end
    else
        return false
    end
end

function toRGBA(color)
    local r = bitExtract(color, 16, 8 ) 
    local g = bitExtract(color, 8, 8 ) 
    local b = bitExtract(color, 0, 8 ) 
    local a = bitExtract(color, 24, 8 ) 
    return r, g, b, a;
end

function stringToRGBA(string)
    local r = tonumber(string:sub(2, 3), 16);
    local g = tonumber(string:sub(4, 5), 16);
    local b = tonumber(string:sub(6, 7), 16);
    local a = 0;
    if string:len() == 7 then
        a = 255;
    else
        a = tonumber(string:sub(8, 9), 16);
    end
    return r, g, b, a;
end

function stringToColor(string)
    local r, g, b, a = stringToRGBA(string);
    return tocolor(r, g, b, a);
end

function colorDarker(color, factor)
    local r, g, b, a = toRGBA(color);
    r = r * factor;
    if r > 255 then r = 255; end
    g = g * factor;
    if g > 255 then g = 255; end
    b = b * factor;
    if b > 255 then b = 255; end
    return tocolor(r, g, b, a);
end


local Window = {}
local Button = {}
local Label = {}
local Edit = {}

function showEmailUpdate()
	showCursor(true)
	Window[1] = guiCreateWindow(0.3562,0.3997,0.2891,0.2383,"E-Posta Değiştirme Sistemi",true)
		guiSetInputEnabled ( true)
		Label[1] = guiCreateLabel(0.0378,0.153,0.9324,0.2404,"Güvenliğiniz nedeniyle ve sizlere bildiri göndermemiz amacıyla\ne-posta adresinizi girmenizi istiyoruz.\nBildirimlerden haberdar olmak için ve güncel haberleri\nöğrenmek için bilgileri doldur. ",true,Window[1])
			guiLabelSetColor(Label[1],210,210,210)
			guiLabelSetHorizontalAlign(Label[1],"center",false)
		Edit[1] = guiCreateEdit(0.2341,0.4781+0.100,0.5351,0.1475,"",true,Window[1])
		Label[2] = guiCreateLabel(0.32,0.4054+0.100,0.3432,0.1038,"e-posta adresinizi aşağıya doldurun.",true,Window[1])
		guiLabelSetHorizontalAlign(Label[2],"center")
		Button[1] = guiCreateButton(0.02,0.8087,2.2857,0.1257,"Doğrula",true,Window[1])
			addEventHandler("onClientGUIClick", Button[1], function()
				triggerServerEvent("email:degistir", getLocalPlayer(), guiGetText(Edit[1]))
			end)
end
addEvent("email:GUI", true)
addEventHandler("email:GUI", getRootElement(), showEmailUpdate)
addCommandHandler("epostadegistir", showEmailUpdate)

function closeEmailUpdate()
	destroyElement(Window[1])
	showCursor(false)
	guiSetInputEnabled ( false)
end
addEvent("email:GUIClose", true)
addEventHandler("email:GUIClose", getRootElement(), closeEmailUpdate)

