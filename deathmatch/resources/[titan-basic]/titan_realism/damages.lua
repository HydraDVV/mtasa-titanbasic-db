--[[
local hasarlartablo = {}
local hasarsayi = 0
local hasarsayi2 = 0
local bekleyen = nil
local bekleyen2 = nil
local gosterPanel = nil


local screenW, screenH = guiGetScreenSize()
        panel = guiCreateWindow(0, 0, 596, 374, getPlayerName(localPlayer).."'nin Hasarları - "..exports["titan_pool"]:getServerName().." Roleplay", false)
		exports.titan_global:centerWindow(panel)
        guiWindowSetSizable(panel, false)
        guiSetVisible(panel, false)
	   tabPanel = guiCreateTabPanel ( 0, 0.07, 1, 0.78, true, panel ) 
	   local tabMap = guiCreateTab( "Verilen Hasarlar", tabPanel ) 
	   local tabMap2 = guiCreateTab( "Alınan Hasarlar", tabPanel ) 
        liste = guiCreateGridList(5, 10, 559, 250, false, tabMap)
        guiGridListAddColumn(liste, "ID", 0.1)
        guiGridListAddColumn(liste, "Hasar", 0.1)
        guiGridListAddColumn(liste, "İsim", 0.25)
        guiGridListAddColumn(liste, "Bölge", 0.2)
        guiGridListAddColumn(liste, "Tarih", 0.25)
		
		liste2 = guiCreateGridList(5, 10, 559, 250, false, tabMap2)
        guiGridListAddColumn(liste2, "ID", 0.1)
        guiGridListAddColumn(liste2, "Hasar", 0.1)
        guiGridListAddColumn(liste2, "İsim", 0.25)
        guiGridListAddColumn(liste2, "Bölge", 0.2)
        guiGridListAddColumn(liste2, "Tarih", 0.25)
         kapat = guiCreateButton(12, 325, 570, 40, "Kapat", false, panel)
		 
function islev()
 if ( guiGetVisible ( panel ) == true ) then               
                guiSetVisible ( panel, false )
				showCursor(false)
				removeEventHandler("onClientGUIClick", kapat, kapatislev, false)
        else              
                guiSetVisible ( panel, true )
				showCursor(true)
				addEventHandler("onClientGUIClick", kapat, kapatislev, false)
        end
end
addCommandHandler("hasarlar", islev)

function kapatislev()
 if ( guiGetVisible ( panel ) == true ) then               
                guiSetVisible ( panel, false )
				showCursor(false)
				removeEventHandler("onClientGUIClick", kapat, kapatislev, false)
        else              
                guiSetVisible ( panel, true )
				showCursor(true)
				addEventHandler("onClientGUIClick", kapat, kapatislev, false)
        end
end
function hasarAlindi(saldirgan, silah, yer, kayip)
	local currentWeaponID = getPedWeapon(saldirgan)
	if getWeaponNameFromID(currentWeaponID) == "Fist" then return end
	
		local ad = getPlayerName(saldirgan)
		local ad2 = getPlayerName(getLocalPlayer())
		 if yer == 3 then
		 yer = "Gövde"
		 elseif yer == 4 then
		 yer = "Sırt"
		 elseif yer == 5 then
		 yer = "Sol Kol"
		 elseif yer == 6 then
		 yer = "Sağ Kol"
		 elseif yer == 7 then
		 yer = "Sol Bacak"
		 elseif yer == 8 then
		 yer = "Sağ Bacak"
		 elseif yer == 9 then
		  yer = "Kafa"
		 end
		 local time = getRealTime()
			local hours = time.hour
			local minutes = time.minute
			local seconds = time.second

				local monthday = time.monthday
			local month = time.month
			local year = time.year
			 tarih = string.format("%04d-%02d-%02d %02d:%02d:%02d", year+1900, month + 1, monthday, hours, minutes, seconds)
	
	
	if isElement(getLocalPlayer()) and getElementType(getLocalPlayer()) == "player" then

			 guiGridListAddRow(liste2)
		 guiGridListSetItemText(liste2, hasarsayi2, 1, ""..hasarsayi.."", false, false)
		 guiGridListSetItemText(liste2, hasarsayi2, 2, ""..math.floor(kayip).."", false, false)
		 guiGridListSetItemText(liste2, hasarsayi2, 3, ""..ad2.."", false, false)
		 guiGridListSetItemText(liste2, hasarsayi2, 4, ""..yer.."", false, false)
		 guiGridListSetItemText(liste2, hasarsayi2, 5, ""..tarih.."", false, false)	
		 hasarsayi2 = hasarsayi2+1
		 bekleyen2 = true
		 setTimer ( bekleyenindir2, 5000, 1)
		end
	
	if isElement(saldirgan) and getElementType ( saldirgan ) == "player" then
		if not bekleyen then

		 guiGridListAddRow(liste)
		 guiGridListSetItemText(liste, hasarsayi, 1, ""..hasarsayi.."", false, false)
		 guiGridListSetItemText(liste, hasarsayi, 2, ""..math.floor(kayip).."", false, false)
		 guiGridListSetItemText(liste, hasarsayi, 3, ""..ad.."", false, false)
		 guiGridListSetItemText(liste, hasarsayi, 4, ""..yer.."", false, false)
		 guiGridListSetItemText(liste, hasarsayi, 5, ""..tarih.."", false, false)	 
		 
		 hasarsayi = hasarsayi+1
		 bekleyen = true
		 setTimer ( bekleyenindir, 5000, 1)
		end
	end
	
end
addEventHandler ( "onClientPlayerDamage", getLocalPlayer(), hasarAlindi )

function bekleyenindir()
bekleyen = nil
end

function bekleyenindir2()
bekleyen2 = nil
end

function asd()
guiGridListClear ( liste )
guiGridListClear ( liste2 )
end
addEvent( "sifirlaGridlist", true )
addEventHandler( "sifirlaGridlist", localPlayer, asd )
--]]