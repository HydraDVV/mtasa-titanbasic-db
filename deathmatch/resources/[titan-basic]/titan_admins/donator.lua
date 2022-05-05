mysql = exports.titan_mysql
function setetiket(thePlayer, commandName, targetPlayerName, etiketLevel)
local targetName = exports.titan_global:getPlayerFullIdentity(thePlayer, 1)
	if getElementData(thePlayer, "account:username") == "Hanz" then
		if not targetPlayerName or not tonumber(etiketLevel)  then
			outputChatBox("Kullanım: #ffffff/" .. commandName .. " [İsim/ID] [VİP]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
				
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Player is not logged in.", thePlayer, 255, 0, 0 )
			else
				dbExec(mysql:getConnection(),"UPDATE `characters` SET `donatortag`="..etiketLevel.." WHERE `id`='"..getElementData(targetPlayer, "dbid").."'")
				setElementData(targetPlayer, "donatortag", tonumber(etiketLevel))
			end
		end
	end
end
addCommandHandler("donatorver", setetiket)