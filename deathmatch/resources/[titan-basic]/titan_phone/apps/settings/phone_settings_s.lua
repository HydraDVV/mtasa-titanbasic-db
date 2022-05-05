-- @Hanz

function updatePhoneSetting(fromPhone, index, value)
	fromPhone = tonumber(fromPhone)
	if fromPhone and index and value then
		return dbExec(mysql:getDBConnection(), "UPDATE `phones` SET `"..index.."`='"..(value).."' WHERE `phonenumber`='"..fromPhone.."' ")
	end
end
addEvent("phone:updatePhoneSetting", true)
addEventHandler("phone:updatePhoneSetting", root, updatePhoneSetting)

function activatePrivateNumber(fromPhone, cost)
	
end
addEvent("phone:activatePrivateNumber", true)
addEventHandler("phone:activatePrivateNumber", root, activatePrivateNumber)

function requestPhoneSettingsFromServer(fromPhone)
	triggerClientEvent(source, "phone:updateClientPhoneSettingsFromServer", source, fromPhone, {fromPhone, getPhoneSettings(fromPhone, true)})
end
addEvent("phone:requestPhoneSettingsFromServer", true)
addEventHandler("phone:requestPhoneSettingsFromServer", root, requestPhoneSettingsFromServer)

