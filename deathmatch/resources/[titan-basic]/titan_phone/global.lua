function canPlayerCall(thePlayer)
	local phoneState = getElementData(thePlayer, "phonestate") or 0
	local restrain = getElementData(thePlayer, "restrain") or 0
	local injuriedanimation = getElementData(thePlayer, "injuriedanimation")
	local reconx = getElementData(thePlayer, "reconx") 
	local calling = getElementData(thePlayer, "calling")
	local loggedin = getElementData(thePlayer, "loggedin")
	if restrain ~= 0 or phoneState > 0 or injuriedanimation or reconx or calling or isPedDead(thePlayer) or loggedin~=1 then
		return false
	end 
	return true
end

function canPlayerPhoneRing(thePlayer)
	local phoneState = getElementData(thePlayer, "phonestate") or 0
	local reconx = getElementData(thePlayer, "reconx") 
	local calling = getElementData(thePlayer, "calling")
	if phoneState > 0 or reconx or calling then
		return false
	end 
	return true
end
function canPlayerAnswerCall(thePlayer)
	local phoneState = getElementData(thePlayer, "phonestate") or 0
	local restrain = getElementData(thePlayer, "restrain") or 0
	local injuriedanimation = getElementData(thePlayer, "injuriedanimation")
	local reconx = getElementData(thePlayer, "reconx") 
	local called = getElementData(thePlayer, "called")
	local loggedin = getElementData(thePlayer, "loggedin")
	if restrain ~= 0 or phoneState ~= 3 or injuriedanimation or reconx or not called or isPedDead(thePlayer) or loggedin~=1 then
		return false
	end 
	return true
end

function canPlayerSlidePhoneIn(thePlayer)
	local phoneState = getElementData(thePlayer, "phonestate") or 0
	local restrain = getElementData(thePlayer, "restrain") or 0
	local injuriedanimation = getElementData(thePlayer, "injuriedanimation")
	local reconx = getElementData(thePlayer, "reconx") 
	local called = getElementData(thePlayer, "called")
	local loggedin = getElementData(thePlayer, "loggedin")
	if restrain ~= 0 or injuriedanimation or isPedDead(thePlayer) or loggedin~=1 then
		return false
	end 
	return true
end

function setED(e, i, n, s) 
	return setElementData(e, i, n, s)
end

function getED(e, i)
	return getElementData(e, i)
end

function isQuitType(action)
	return action == "Unknown" or action == "Quit" or action == "Kicked" or action == "Banned" or action == "Bad Connection" or action == "Timed out"
end

ringtones = {
	[1]	= "components/sounds/ringtones/viberate.mp3",
	[2]	= "components/sounds/ringtones/iphone_5s.mp3",
	[3] = "components/sounds/ringtones/iphone_6.mp3",
	[4] = "components/sounds/ringtones/minion_ring_ring.mp3",
	[5] = "components/sounds/ringtones/perfect_ring_tone.mp3",
	[6] = "components/sounds/ringtones/sending_you_an_sms.mp3",
	[7] = "components/sounds/ringtones/sms.mp3",
	[8] = "components/sounds/ringtones/sms_new.mp3",
	[9] = "components/sounds/ringtones/sony_xperia_z3.mp3",
	[10] = "components/sounds/ringtones/sweetest_tone_ever.mp3",
	[11] = "components/sounds/ringtones/turn_down_for_what.mp3",
	[12] = "components/sounds/ringtones/vertu_new_tone.mp3",
	[13] = "components/sounds/ringtones/winggle_wiggle.mp3",
	[14] = "components/sounds/ringtones/apple_ring.mp3",
	[15] = "components/sounds/ringtones/google.mp3",
}

function removeNewLine(string)
	return string.gsub(string, "\n", " ")
end