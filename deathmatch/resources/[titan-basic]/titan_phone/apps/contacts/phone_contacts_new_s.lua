-- @Hanz
local mysql = exports.titan_mysql

addEvent("phone:addContact", true)
function addPhoneContact(client, name, number, phoneBookPhone)
	if (client) then
		if not phoneBookPhone then
			triggerClientEvent(client, "phone:addContactResponse", client, false)
			return
		end
		
		if not exports.titan_global:hasItem(client,2, tonumber(phoneBookPhone)) then
			triggerClientEvent(client, "phone:slidePhoneOut", client)
			return
		end
		
		if name and number then
			if tonumber(number) then
				local insertedId = dbExec(mysql:getDBConnection(), "INSERT INTO `phone_contacts` (`phone`, `entryName`, `entryNumber`) VALUES ('" ..  (tostring(phoneBookPhone)).."', '".. (name) .."', '".. (number) .."')") 
				if insertedId then
					dbQuery(
						function(qh)
							local res, rows, err = dbPoll(qh, 0)
							if rows > 0 then
								local insertedId = res[1].id

								-- client yani oyuncyu
									
								triggerClientEvent(client, "phone:addContactResponse", client, insertedId, name, number)
							end
						end,
					mysql:getDBConnection(), "SELECT id FROM phone_contacts WHERE id=LAST_INSERT_ID()")
				
					return
				end
			end
		end

		outputChatBox("Internal Error! Code: RFS45235, please report this on http://bugs.owlgaming.net.", client, 255,0,0)
		triggerClientEvent(client, "phone:addContactResponse", client, false)
	end
end
addEventHandler("phone:addContact", getRootElement(), addPhoneContact)