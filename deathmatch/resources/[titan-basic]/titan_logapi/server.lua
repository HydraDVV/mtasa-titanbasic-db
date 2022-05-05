local mysql = exports.titan_mysql

addEvent("logapi.receiveLogs", true)
addEventHandler("logapi.receiveLogs", root, 
	function(plr, data)
		db = mysql:getConnection()

		if (data.type == 1) then--Karakter Adından LOG Bulma
			edittext, gridsource = data.edittext:gsub(" ", "_"), data.gridsource
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#ffffff Veritabanında aranıyor.", plr, 0, 255, 0, true)
			db:query(
				function(qh, plr)
					local res, rows, err = qh:poll(0)
					if rows > 0 then
						
						triggerLatentClientEvent(plr, "logapi.updateLogGrid", plr, 1, res)
					else
						triggerLatentClientEvent(plr, "logapi.foundSpamRemove", plr, data.type)
					end
				end,
			{plr}, "SELECT * FROM logs WHERE source = CONCAT('ch', (SELECT id FROM characters WHERE charactername = '"..edittext.."'))")
		elseif (data.type == 2) then--Silah Serialinden LOG Bulma
			edittext, gridsource = data.edittext:gsub("'", ""), data.gridsource
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#ffffff Veritabanında aranıyor.", plr, 0, 255, 0, true)
			db:query(
				function(qh, plr)
					local res, rows, err = qh:poll(0)
					if rows > 0 then
						
						triggerLatentClientEvent(plr, "logapi.updateLogGrid", plr, 2, res)
					else
						triggerLatentClientEvent(plr, "logapi.foundSpamRemove", plr, data.type)
					end
				end,
			{plr}, "SELECT * FROM logs WHERE content LIKE '%"..edittext.."%'")
		elseif (data.type == 3) then--Item Listesinden Silah Serial ile LOG Bulma
			edittext, gridsource = data.edittext:gsub("'", ""), data.gridsource
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#ffffff Veritabanında aranıyor.", plr, 0, 255, 0, true)
			db:query(
				function(qh, plr)
					local res, rows, err = qh:poll(0)
					if rows > 0 then
						triggerLatentClientEvent(plr, "logapi.updateLogGrid", plr, 3, res)
					else
						triggerLatentClientEvent(plr, "logapi.foundSpamRemove", plr, data.type)
					end
				end,
			{plr}, "SELECT * FROM items WHERE itemValue LIKE '%"..edittext.."%'")
		elseif (data.type == 4) then
			edittext = data.edittext:gsub("'", "")
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#ffffff Veritabanında aranıyor.", plr, 0, 255, 0, true)
			db:query(
				function(qh, plr)
					local res, rows, err = qh:poll(0)
					if rows > 0 then
						
						triggerLatentClientEvent(plr, "logapi.updateLogGrid", plr, 4, res)
					else
						triggerLatentClientEvent(plr, "logapi.foundSpamRemove", plr, data.type)
					end
				end,
			{plr}, "SELECT * FROM worlditems WHERE itemvalue LIKE '%"..edittext.."%'")
		end
	end
)