-- Hanz / 2015.1.10

local sw, sh = guiGetScreenSize()
local lastJailtime = nil
local currentSecs = "Hesaplanıyor.."
local timer = nil

function showAdminJailCounter()
	local jailtime = getElementData(localPlayer, "jailtime")
	if jailtime and (tonumber(jailtime) and tonumber(jailtime) > 0) or jailtime == "permanently" then
		if lastJailtime ~= jailtime then
			currentSecs = tonumber(jailtime) and jailtime*60 or jailtime
			lastJailtime = jailtime
			if timer and isTimer(timer) then
				killTimer(timer)
				timer = nil
			end
			if tonumber(currentSecs) then
				timer = setTimer(function ()
					if tonumber(currentSecs) then
						currentSecs = currentSecs - 1
					end
				end, 1000, 59)
			end
		end

		local w, h = 412, 135
		local x, y = (sw-w)/2, 45


	    dxDrawRectangle(x, y, w, h, tocolor(30,30,30, 130), true)

		local w, h = 412, 126
		local x, y = (sw-w)/2, 50
		local xo, yo = (543-x), (28-y)
	    --dxDrawRectangle(543, 28, 412, 126, tocolor(0, 0, 0, 100), true)
	    dxDrawText("Hapis Sistemi © Hanz", 630-xo, 38-yo, 872-xo, 76-yo, tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, false, true, false, false)
	    dxDrawText("Sebep: "..(getElementData(localPlayer, "jailreason") or "Bilinmiyor"), 553-xo, 100-yo, 945-xo, 127-yo, tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", false, true, true, false, false)
	    dxDrawText(tonumber(currentSecs) and exports.titan_datetime:formatSeconds(currentSecs) or jailtime, 558-xo, 59-yo, 945-xo, 114-yo, tocolor(235, 146, 41, 255), 1.00, "pricedown", "center", "center", false, false, true, false, false)
	    dxDrawText("Admin tarafından cezalandırıldı : "..(getElementData(localPlayer, "jailadmin") or "Bilinmiyor"), 553-xo, 117-yo, 945-xo, 144-yo, tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "bottom", false, true, true, false, false)
	else
		currentSecs = "Hesaplanıyor.."
		lastJailtime = nil
	end
end
addEventHandler("onClientRender", root, showAdminJailCounter)

