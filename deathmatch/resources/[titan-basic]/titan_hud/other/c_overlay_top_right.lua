local localPlayer = getLocalPlayer()
local show = false
local width, height = 246,300
local sx, sy = guiGetScreenSize()

local content = {}
local timerClose = nil
local cooldownTime = 20 --seconds
--local BizNoteFont20 = dxCreateFont ( "fonts/Roboto.ttf" , 13 )
local awfont = exports.titan_fonts:getFont("FontAwesome", 10)
local BizNoteFont20 = exports.titan_fonts:getFont("AwesomeFont", 16)
local Roboto = exports.titan_fonts:getFont("Roboto", 10)
--local Roboto = dxCreateFont ( "fonts/Roboto.ttf" , 10 )
local toBeDrawnWidth = width
local justClicked = false

function drawOverlayTopRight(info, widthNew, posXOffsetNew, posYOffsetNew, cooldown)
	local pinned = getElementData(localPlayer, "hud:pin")
	if not pinned and timerClose and isTimer(timerClose) then
		killTimer(timerClose)
		timerClose = nil
	end
	if info then
		content = info
		content[1][1] = string.sub(content[1][1], 1, 1)..string.sub(content[1][1], 2)
	else
		return false
	end
	
	if posXOffsetNew then
		posXOffset = posXOffsetNew
	end
	if posYOffsetNew then
		posYOffset = posYOffsetNew
	end
	if cooldown then
		cooldownTime = cooldown
	end
	if content then
		show = true
	end
	
	toBeDrawnWidth = width
	
	playSoundFrontEnd ( 101 )
	if cooldownTime ~= 0 and not pinned then
		timerClose = setTimer(function()
			show = false
			setElementData(localPlayer, "hud:overlayTopRight", 0, false)
		end, cooldownTime*1000, 1)
	end
	
	for i=1, #info do
		outputConsole(info[i][1] or "")
	end
end
addEvent("hudOverlay:drawOverlayTopRight", true)
addEventHandler("hudOverlay:drawOverlayTopRight", localPlayer, drawOverlayTopRight)

setTimer(function ()
	if show and not getElementData(localPlayer, "integration:previewPMShowing") and getElementData(localPlayer, 'loggedin') == 1 then 
		if ( getPedWeapon( localPlayer ) ~= 43 or not getPedControlState( localPlayer, "aim_weapon" ) ) then
			local posXOffset, posYOffset = 0, 270
			local hudDxHeight = getElementData(localPlayer, "hud:whereToDisplayY") or 0
			if hudDxHeight then
				posYOffset = posYOffset + hudDxHeight + 20
			end
			
			local reportDxHeight = getElementData(localPlayer, "report-system:dxBoxHeight") or 0
			if reportDxHeight then
				posYOffset = posYOffset + reportDxHeight
			end

	

	
		

			roundedRectangle(sx-toBeDrawnWidth-5+posXOffset, 5+posYOffset, toBeDrawnWidth, 16*(#content)+35, tocolor(50,50,50,210), tocolor(40,40,40,210))
			
			for i=1, #content do
				if content[i] then
					local currentWidth = dxGetTextWidth ( (content[i][1] or "" ) , 1 , Roboto) + 30
					if currentWidth > toBeDrawnWidth then
						toBeDrawnWidth = currentWidth
					end
					
					if i == 1 or content[i][7] == "title" then --Title
						
						dxDrawText( content[i][1] or "" , sx-toBeDrawnWidth+10+posXOffset, (16*i)+posYOffset, toBeDrawnWidth-5, 15, tocolor ( 225, 225, 225), 1, BizNoteFont20 )
					else
						dxDrawText( content[i][1] or "" , sx-toBeDrawnWidth+10+posXOffset, (16*i)+posYOffset, toBeDrawnWidth-5, 15, tocolor ( content[i][2] or 255, content[i][3] or 255, content[i][4] or 255, content[i][5] or 255 ), content[i][6] or 1, Roboto )
					end
				end
			end
		end
	end
end, 5, 0)

function pinIt()
	setElementData(localPlayer, "hud:pin", true, false)
	if timerClose and isTimer(timerClose) then
		killTimer(timerClose)
		timerClose = nil
	end
end

function unpinIt()
	pinIt()
	setElementData(localPlayer, "hud:pin", false, false)
	timerClose = setTimer(function()
		show = false
		setElementData(localPlayer, "hud:overlayTopRight", 0, false)
	end, 3000, 1)
end

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 180)
		end
		if (not bgColor) then
			bgColor = borderColor
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
        
        --Sarkokba pötty:
        dxDrawRectangle(x + 0.5, y + 0.5, 1, 2, borderColor, postGUI);
        dxDrawRectangle(x + 0.5, y + h - 1.5, 1, 2, borderColor, postGUI);
        dxDrawRectangle(x + w - 0.5, y + 0.5, 1, 2, borderColor, postGUI);
        dxDrawRectangle(x + w - 0.5, y + h - 1.5, 1, 2, borderColor, postGUI);
	end
end