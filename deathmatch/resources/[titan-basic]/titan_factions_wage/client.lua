addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),
function()
	setTimer(sendWage, 60000*1*60, 0, getLocalPlayer())
end)


function sendWage()
	triggerServerEvent("wage:faction", localPlayer, localPlayer)
end