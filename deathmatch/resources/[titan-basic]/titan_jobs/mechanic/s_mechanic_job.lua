armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true } -- Enforcer, FBI Truck, Rhino, SWAT Tank, Securicar

local btrdiscountratio = 1.2

-- Full Service
function serviceVehicle(veh)
	if (veh) then
		local mechcost = 1500
		if (getElementData(source,"faction")==4) then
			mechcost = mechcost / btrdiscountratio
		end
		if not exports.titan_global:takeMoney(source, mechcost) then
			outputChatBox("Bu araca hizmet edecek parçaları karşılayamazsınız.", source, 255, 0, 0)
		else
			local health = getElementHealth(veh)
			if (health <= 850) then
				health = health + 150
			else
				health = 1000
			end
			
			fixVehicle(veh)
			setElementHealth(veh, health)
			if not getElementData(veh, "Impounded") or getElementData(veh, "Impounded") == 0 then
				exports.titan_anticheat:changeProtectedElementDataEx(veh, "enginebroke", 0, false)
				if armoredCars[ getElementModel( veh ) ] then
					setVehicleDamageProof(veh, true)
				else
					setVehicleDamageProof(veh, false)
				end
			end
			exports.titan_global:sendLocalMeAction(source, "Aracın bazı hasarlı bölgelerini tamir eder.")
			exports.titan_logs:dbLog(source, 31, {  veh }, "REPAIR QUICK-SERVICE")
		end
	else
		outputChatBox("Tamir etmek istediğiniz araçta olmalısınız.", source, 255, 0, 0)
	end
end
addEvent("serviceVehicle", true)
addEventHandler("serviceVehicle", getRootElement(), serviceVehicle)

function changeTyre( veh, wheelNumber )
	if (veh) then
		local mechcost = 800
		if (getElementData(source,"faction")==4) then
			mechcost = mechcost / btrdiscountratio
		end
		if not exports.titan_global:takeMoney(source, mechcost) then
			outputChatBox("Bu aracın lastiklerini değiştirecek parçaları karşılayamazsınız.", source, 255, 0, 0)
		else
			local wheel1, wheel2, wheel3, wheel4 = getVehicleWheelStates( veh )

			if (wheelNumber==1) then -- front left
				--outputDebugString("Tyre 1 changed.")
				setVehicleWheelStates ( veh, 0, wheel2, wheel3, wheel4 )
			elseif (wheelNumber==2) then -- back left
				--outputDebugString("Tyre 2 changed.")
				setVehicleWheelStates ( veh, wheel1, wheel2, 0, wheel4 )
			elseif (wheelNumber==3) then -- front right
				--outputDebugString("Tyre 3 changed.")
				setVehicleWheelStates ( veh, wheel1, 0, wheel2, wheel4 )
			elseif (wheelNumber==4) then -- back right
				--outputDebugString("Tyre 4 changed.")
				setVehicleWheelStates ( veh, wheel1, wheel2, wheel3, 0 )
			end
			
			exports.titan_logs:dbLog(source, 31, {  veh }, "REPAIR TIRESWAP")
			exports.titan_global:sendLocalMeAction(source, "Aracın tekerleklerini tamir eder.")
		end
	end
end
addEvent("tyreChange", true)
addEventHandler("tyreChange", getRootElement(), changeTyre)

function changePaintjob( veh, paintjob )
	if (veh) then
		local mechcost = 8500
		if (getElementData(source,"faction")==4) then
			mechcost = mechcost / btrdiscountratio
		end
		if not exports.titan_global:takeMoney(source, mechcost) then
			outputChatBox("Bu aracı yeniden boyamaya gücün yetmez.", source, 255, 0, 0)
		else
			triggerEvent( "paintjobEndPreview", source, veh )
			if setVehiclePaintjob( veh, paintjob ) then
				local col1, col2 = getVehicleColor( veh )
				if col1 == 0 or col2 == 0 then
					setVehicleColor( veh, 1, 1, 1, 1 )
				end
				exports.titan_logs:logMessage("[/changePaintJob] " .. getPlayerName(source) .." / ".. getPlayerIP(source)  .." OR " .. getPlayerName(client)  .." / ".. getPlayerIP(client)  .." changed vehicle " .. getElementData(veh, "dbid") .. " their colors to " .. col1 .. "-" .. col2, 29)
				exports.titan_global:sendLocalMeAction(source, "Araca kaplama yapmaya başlar.")
				exports.titan_logs:dbLog(source, 6, {  veh }, "MODDING PAINTJOB ".. paintjob)
				exports['titan_vehicle']:saveVehicleMods(veh)
			else
				outputChatBox("Bu arabada zaten bu boya işi var.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("paintjobChange", true)
addEventHandler("paintjobChange", getRootElement(), changePaintjob)

function editVehicleHeadlights( veh, color1, color2, color3 )
	if (veh) then
		local mechcost = 9000
		if (getElementData(source,"faction")==4) then
			mechcost = mechcost / btrdiscountratio
		end
		if not exports.titan_global:takeMoney(source, mechcost) then
			outputChatBox("bu aracı değiştirmeyi göze alamazsın.", source, 255, 0, 0)
		else
			triggerEvent( "headlightEndPreview", source, veh )
			if setVehicleHeadLightColor ( veh, color1, color2, color3) then
				exports.titan_logs:logMessage("[/changeHeadlights] " .. getPlayerName(source) .." / ".. getPlayerIP(source)  .." OR " .. getPlayerName(client)  .." / ".. getPlayerIP(client)  .." changed vehicle " .. getElementData(veh, "dbid") .. " their headlight colors to " .. color1 .. "-" .. color2 .. "-"..color3, 29)
				exports.titan_global:sendLocalMeAction(source, "replaces the vehicles headlights.")
				exports.titan_anticheat:changeProtectedElementDataEx(veh, "headlightcolors", {color1, color2, color3}, true)
				exports['titan_vehicle']:saveVehicleMods(veh)
				exports.titan_logs:dbLog(source, 6, {  veh }, "MODDING HEADLIGHT ".. color1 .. " "..color2.." "..color3)
			else
				outputChatBox("Bu arabada zaten bu farlar var.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("editVehicleHeadlights", true)
addEventHandler("editVehicleHeadlights", getRootElement(), editVehicleHeadlights)

 -- 

function changeVehicleUpgrade( veh, upgrade )
	if (veh) then
		local item = false
		local u = upgrades[upgrade - 999]
		if not u then
			--outputDebugString( getPlayerName( source ) .. " tried to add invalid upgrade #" .. upgrade )
			return
		end
		name = u[1]
		local mechcost = u[2]
		if (getElementData(source,"faction")==4) then
			mechcost = mechcost / btrdiscountratio
		end
		if exports.titan_global:hasItem( source, 114, upgrade ) then
			mechcost = 0
			item = true
		end
		
		if not item and not exports.titan_global:hasMoney( source, mechcost ) then
			outputChatBox("Bu araca " .. name .. " Ekleyemezsin!.", source, 255, 0, 0)
		else
			for i = 0, 16 do
				if upgrade == getVehicleUpgradeOnSlot( veh, i ) then
					outputChatBox("Bu arabada zaten bu yükseltme var.", source, 255, 0, 0)
					return
				end
			end
			if addVehicleUpgrade( veh, upgrade ) then
				if item then
					exports.titan_global:takeItem(source, 114, upgrade)
				else
					exports.titan_global:takeMoney(source, mechcost)
				end
				exports.titan_logs:logMessage("[changeVehicleUpgrade] " .. getPlayerName(source) .."/ " .. getPlayerIP(source)  .. " OR " .. getPlayerName(client)  .."/ " .. getPlayerIP(client)  .. "  changed vehicle " .. getElementData(veh, "dbid") .. ": added " .. name .. " to the vehicle.", 29)
				exports.titan_global:sendLocalMeAction(source, "Araca " .. name .. " yükseltmesini monte eder.")
				exports['titan_vehicle']:saveVehicleMods(veh)
				exports.titan_logs:dbLog(source, 6, {  veh }, "MODDING ADDUPGRADE "..name)
			else
				outputChatBox("Araç yükseltmesi uygulanamadı.", source, 255, 0, 0)
			end
		end
	end
end
addEvent("changeVehicleUpgrade", true)
addEventHandler("changeVehicleUpgrade", getRootElement(), changeVehicleUpgrade)

function changeVehicleColour(veh, col1, col2, col3, col4)
	if (veh) then
		local mechcost = 1500
		if (getElementData(source,"faction")==4) then
			mechcost = mechcost / btrdiscountratio
		end
		if not exports.titan_global:takeMoney(source, mechcost) then
			outputChatBox("Bu aracı yeniden boyamaya gücün yetmez.", source, 255, 0, 0)
		else
			col = { getVehicleColor( veh, true ) }
			
			local color1 = col1 or { col[1], col[2], col[3] }
			local color2 = col2 or { col[4], col[5], col[6] }
			local color3 = col3 or { col[7], col[8], col[9] }
			local color4 = col4 or { col[10], col[11], col[12] }
			
			--outputChatBox("1. "..toJSON(color1), source)
			--outputChatBox("2. "..toJSON(color2), source)
			--outputChatBox("3. "..toJSON(color3), source)
			--outputChatBox("4. "..toJSON(color4), source)
			
			if setVehicleColor( veh, color1[1], color1[2], color1[3], color2[1], color2[2], color2[3],  color3[1], color3[2], color3[3], color4[1], color4[2], color4[3]) then
				--exports.titan_logs:logMessage("[repaintVehicle] " .. getPlayerName(source) .." ".. getPlayerIP(source) .." OR ".. getPlayerName(client) .."/"..getPlayerIP(client)  .." changed vehicle " .. getElementData(veh, "dbid") .. " colors to ".. col1 .. "-" .. col2, 29)
				exports.titan_global:sendLocalMeAction(source, "Aracı boyar.")
				exports['titan_vehicle']:saveVehicleMods(veh)
				exports.titan_logs:dbLog(source, 6, {  veh }, "MODDING REPAINT "..toJSON(col))
			end
		end
	end
end
addEvent("repaintVehicle", true)
addEventHandler("repaintVehicle", getRootElement(), changeVehicleColour)

--Installing and Removing vehicle tinted windows
function changeVehicleTint(veh, stat)
	if veh and stat then
		if stat == 1 then
			--local leader = tonumber(getElementData(source, "factionleader"))
			--if leader == 1 then
				local mechcost = 5500
				if (getElementData(source,"faction")==4) then
					mechcost = mechcost / 2
				end
				if not exports.titan_global:takeMoney(source, mechcost) then
					outputChatBox("Bu araca Cam Film'i ekleyemezsiniz.", source, 255, 0, 0)
				else
					local vehID = getElementData(veh, "dbid")
					exports.titan_global:sendLocalMeAction(source, "pencerelere Cam Film'i yerleştirmeye başlar.")
					
					local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET tintedwindows = '1' WHERE id='" .. (vehID) .. "'")
					if query then
						for i = 0, getVehicleMaxPassengers(veh) do
							local player = getVehicleOccupant(veh, i)
							if (player) then
								triggerEvent("setTintName", veh, player)
							end
						end
						triggerClientEvent("tintWindows", veh)
						exports.titan_anticheat:changeProtectedElementDataEx(veh, "tinted", true, true)
						outputChatBox("Araç camlarına Cam Film'i eklediniz.", source)
						exports.titan_global:sendLocalMeAction(source, "pencereler Cam Film'i Ekler.")
						exports.titan_logs:dbLog(source, 6, {  veh }, "MODDING ADDTINT")
						exports.titan_logs:logMessage("[ADD TINT-LST&R] " .. getPlayerName(source):gsub("_"," ") .. " has added tint to vehicle #" .. vehID .. " - " .. exports.titan_global:getVehicleName(veh) .. ".", 9)
					else
						outputChatBox("There was an issues adding the tint. Please report on mantis", source, 255, 0, 0)				
					end
				end
			--else
				--outputChatBox("Faction Leaders Only!", source, 255, 0, 0)
			--end
		elseif stat == 2 then
			local mechcost = 2000
			if (getElementData(source,"faction")==4) then
				mechcost = mechcost / 2
			end
			if not exports.titan_global:takeMoney(source, mechcost) then
				outputChatBox("Bu araca Cam Film'i ekleyemezsiniz.", source, 255, 0, 0)
			else
				local vehID = getElementData(veh, "dbid")
				exports.titan_global:sendLocalMeAction(source, "pencereden Cam Film'i kaldırmaya başlar.")
			
				local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET tintedwindows = '0' WHERE id='" .. (vehID) .. "'")
				if query then
					for i = 0, getVehicleMaxPassengers(veh) do
						local player = getVehicleOccupant(veh, i)
						if (player) then
							triggerEvent("resetTintName", veh, player)
						end
					end
					triggerClientEvent("tintWindows", veh)
					exports.titan_anticheat:changeProtectedElementDataEx(veh, "tinted", false, true)
					outputChatBox("Cam Film'i araç camlarından temizlediniz.", source)
					exports.titan_global:sendLocalMeAction(source, "pencerelerden Cam Film'i kaldırır.")
					exports.titan_logs:dbLog(source, 6, {  veh }, "MODDING REMOVETINT")
					exports.titan_logs:logMessage("[REMOVED TINT-BTR] " .. getPlayerName(source):gsub("_"," ") .. " has removed tint from vehicle #" .. vehID .. " - " .. exports.titan_global:getVehicleName(veh) .. ".", 9)
				else
					outputChatBox("There was an issues removing the tint. Please report on mantis", source, 255, 0, 0)
				end
			end
		end
	end
end
addEvent("tintedWindows", true)
addEventHandler("tintedWindows", getRootElement(), changeVehicleTint)