local informationicons = { }
local h5nzfont = exports.titan_fonts:getFont("AwesomeFont",17)
function showNearbyInformationIconsInformation()
	for index, informationicon in ipairs( exports.titan_global:getNearbyElements(getLocalPlayer(), "marker") ) do
			informationicons[index] = informationicon
	end
	showInformationText()
end
setTimer(showNearbyInformationIconsInformation, 0, 0)

function showInformationText()
	for i = 1, #informationicons, 1 do
	if isElement(informationicons[i]) then
		local x,y,z = getElementPosition(informationicons[i])			
        local cx,cy,cz = getCameraMatrix()
		local information = getElementData(informationicons[i], "informationicon:information")
		local dbid = getElementData(informationicons[i], "informationicon:id")
		if information then
			if getDistanceBetweenPoints3D(cx,cy,cz,x,y,z) <= 40 then
				local px,py,pz = getScreenFromWorldPosition(x,y,z+0.5,0.05)
				if px and isLineOfSightClear(cx, cy, cz, x, y, z, true, true, true, true, true, false, false) then
					dxDrawText("\n "..information, px-4, py-4, px+6, py+6, tocolor(0, 0, 0, 195), 1, h5nzfont, "center", "center", false, false)
					dxDrawText("\n "..information, px, py, px, py, tocolor(150, 0, 0, 195), 1, h5nzfont, "center", "center", false, false)					
				else
				end
			end
		end
	end
	end
end
addEventHandler("onResourceStart", getRootElement(), showInformationText)

