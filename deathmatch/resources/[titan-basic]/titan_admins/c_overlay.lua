local sx, sy = guiGetScreenSize()
local localPlayer = getLocalPlayer()

local openReports = 0
local handledReports = 0
local ckAmount = 0
local unansweredReports = {}
local ownReports = {}

-- dx stuff
local textString = "- Mevcut Rapor Yok."
local admstr = ""
local show = false

-- Admin Titles
function getAdminTitle(thePlayer)
	return exports.titan_global:getPlayerAdminTitle(thePlayer)
end

-- update the labels
local function updateGUI()
	if show then
		local reporttext = unansweredReports
		if type(reporttext) == "table" and #unansweredReports > 0 then
			reporttext = ": #" .. table.concat(unansweredReports, " #")
		end
		
		local ownreporttext = ownReports
		if #ownReports > 0 then
			ownreporttext = ": #" .. table.concat(ownReports, " #")
		end
		
		local onduty = getElementData( localPlayer, "admin_level" ) <= 7 and "Görev Dışında" or ""
		if getElementData( localPlayer, "duty_admin" ) == 1 or getElementData( localPlayer, "duty_supporter" ) == 1 then
			onduty = "Görevde" .. " - "
		else
			onduty = ""
		end
		if exports.titan_integration:isPlayerSupporter(localPlayer) or exports.titan_integration:isPlayerTrialAdmin(localPlayer) then
			textString = getAdminTitle( localPlayer ) .. " - Mevcut Raporlar: "..(unansweredReports.."")
		else
			textString = getAdminTitle( localPlayer ) .. " - " .. ( openReports - handledReports ) .. " cevaplanmamış raporlar" .. reporttext .. " - " .. handledReports .. " alınmış raporlar" .. ownreporttext .. " - "
		end
	end
end

-- create the gui
local function createGUI()
	show = false

	if exports.titan_integration:isPlayerStaff(localPlayer) then
		show = true
		updateGUI()
	end
end

addEventHandler( "onClientResourceStart", getResourceRootElement(), createGUI, false )
addEventHandler( "onClientElementDataChange", localPlayer, 
	function(n)
		if n == "admin_level" or n == "hiddenadmin" or n=="account:gmlevel" or n=="duty_supporter" or n=="duty_admin" or n == "forum_perms" then
			createGUI()
		end
	end, false
)

addEvent( "updateReportsCount", true )
addEventHandler( "updateReportsCount", localPlayer,
	function( open, handled, unanswered, own, admst )
		openReports = open
		handledReports = handled
		unansweredReports = unanswered
		admstr = admst
		ownReports = own or {}
		updateGUI()
	end, false
)


addEvent( "addOneToCKCount", true )
addEventHandler("addOneToCKCount", localPlayer,
	function( )
		ckAmount = ckAmount + 1
		updateGUI()
	end, false
)

addEvent( "addOneToCKCountFromSpawn", true )
addEventHandler("addOneToCKCountFromSpawn", localPlayer,
	function( )
		if (ckAmount>=1) then
			return
		else
		ckAmount = ckAmount + 1
		updateGUI()
		end
	end, false
)

addEvent( "subtractOneFromCKCount", true )
addEventHandler("subtractOneFromCKCount", localPlayer,
	function( )
	if (ckAmount~=0) then
		ckAmount = ckAmount - 1
		updateGUI()
	else
		ckAmount = 0
	end
	end, false
)

addCommandHandler("staffoverlay", function()
 if exports.titan_integration:isPlayerSupporter(localPlayer) or exports.titan_integration:isPlayerTrialAdmin(localPlayer) then
	if (show == true) then
		show = false
		exports["titan_infobox"]:addBox("info", "Yetkili arayüzünü in-aktif hale getirdin. Raporları farklı bir şekilde okumak istiyorsan /rapordurum ac yazabilirsin.")
	else
		show = true
		exports["titan_infobox"]:addBox("info", "Yetkili arayüzünü aktif hale getirdin.")
	end
 end
end)

addEventHandler( "onClientPlayerQuit", getRootElement(), updateGUI )
function drawText ( )
	if show and exports.titan_global:isStaffOnDuty(localPlayer) then
	if getElementData(localPlayer, "loggedin") ~= 1 then return end
    local h = 64
    local font = exports['titan_fonts']:getFont("FontAwesome", 9)
    local between = 5
	dxDrawText("  "..textString, sx/2, sy+37, sx/2, sy - h, tocolor(255, 255, 255, 255), 1, font, "center", "center")	
	end
end
setTimer(drawText, 0, 0)

