addEvent("lses:ped:start", true)
function lsesPedStart(pedName)
	exports['titan_global']:sendLocalText(client, "Rosie Jenkins says: Size nasıl yardımcı olabilirim?", 255, 255, 255, 10)
end
addEventHandler("lses:ped:start", getRootElement(), lsesPedStart)

addEvent("lses:ped:help", true)
function lsesPedHelp(pedName)
	exports['titan_global']:sendLocalText(client, pedName.." says: Siz koltukta oturun , birazdan doktor gelecek.", 255, 255, 255, 10)
	exports['titan_global']:sendLocalText(client, pedName.." [RADIO]: Hastane resepsiyonunda bekleyen hastalar var.", 255, 255, 255, 10)
	for key, value in ipairs( getPlayersInTeam( getTeamFromName("Los Santos Medical Department") ) ) do
		outputChatBox("[RADIO] Acil , boşta olan ekiplerin intikal etmesi gerekiyor.", value, 0, 183, 239)
		outputChatBox("[RADIO] Durum: Birisinin yardıma ihtiyacı var.! ((" .. getPlayerName(client):gsub("_"," ") .. "))", value, 0, 183, 239)
		outputChatBox("[RADIO] Yer: Los Santos Devlet Hastanesi", value, 0, 183, 239)
	end
end
addEventHandler("lses:ped:help", getRootElement(), lsesPedHelp)

addEvent("lses:ped:appointment", true)
function lsesPedAppointment(pedName)
	exports['titan_global']:sendLocalText(client, "Rosie Jenkins says: Koltukta biraz oturun , birazdan doktor gelecek.", 255, 255, 255, 10)
	for key, value in ipairs( getPlayersInTeam( getTeamFromName("Los Santos Medical Department") ) ) do
	    outputChatBox("[RADYO] Randevu için gelmiş bir hastamız var.", value, 0,183,239)
		outputChatBox("[RADYO] Randevu almış kişinin adı -> ((" .. getPlayerName(client):gsub("_"," ") .. ")) 'imiş.", value, 0, 183, 239)
		outputChatBox("[RADYO] Yer: Los Santos Devlet Hastanesi,", value, 0, 183, 239)
	end
end
addEventHandler("lses:ped:appointment", getRootElement(), lsesPedAppointment)