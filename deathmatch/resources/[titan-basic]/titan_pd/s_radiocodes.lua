local mysql = exports.titan_mysql

function refreshPdCodes()
   local content = {}
   dbQuery(
   		function(qh, client)
   			local res, rows, err = dbPoll(qh, 0)
   			if rows > 0 then
   				for index, row in ipairs(res) do
   					content.codes[#content.codes + 1] = row["value"]
   				end
   				dbQuery(
   					function(qh, client)
   						local res, rows, err = dbPoll(qh, 0)
   						if rows > 0 then
   							for index, row in ipairs(res) do
			   					content.procedures[#content.procedures + 1] = row["value"]
			   				end
   							triggerClientEvent(client, "displayPdCodes", client, content)
   						end
   					end,
   				{client}, mysql:getConnection(), "SELECT `value` FROM `settings` WHERE `name`='pdprocedures' ")
   			end
   		end,
   {client}, mysql:getConnection(), "SELECT `value` FROM `settings` WHERE `name`='pdcodes' ")
end
addEvent("refreshPdCodes", true)
addEventHandler("refreshPdCodes", root, refreshPdCodes)

function updatePdCodes(contentFromClient)
	if contentFromClient then
		if contentFromClient.codes then
			if dbExec(mysql:getConnection(), "UPDATE `settings` SET `value`= '"..exports.titan_global:toSQL(contentFromClient.codes).."' WHERE `name`='pdcodes' ") then
				outputChatBox("Kodlar başarıyla kaydedildi.", client)
			end
		end
		if contentFromClient.procedures then
			if dbExec(mysql:getConnection(), "UPDATE `settings` SET `value`= '"..exports.titan_global:toSQL(contentFromClient.procedures).."' WHERE `name`='pdprocedures' ") then
				outputChatBox("Procedures saved successfully!", client)
			end
		end
	end
end
addEvent("updatePdCodes", true)
addEventHandler("updatePdCodes", getRootElement(), updatePdCodes)