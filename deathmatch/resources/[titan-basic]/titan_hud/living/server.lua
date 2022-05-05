local mysql = exports['titan_mysql']

function setHunger(thePlayer, commandName, targetPlayerName, hunger)
	if exports.titan_integration:isPlayerAdmin(thePlayer) then
		if not targetPlayerName or not hunger then
			outputChatBox("SÖZDİZİMİ: /" .. commandName .. " [Oyuncu Adı / ID] [Açlık]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Oyuncu henüz giriş yapmadı.", thePlayer, 255, 0, 0 )
			else
				setElementData(targetPlayer, "hunger", tonumber(hunger))
				dbExec(mysql:getConnection(), "UPDATE characters SET hunger='"..tonumber(hunger).."' WHERE id='"..getElementData(targetPlayer, "dbid").."'")
				exports["titan_infobox"]:addBox(thePlayer, "success", targetPlayerName .. " isimli oyuncunun açlığı %" .. hunger .. " olarak değiştirilmiştir.")
				exports["titan_infobox"]:addBox(targetPlayer, "info", "Açlığınız bir yetkili tarafından %" .. hunger .. " olarak değiştirilmiştir.")
			end
		end
	end
end
addCommandHandler("sethunger", setHunger)

-- /setthirst for Admin+
function setThirst(thePlayer, commandName, targetPlayerName, thirst)
	if exports.titan_integration:isPlayerAdmin(thePlayer) then
		if not targetPlayerName or not thirst then
			outputChatBox("SÖZDİZİMİ: /" .. commandName .. " [Oyuncu Adı / ID] [Susuzluk]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Oyuncu henüz giriş yapmadı.", thePlayer, 255, 0, 0 )
			else
				setElementData(targetPlayer, "thirst", tonumber(thirst))
				dbExec(mysql:getConnection(), "UPDATE characters SET thirst='"..tonumber(thirst).."' WHERE id='"..getElementData(targetPlayer, "dbid").."'")
				exports["titan_infobox"]:addBox(thePlayer, "success", targetPlayerName .. " isimli oyuncunun susuzluğu %" .. thirst .. " olarak değiştirilmiştir.")
				exports["titan_infobox"]:addBox(targetPlayer, "info", "Susuzluğunuz bir yetkili tarafından %" .. thirst .. " olarak değiştirilmiştir.")
			end
		end
	end
end
addCommandHandler("setthirst", setThirst)

function autoEmote()
	exports.titan_global:sendLocalDoAction(source, "Bir mide guruldaması duyabilirsiniz.")
end
addEvent("hunger:autoEmote", true)
addEventHandler("hunger:autoEmote", getRootElement(), autoEmote)

function getPlayerHunger(player)
	return getElementData(player, "hunger")
end

function getPlayerThirst(player)
	return getElementData(player, "thirst")
end