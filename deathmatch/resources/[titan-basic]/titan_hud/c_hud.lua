local width, height = 250,26
local sx, sy = guiGetScreenSize()
local toBeDrawnWidth = width
local awesome = exports.titan_fonts:getFont('FontAwesome',11)
local roboto = exports.titan_fonts:getFont('Roboto',11)
function render()
if getElementData(localPlayer, "radaracik") == 1 then return end
local posXOffset, posYOffset = 15, 10
if getElementData(getLocalPlayer(),'loggedin') then

        roundedRectangle(sx-toBeDrawnWidth-5+posXOffset-20, 5+posYOffset+2, toBeDrawnWidth, height, tocolor(65,65,65,190))
        dxDrawRectangle(sx-toBeDrawnWidth-5+posXOffset-20, 5+posYOffset-3, (getElementData(getLocalPlayer(),'thirst') or 100)/0.400, 2, tocolor(119,187,238,150))
        dxDrawRectangle(sx-toBeDrawnWidth-5+posXOffset-20, 5+posYOffset+31, (getElementData(getLocalPlayer(),'hunger') or 100)/0.400, 2, tocolor(255,221,7,150))
        dxDrawText("₺"..exports.titan_global:formatMoney(exports.titan_global:getMoney(getLocalPlayer()) or 0).."",sx-toBeDrawnWidth-5+posXOffset+215 - dxGetTextWidth(exports.titan_global:getMoney(getLocalPlayer())..'$',1,roboto), 5+posYOffset+4, toBeDrawnWidth, height, tocolor ( 119,187,238, 255 ), 1, roboto )
        dxDrawText(getPlayerName(getLocalPlayer()):gsub("_", " ").."",sx-toBeDrawnWidth-5+posXOffset-18, 5+posYOffset+4, toBeDrawnWidth, height, tocolor ( 220,220,220, 255 ), 1, roboto)
    end
end	
setTimer(render,5,0)

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 180)
		end
		if (not bgColor) then
			bgColor = borderColor
		end
        dxDrawRectangle(x, y, w, h, bgColor, postGUI);
        dxDrawRectangle(x, y+1, w, h+1, bgColor, postGUI);
	end
end

local components = { "weapon", "ammo", "health", "clock", "money", "breath", "armour", "wanted" }
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
function ()
	for _, component in ipairs( components ) do
		setPlayerHudComponentVisible( component, false )
	end
end)