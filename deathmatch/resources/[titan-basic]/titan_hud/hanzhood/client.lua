event = false
local px, py = guiGetScreenSize()
local hanzfont = exports.titan_fonts:getFont("FontAwesome", 13)
local hanzicon = exports.titan_fonts:getIcon("balance-scale", 10)
function hanz ()
	if getElementData(localPlayer, "Alan:giren") then
		x,y,w,h = px/2-250,py/1-100/2,500,20
		tx,ty,tw,th = x-25,y-68,w-2,10
		dxDrawText(""..hanzicon..""..getElementData(localPlayer, "Alan:giren"),tx+10,ty+70,tw+tx,th+ty,tocolor(1, 160, 0),1, hanzfont,"left","top",false,false,false,true)
	end
end
addEventHandler("onClientRender", root, hanz)

addEvent("KorumaliAlan:AlanKontrol", true)
addEventHandler("KorumaliAlan:AlanKontrol", root, function(area,kontrol)
	if kontrol == "Girdi" then
		event = true
		if event then
		end
		setRadarAreaFlashing(area, true)
	elseif kontrol == "Cikti" then
		event = false
		setRadarAreaFlashing(area, false)
	end
end)


function iptalFunc()
	cancelEvent()
end	