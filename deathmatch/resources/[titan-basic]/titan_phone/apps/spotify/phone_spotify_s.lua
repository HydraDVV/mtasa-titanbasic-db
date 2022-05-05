local SpotifyCache = {}
local SpotifyWaiters = {}
local color = {--jesse chatbox colors
	["r"] = "#d75959", --( red )
	["g"] = "#7cc576", --( green )
	["b"] = "#32b3ef", --( blue )
}

addEventHandler("onResourceStart", resourceRoot,
	function()
		updateRootElements(SpotifyCache, SpotifyWaiters);
	end
)

addEvent("spotify-system:requestNewSpotifyVehicle", true)
addEventHandler("spotify-system:requestNewSpotifyVehicle", root,
	function(player, x, y, z)
		if SpotifyWaiters[player] then
			--already've
			return
		end
		SpotifyWaiters[player] = {getPlayerName(player), x, y, z}
		updateRootElements(SpotifyCache, SpotifyWaiters);

		outputChatBox(color["g"].."#575757"..exports["titan_pool"]:getServerName()..": #ffffffSisteme kaydın başarıyla düştü, sana bir araç bağlandığında bildireceğiz!", player, 0, 255, 0, true)
		outputChatBox(color["b"].."#575757"..exports["titan_pool"]:getServerName()..": #ffffffSisteme kaydını iptal etmek için /spotifyiptal komutunu kullanın.", player, 0, 255, 0, true)
		--notify all spotify's
		for index, value in pairs(SpotifyCache) do
			outputChatBox(color["b"].."#575757"..exports["titan_pool"]:getServerName()..": #ffffffYeni bir spotify talebi var, detaylar için /spotifypanel",index, 255, 0, 0, true)
		end
	end
)

addCommandHandler("spotifypanel",
	function(player, cmd)
		if getElementData(player, "loggedin") == 1 then
			if SpotifyCache[player] or exports["titan_integration"]:isPlayerHeadAdmin(player) then
				triggerClientEvent(player, "spotify-system:showSpotifyPanel", player, SpotifyCache, SpotifyWaiters)
			else
				outputChatBox(color["r"].."#575757"..exports["titan_pool"]:getServerName()..": #ffffffSpotify şoförü olmadığın için bu arayüze erişemezsin!", player, 255, 0, 0, true)
			end
		end
	end
)

addCommandHandler("spotifyiptal",
	function(player, cmd)
		if getElementData(player, "loggedin") == 1 then
			if SpotifyWaiters[player] then
				SpotifyWaiters[player] = nil
				outputChatBox(color["r"].."#575757"..exports["titan_pool"]:getServerName()..": #ffffffSistem kaydın başarıyla silindi.", player, 0, 255, 0, true)
				updateRootElements(SpotifyCache, SpotifyWaiters);
				for index, value in pairs(SpotifyCache) do--update spotify personels for table
					triggerClientEvent(index, "spotify-system:updateTable", index, SpotifyCache, SpotifyWaiters)
				end
			else
				outputChatBox(color["r"].."#575757"..exports["titan_pool"]:getServerName()..": #ffffffHerhangi bir spotify kaydın bulunamadı.", player, 255, 0, 0, true)
			end
		end
 	end
)

addEventHandler("onPlayerQuit", root,
	function()
		if SpotifyWaiters[source] then
			SpotifyWaiters[source] = nil
			updateRootElements(SpotifyCache, SpotifyWaiters);
			for index, value in pairs(SpotifyCache) do--update spotify personels for table
				triggerClientEvent(index, "spotify-system:updateTable", index, SpotifyCache, SpotifyWaiters)
			end
		end
	end
)

addEventHandler("accounts:characters:change", root,
	function()
		if SpotifyWaiters[client] then
			SpotifyWaiters[client] = nil
			updateRootElements(SpotifyCache, SpotifyWaiters);
			for index, value in pairs(SpotifyCache) do--update spotify personels for table
				triggerClientEvent(index, "spotify-system:updateTable", index, SpotifyCache, SpotifyWaiters)
			end
		end
	end
)

addEventHandler("onPlayerQuit", root,
	function()
		if SpotifyCache[source] then
			SpotifyCache[source] = nil
			updateRootElements(SpotifyCache, SpotifyWaiters);
			for index, value in pairs(SpotifyCache) do--update spotify personels for table
				triggerClientEvent(index, "spotify-system:updateTable", index, SpotifyCache, SpotifyWaiters)
			end
		end
	end
)

addEventHandler("accounts:characters:change", root,
	function()
		if SpotifyCache[client] then
			SpotifyCache[client] = nil
			updateRootElements(SpotifyCache, SpotifyWaiters);
			for index, value in pairs(SpotifyCache) do--update spotify personels for table
				triggerClientEvent(index, "spotify-system:updateTable", index, SpotifyCache, SpotifyWaiters)
			end
		end
	end
)

addEvent("spotify-system:receiveWaiterPersonel", true)
addEventHandler("spotify-system:receiveWaiterPersonel", root,
	function(personal, waiter, x, y, z)
		if SpotifyWaiters[waiter] then
			outputChatBox(color["g"].."#575757"..exports["titan_pool"]:getServerName()..": #ffffff"..getPlayerName(personal):gsub("_", " ").. " adlı Spotify şoförü isteğine yanıt verdi, bulunduğun konuma geliyor!", waiter, 0, 255, 0, true)
			outputChatBox(color["g"].."#575757"..exports["titan_pool"]:getServerName()..": #ffffff"..getPlayerName(waiter):gsub("_", " ").. " adlı kişinin Spotify navigasyonunu aldın, navigasyon oluşturuluyor..", personal, 0, 255, 0, true)
			SpotifyWaiters[waiter] = nil
			updateRootElements(SpotifyCache, SpotifyWaiters)
			for index, value in pairs(SpotifyCache) do--update spotify personels for table
				triggerClientEvent(index, "spotify-system:updateTable", index, SpotifyCache, SpotifyWaiters)
			end

			triggerClientEvent(personal, "spotify-system:createNavigation", personal, x, y, z)
		end
	end
)

addEvent("spotify-system:addNewPerson", true)
addEventHandler("spotify-system:addNewPerson", root,
	function(personal)
		SpotifyCache[personal] = true
		for index, value in pairs(SpotifyCache) do--update spotify personels for table
			triggerClientEvent(index, "spotify-system:updateTable", index, SpotifyCache, SpotifyWaiters)
		end
		updateRootElements(SpotifyCache, SpotifyWaiters)
	end
)

addEvent("spotify-system:removePerson", true)
addEventHandler("spotify-system:removePerson", root,
	function(personal)
		SpotifyCache[personal] = nil
		for index, value in pairs(SpotifyCache) do--update spotify personels for table
			triggerClientEvent(index, "spotify-system:updateTable", index, SpotifyCache, SpotifyWaiters)
		end
		updateRootElements(SpotifyCache, SpotifyWaiters)
	end
)


function updateRootElements(table1, table2)
	setElementData(root, "spotifyPersonels", table1)
	setElementData(root, "spotifyWaiters", table2)
end
