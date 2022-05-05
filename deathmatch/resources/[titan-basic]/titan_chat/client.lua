bindKey("b", "down", "chatbox", "LocalOOC")
bindKey ("u" , "down" , "chatbox", "quickreply")

data = { }
function datachange(value)
	if (data[value] == nil) then
		data[value] = 1
	else
		data[value] = data[value] + 1
	end
end
addEventHandler("onClientElementDataChange", getRootElement(), datachange)

function playRadioSound()
	playSoundFrontEnd(47)
	setTimer(playSoundFrontEnd, 700, 1, 48)
	setTimer(playSoundFrontEnd, 800, 1, 48)
end
addEvent( "playRadioSound", true )
addEventHandler( "playRadioSound", getRootElement(), playRadioSound )

function playCustomChatSound(sound)
	playSound("sound/"..tostring(sound), false)
end
addEvent( "playCustomChatSound", true )
addEventHandler( "playCustomChatSound", getRootElement(), playCustomChatSound )

function playHQSound()
	playSoundFrontEnd(1)
	setTimer(playSoundFrontEnd, 300, 1, 1)
end
addEvent("playHQSound", true)
addEventHandler("playHQSound", getRootElement(), playHQSound)

function playPmSound()
local pmsound = playSound("sound/pmSoundFX.wav",false)
setSoundVolume(pmsound, 0.9)
end
addEvent("pmSoundFX",true)
addEventHandler("pmSoundFX",getRootElement(),playPmSound)

