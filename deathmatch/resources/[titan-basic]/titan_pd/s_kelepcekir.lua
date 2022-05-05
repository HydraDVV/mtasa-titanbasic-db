mysql = exports.titan_mysql
local kirmayeri = createColSphere ( 1420.1767578125, -1354.6044921875, 13.564352989197, 5)

function kelepceKirma(thePlayer, commandName )

        if not isElementWithinColShape(thePlayer, kirmayeri) then
			exports["titan_infobox"]:addBox(thePlayer, "error", "Bu alanda kelepçe kıramazsınız.")
	    else
					
			local restrain = getElementData(thePlayer, "restrain")

			if (restrain==0) then
				exports["titan_infobox"]:addBox(thePlayer, "warning", "Kırılacak bir kelepçeye sahip değilsin.")
			else
				if not exports.titan_global:takeMoney(thePlayer, 250) then
					exports["titan_infobox"]:addBox(thePlayer, "error", "Yeterli paran olmadığı için kelepçeni kıramıyorsun.")
				return end
			exports.titan_global:sendLocalMeAction(thePlayer, "sağ ve sol elindeki kelepçeyi çöp tenekesinin ucuna vurarak kırmayaya çalışır.", false, true)
			exports.titan_global:sendLocalDoAction(thePlayer, "Elimdeki kelepçe kırılmıştır.", false, true)
			exports["titan_infobox"]:addBox(thePlayer, "success", "250 TL karşılığında kelepçen kırıldı.")
			exports.titan_global:takeMoney(thePlayer,250)
			toggleControl(thePlayer, "sprint", true)
			toggleControl(thePlayer, "fire", true)
			toggleControl(thePlayer, "jump", true)
			toggleControl(thePlayer, "next_weapon", true)
			toggleControl(thePlayer, "previous_weapon", true)
			toggleControl(thePlayer, "accelerate", true)
			toggleControl(thePlayer, "brake_reverse", true)
			toggleControl(thePlayer, "aim_weapon", true)
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "restrain", 0, true)
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "restrainedBy", false, true)
			exports.titan_anticheat:changeProtectedElementDataEx(thePlayer, "restrainedObj", false, true)
			exports.titan_global:removeAnimation(thePlayer)
			local dbid = getElementData(thePlayer,"dbid")
			dbExec(mysql:getConnection(), "UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " ..dbid  )
			exports['titan_items']:deleteAll(47, dbid)
			exports.titan_logs:dbLog(thePlayer, 4, thePlayer, "UNCUFF")
		end
	end
end
addCommandHandler("kelepcekir", kelepceKirma, false, false)


