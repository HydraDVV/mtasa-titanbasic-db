mysql = exports.titan_mysql

function givePlayerJob(jobID)
	local charname = getPlayerName(source)
	local charID = getElementData(source, "dbid")

	dbExec(mysql:getConnection(), "UPDATE characters SET job='"..tostring(jobID).."' WHERE id='"..(charID).."' ")
	fetchJobInfoForOnePlayer(source)
end
addEvent("acceptJob", true)
addEventHandler("acceptJob", getRootElement(), givePlayerJob)

function fetchJobInfo()
	if not charID then
		for key, player in pairs(getElementsByType("player")) do
			fetchJobInfoForOnePlayer(player)
		end
	end
end
addEvent("titan_jobs:fetchJobInfo", true)
addEventHandler("titan_jobs:fetchJobInfo", getRootElement(), fetchJobInfo)



-- @amk disocsu çevirmemiş dbye silmiş tam piç.
function fetchJobInfoForOnePlayer(thePlayer)
    local charID = thePlayer:getData('dbid')
        dbQuery(function(qh)
            local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    row = res[1]
                    local job = tonumber(row['job'])
                    local jobID = tonumber(row['jobID'])
                    if job and job == 0 then
                        thePlayer:setData('job', 0, true)
                        thePlayer:setData('jobLevel', 0, true)
                        thePlayer:setData('jobProgress', 0, true)
                        thePlayer:setData('titan_jobs:truckruns', 0, true)
                            return true
                    end
                if not jobID then
                    dbExec(mysql:getConnection(), "INSERT INTO jobs SET jobID='"..tostring(job).."', jobCharID='"..(charID).."'")
                end
                    thePlayer:setData('job', job, true)
                    thePlayer:setData('jobLevel', tonumber(row["jobLevel"]) or 1, true)
                    thePlayer:setData('jobProgress', tonumber(row["jobProgress"]) or 0, true)
                    thePlayer:setData('titan_jobs:truckruns', tonumber(row["jobTruckingRuns"]) or 0, true)
                end
        end,mysql:getConnection(), "SELECT job , jobID, jobLevel, jobProgress, jobTruckingRuns FROM characters LEFT JOIN jobs ON id = jobCharID AND job = jobID WHERE id='" .. tostring(charID) .. "' ")
end
addEvent("titan_jobs:fetchJobInfoForOnePlayer", true)
addEventHandler("titan_jobs:fetchJobInfoForOnePlayer", getRootElement(), fetchJobInfo)


function quitJob(source)
	local logged = getElementData(source, "loggedin")
	if logged == 1 then
		local job = getElementData(source, "job")
		if job == 0 then
			exports["titan_infobox"]:addBox(source, "error", "Her hangi bir işte değilsiniz.")
		else
			local charID = getElementData(source, "dbid")
			dbExec(mysql:getConnection(), "UPDATE `characters` SET `job`='0' WHERE `id`='"..(charID).."' ")
			fetchJobInfoForOnePlayer(source)
			triggerClientEvent(source, "quitJob", source, job)
			exports["titan_infobox"]:addBox(source, "success", "Başarıyla "..(getJobTitleFromID(getElementData(source, "job")) or "Bilinmeyen").." isimli meslekten ayrıldınız.")
		end
	end
end
addCommandHandler("endjob", quitJob, false, false)
addCommandHandler("quitjob", quitJob, false, false)

-- @Hanz
function startEnterVehJob(thePlayer, seat, jacked) 
	local vjob = tonumber(getElementData(source, "job")) or 0
	local job = getElementData(thePlayer, "job")
	local seat = getPedOccupiedVehicleSeat(thePlayer)
	if vjob>0 and job~=vjob and seat == 0 and not (getElementData(thePlayer, "duty_admin") == 1) and not (getElementData(thePlayer, "duty_supporter") == 1) then
		if (vjob==1) then
			exports["titan_infobox"]:addBox(thePlayer, "error", "Bu mesleği yapabilmeniz için Taksi Şoförü olmanız gerekmektedir.")
            cancelEvent()
            return
		elseif (vjob==2) then
			exports["titan_infobox"]:addBox(thePlayer, "error", "Bu mesleği yapabilmeniz için Otobüs Şoförü olmanız gerekmektedir.")
            cancelEvent()
            return
		elseif (vjob==3) then
			exports["titan_infobox"]:addBox(thePlayer, "error", "Bu mesleği yapabilmeniz için Çöp Şoförü olmanız gerekmektedir.")
            cancelEvent()
            return
        elseif (vjob==6) then
			exports["titan_infobox"]:addBox(thePlayer, "error", "Bu mesleği yapabilmeniz için Tütün Nakliyecisi olmanız gerekmektedir.")
            cancelEvent()
            return
		end
		
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), startEnterVehJob)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
