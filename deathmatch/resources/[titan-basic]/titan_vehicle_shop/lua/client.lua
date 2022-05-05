local sx , sy = guiGetScreenSize()
font = DxFont('fonts/Roboto.ttf', 12)
local cbrowser = guiCreateBrowser(0,0 , sx , sy , true , true , false)
local browser  = guiGetBrowser(cbrowser)
guiSetVisible(cbrowser , false)

vehicleShop = {}  
addEventHandler('onClientBrowserCreated', cbrowser,function()
    loadBrowserURL(source , "http://mta/local/index.html")
end)

showCursor(false)

addEvent("alern:carshop" , true)
addEventHandler("alern:carshop" , root , function(shopTable)
    guiSetVisible(cbrowser , true)
    for key , v in pairs(shopTable) do 
        if not vehicleShop[v.spawnto] then vehicleShop[v.spawnto] = {} end
        vehicleShop[v.spawnto][key] = v
    end
end)

settings = {
    selected = {
        ped = nil,
        pos = {0,0},
        state = nil,
        spawnto = nil,
        veh_id = nil,
    },
    buttons = {
        {btn = 'Araç satın al'},
        {btn = 'Kapat'}
    }
}

addEventHandler ( "onClientClick", getRootElement(), function(button, state, sx, sy, _, _, _, element ) 
    if  element and element:getData('alern:carshop:ped') and button == 'right' and state == 'down' then 
        if getDistanceBetweenPoints3D(Vector3(localPlayer.position), Vector3(element.position)) < 3 then 
            if not settings.selected.state then 
                settings.selected.ped = element
                settings.selected.pos = {sx, sy}
                settings.selected.state = true
                addEventHandler('onClientRender', root, render)
            else 
                settings.selected.ped = nil
                settings.selected.pos = {0, 0}
                settings.selected.state = nil
                removeEventHandler('onClientRender', root, render)
            end
        end 
    end 
end)

setCameraTarget(localPlayer)
click = 0
render = function()
    x, y, w, h = settings.selected.pos[1], settings.selected.pos[2], 200, 112
    linedRectangle(x, y, w, h, tocolor(18, 18, 18, 220), tocolor(18, 18, 18, 255), 2)
    dxDrawRectangle(x, y, w, 30, tocolor(0, 0, 0, 150))
    dxDrawText(settings.selected.ped:getData('alern:carshop:ped:name'), x, y, x+w, y+h,tocolor(255, 255 ,255, 160),1, font, "center", "top", false, false, false, true)
    for k,v in ipairs(settings.buttons) do 
        drawButton('Alern'..k, v.btn, x, y + 40+(k*35)-35, w, 30, {255, 255, 255}, {0, 0, 0})
        if isInBox(x, y + 40+(k*35)-35, w, 30) then 
            if getKeyState('mouse1') and click+800 <= getTickCount() then 
                click = getTickCount()
                if tonumber(k) == 1 then 
                    triggerServerEvent('alern:carshop:open', localPlayer, localPlayer)
                    Timer(function()
                        localPlayer:setData('hud:visible', true)
                        triggerEvent("alern:carshop:category" , localPlayer , settings.selected.ped:getData('alern:carshop:ped:id') , true)
                    end, 1000, 1)
                    removeEventHandler('onClientRender', root, render)
                    
                else
                    removeEventHandler('onClientRender', root, render)
                end
            end 
        end 
    end 
end 


addEvent('vehicle_buy', true)
addEventHandler('vehicle_buy', root, function()
    if not settings.selected.veh_id then return end 
    triggerServerEvent("vehicle:buy", localPlayer, vehicleShop[settings.selected.spawnto][settings.selected.veh_id]["gta"], settings.selected.veh_id, {getVehicleColor(veh)}, vehicleShop[settings.selected.spawnto][settings.selected.veh_id]["price"], settings.selected.spawnto)
end)


addEvent('destroy:window', true)
addEventHandler('destroy:window', root, function()
    settings.selected.ped = nil
    settings.selected.pos = {0,0}
    settings.selected.state = nil
    settings.selected.spawnto = nil
    settings.selected.veh_id = nil
    executeBrowserJavascript(browser , 'document.getElementById("vehicle_info").style = "display: none"')
    executeBrowserJavascript(browser , 'clear()')
    if isElement(veh) then veh:destroy() end 
    if isTimer(timer) then killTimer(timer) end 
    setCameraTarget(localPlayer)
    localPlayer:setData('hud:visible', nil)
    --vehicleShop = {}
    guiSetVisible(cbrowser, false)
end)

addEvent("alern:carshop:category" , true)
addEventHandler("alern:carshop:category" , root , function(spawnto, state)
		for k, v in pairs(vehicleShop[spawnto]) do
             brand = v.year..' '..v.brand..' '..v.model
             executeBrowserJavascript(browser , "addRow('"..brand.."', '"..getVehicleNameFromModel(v.gta).."', '"..exports.titan_global:formatMoney(v.price).."', '"..shops[v.spawnto].name.."', '"..v.id.."');")
        end
        settings.selected.spawnto = spawnto
end)

addEvent('selectVehicle', true)
addEventHandler('selectVehicle', root, function(id)
    for k,v in pairs(vehicleShop[settings.selected.spawnto]) do 
        if tonumber(k) == tonumber(id) then 
            if isElement(veh) then veh:destroy() end 
            if isTimer(timer) then killTimer(timer) end 
            executeBrowserJavascript(browser , 'document.getElementById("veh_price").innerHTML = '..v.price ..'')
            executeBrowserJavascript(browser , 'document.getElementById("veh_tax").innerHTML = '..v.tax ..'')
            executeBrowserJavascript(browser , 'document.getElementById("vehicle_info").style = "display: block"')

            veh = createVehicle(v.gta, shops[settings.selected.spawnto].veh_pos[1], shops[settings.selected.spawnto].veh_pos[2], shops[settings.selected.spawnto].veh_pos[3]+0.2)
            timer = Timer(function()
                rx, ry, rz = getElementRotation(veh)
                setElementRotation(veh, rx, ry, rz+0.2)
            end, 0, 0)
            settings.selected.veh_id = tonumber(id)
            veh.frozen = true
            setCameraMatrix(shops[settings.selected.spawnto].veh_pos[1]-6, shops[settings.selected.spawnto].veh_pos[2]+8, shops[settings.selected.spawnto].veh_pos[3]+2, shops[settings.selected.spawnto].veh_pos[1]+50, shops[settings.selected.spawnto].veh_pos[2]-70, shops[settings.selected.spawnto].veh_pos[3]-20)
        end 
    end 
end)

buttonkey = {}
drawButton = function (key, text, x, y, w, h, textColor, rectangleColor)
	if not buttonkey[key] then buttonkey[key] = {} buttonkey[key].alpha = 80 end  
	if isInBox(x, y, w, h) then 
	if buttonkey[key].alpha  < 255 then buttonkey[key].alpha = buttonkey[key].alpha + 5 end 
		linedRectangle(x, y, w, h, tocolor(rectangleColor[1], rectangleColor[2], rectangleColor[3], buttonkey[key].alpha-70), tocolor(rectangleColor[1], rectangleColor[2], rectangleColor[3], buttonkey[key].alpha), 2)
		dxDrawText(text, x, y, x+w, y+h, tocolor(textColor[1], textColor[2], textColor[3], buttonkey[key].alpha),1, font, "center", "center", false, false, false, true)
	else 
		buttonkey[key].alpha = 0
		linedRectangle(x, y, w, h, tocolor(rectangleColor[1], rectangleColor[2], rectangleColor[3], 50), tocolor(rectangleColor[1], rectangleColor[2], rectangleColor[3], 80), 2)
		dxDrawText(text, x, y, x+w, y+h, tocolor(textColor[1], textColor[2], textColor[3], 150),1, font, "center", "center", false, false, false, true)
	end 
end

roundedBorder = function (x, y, w, h, borderColor)
if (x and y and w and h) then
	if (not borderColor) then
	borderColor = tocolor(255, 255, 255, 230)
	end
	
	dxDrawRectangle(x - 1, y + 1, 1, h - 2, borderColor); -- left
	dxDrawRectangle(x + w, y + 1, 1, h - 2, borderColor); -- right
	dxDrawRectangle(x + 1, y - 1, w - 2, 1, borderColor); -- top
	dxDrawRectangle(x + 1, y + h, w - 2, 1, borderColor); -- bottom
	
	dxDrawRectangle(x, y, 1, 1, borderColor);
	dxDrawRectangle(x + w - 1, y, 1, 1, borderColor);
	dxDrawRectangle(x, y + h - 1, 1, 1, borderColor);
	dxDrawRectangle(x + w - 1, y + h - 1, 1, 1, borderColor);
	end
end

local tooltipYet = false
function tooltip( x, y, text, text2 )
	sx,sy = guiGetScreenSize()
	x, y = x*sx, y*sy
	tooltipYet = true
	
	text = tostring( text )
	if text2 then
		text2 = tostring( text2 )
	end
	
	if text == text2 then
		text2 = nil
	end
	
	local width = dxGetTextWidth( text, 1, font ) + 20
	if text2 then
		width = math.max( width, dxGetTextWidth( text2, 1, font ) + 20 )
		text = text .. "\n" .. text2
	end
	local height = 10 * ( text2 and 5 or 3 )
	x = math.max( 10, math.min( x, sx - width - 10 ) )
	y = math.max( 10, math.min( y, sy - height - 10 ) )
	
	linedRectangle( x, y+5, width, height-10, tocolor( 35, 35, 35, 200 ), tocolor( 35, 35, 35, 255 ), 2 )
	dxDrawText( text, x, y, x + width, y + height, tocolor( 255, 255, 255, 255 ), 1, font, "center", "center", false, false, true )
end

isInBox = function (xS,yS,wS,hS)
	if(isCursorShowing()) then
		local cursorX, cursorY = getCursorPosition()
		sX,sY = guiGetScreenSize()
		cursorX, cursorY = cursorX*sX, cursorY*sY
		if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
			return true
		else
			return false
		end
	end	
end

linedRectangle = function (x,y,w,h,color,color2,size)
    if not color then
        color = tocolor(0,0,0,180)
    end
    if not color2 then
        color2 = color
    end
    if not size then
        size = 3
    end
	dxDrawRectangle(x, y, w, h, color)
	dxDrawRectangle(x - size, y - size, w + (size * 2), size, color2)
	dxDrawRectangle(x - size, y + h, w + (size * 2), size, color2)
	dxDrawRectangle(x - size, y, size, h, color2)
	dxDrawRectangle(x + w, y, size, h, color2)
end