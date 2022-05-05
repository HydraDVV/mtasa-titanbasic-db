
function Hanz()
	if exports["titan_integration"]:isPlayerSupporter(localPlayer) or exports["titan_integration"]:isPlayerTrialAdmin(localPlayer) then
		bindKey ("p" , "down" , "chatbox", "a")
		bindKey ("[" , "down" , "chatbox", "g")
		outputChatBox("[-]#f9f9f9 Sohbet kısayollarını başarıyla atadın.", 128, 155, 255, true)
		outputChatBox("P tuşu#f9f9f9 ile admin kanalında sohbet,", 128, 155, 255, true)
		outputChatBox("Ğ tuşu#f9f9f9 ile rehber kanalında sohbet edebilirsin.", 128, 155, 255, true)
	end
end
addCommandHandler("bindadmin", Hanz)

function nudgeNoise()
   local sound = playSound("components/sounds/pmsound.wav")   
   setSoundVolume(sound, 0.5) -- set the sound volume to 50%
end
addEvent("playNudgeSound", true)
addEventHandler("playNudgeSound", getLocalPlayer(), nudgeNoise)

function jailSound() -- Hanz
   local sound = playSound("components/sounds/jailsound.mp3")   
   setSoundVolume(sound, 0.3)
end
addEvent("playJailSound", true)
addEventHandler("playJailSound", getLocalPlayer(), jailSound)


function babaPatlat()
   local sound = playSound("components/sounds/nudge.wav")   
   setSoundVolume(sound, 0.5) -- set the sound volume to 50%
end
addEvent("durtmeSesi", true)
addEventHandler("durtmeSesi", getLocalPlayer(), babaPatlat)

function babaPatlat2()
   local sound = playSound("components/sounds/woman.mp3")   
   setSoundVolume(sound, 1) -- set the sound volume to 50%
end
addEvent("ahlayanSesi", true)
addEventHandler("ahlayanSesi", getLocalPlayer(), babaPatlat2)

function doEarthquake()
	local x, y, z = getElementPosition(getLocalPlayer()) 
	createExplosion(x, y, z, -1, false, 3.0, false)
end
addEvent("doEarthquake", true)
addEventHandler("doEarthquake", getLocalPlayer(), doEarthquake)

function streamASound(link)
	playSound(link)
end
addEvent("playSound", true)
addEventHandler("playSound", getRootElement(), streamASound)

function seeFar(localPlayer, value)
	if not value then outputChatBox("* "..exports["titan_pool"]:getServerName().." Roleplay * /seefar [value or -1 to reset it]") end
	if value and tonumber(value) >= 250 and tonumber(value) <= 20000 then
		setFarClipDistance(value)
		outputChatBox("Clip distance set to "..value..".")
	elseif value and tonumber(value) == -1 then
		resetFarClipDistance()
	else
		outputChatBox("Maximum value for render distance is 20000 and minimum is 250.")
	end
end
addCommandHandler("seefar", seeFar) 


function cargoGroupGenericPed(button, state, absX, absY, wx, wy, wz, element)
    if (element) and (getElementType(element)=="ped") and (button=="right") and (state=="down") then --if it's a right-click on a object
		local pedName = getElementData(element, "name") or "The Storekeeper"
		pedName = tostring(pedName):gsub("_", " ")

        local rcMenu
        if(pedName == "Michael Dupont") then 
            rcMenu = exports.titan_rightclick:create(pedName)
            local row = exports.titan_rightclick:addRow("Talk")
            addEventHandler("onClientGUIClick", row,  function (button, state)
            	if getElementData(localPlayer, "factionleader") == 1 and getElementData(localPlayer, "loggedin") == 1 and tostring(getTeamName(getPlayerTeam(localPlayer))) == "Cargo Group" then
                	triggerEvent("createCargoGUI", localPlayer)
                end
            end, false)

            local row2 = exports.titan_rightclick:addRow("Close")
            addEventHandler("onClientGUIClick", row2,  function (button, state)
                exports.titan_rightclick:destroy(rcMenu)
            end, false)
        end
    end
end
addEventHandler("onClientClick", getRootElement(), cargoGroupGenericPed, true)
