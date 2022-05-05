-- Hanz 26 haziran 02:05
function getJobTitleFromID(jobID)
	return exports["titan_jobs"]:getJobTitleFromID(jobID)
end

function givePlayerJob(thePlayer, commandName, targetPlayer, jobID, jobLevel, jobProgress)
	jobID = tonumber(jobID)
	if exports.titan_integration:isPlayerTrialAdmin(thePlayer) or exports.titan_integration:isPlayerSupporter(thePlayer) then
		local jobTitle = getJobTitleFromID(jobID)
		if not (targetPlayer) then
			printSetJobSyntax(thePlayer, commandName)
			return
		else
			
			if jobTitle == "Bilinmeyen" then
				jobID = 0
			end
			
			local targetPlayer, targetPlayerName = exports.titan_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				
				if (logged==0) then
					exports["titan_infobox"]:addBox(thePlayer, "error", "Bu oyuncu henüz giriş yapmamış.")
				else
				
				
					dbExec(mysql:getConnection(), "UPDATE `characters` SET `job`='" .. (jobID) .. "' WHERE `id`='"..tostring(getElementData(targetPlayer, "dbid")).."' " )
					setElementData(targetPlayer, "job", jobID)
					local adminTitle = exports.titan_global:getPlayerAdminTitle(thePlayer)
					exports["titan_infobox"]:addBox(targetPlayer, "info", tostring(adminTitle) .. " " .. getPlayerName(thePlayer).." isimli yetkili senin mesleğini "..jobTitle.." olarak ayarladı.")
					exports["titan_infobox"]:addBox(thePlayer, "success", "Başarıyla "..targetPlayerName.." isimli oyuncunun mesleğini "..jobTitle.." olarak ayarladın.")
				end
			end
		end
	end
end
addCommandHandler("setjob", givePlayerJob, false, false)

function printSetJobSyntax(thePlayer, commandName)
	outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Nick / ID] [Job ID, 0 = Unemployed]", thePlayer, 255, 194, 14)
	outputChatBox("ID#1: Taxi Driver", thePlayer)
	outputChatBox("ID#2: Bus Driver", thePlayer)
	outputChatBox("ID#3: Kamyon Driver", thePlayer)
	outputChatBox("ID#4: Yok", thePlayer)
	outputChatBox("ID#5: Mekanik", thePlayer)
end


truckerJobVehicleInfo = {
	[440] = {40, 1, 20, 700}, -- Rumpo
	[499] = {80, 2, 40, 1120}, -- Benson
	[414] = {100, 3, 50, 1400}, -- Mule
	[498] = {150, 4, 75, 2100}, -- Boxville
	[456] = {200, 5, 100, 2800}, -- Yankee
}



function getTruckCapacity(element)
	if truckerJobVehicleInfo[getElementModel(element)] then
		return truckerJobVehicleInfo[getElementModel(element)][1] -- Weight
	else
		return false
	end
end