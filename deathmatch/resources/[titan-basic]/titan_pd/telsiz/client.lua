function playRadioSound()
	playSoundFrontEnd(47)
	setTimer(playSoundFrontEnd, 700, 1, 48)
	setTimer(playSoundFrontEnd, 800, 1, 48)
end
addEvent( "playRadioSound", true )
addEventHandler( "playRadioSound", getRootElement(), playRadioSound )