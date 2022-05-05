
local crosshairs = {}
local shader = false
local currentCrosshair = nil

addEventHandler("onClientResourceStart", root, function()
    shader = dxCreateShader("crosshair/texreplace.fx")

    addCrosshair("crosshair/crosshairs/1.png")
    addCrosshair("crosshair/crosshairs/2.png")
    addCrosshair("crosshair/crosshairs/3.png")
    addCrosshair("crosshair/crosshairs/4.png")
end)

function changeCrosshair(id)
    if not shader then
        return
    end

    if not id then
        return
    end

    local crosshairPath = crosshairs[id]
    local texture = dxCreateTexture(crosshairPath)

    engineApplyShaderToWorldTexture(shader, "siteM16")
    dxSetShaderValue(shader, "gTexture", texture)
    currentCrosshair = id
end

function resetCrosshair()
    engineRemoveShaderFromWorldTexture(shader, "siteM16")
    currentCrosshair = nil
end

function addCrosshair(path)
    table.insert(crosshairs, path)
end

function getCrosshairs()
    return #crosshairs, crosshairs
end

addCommandHandler("crosshair", function(cmd, id)
    if not id then
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Crosshairinizi sıfırladınız, başka bir Crosshair seçmek için /crosshair [1-4]", 255, 0, 0, true)
    else
		if tonumber(id) < 0 or tonumber(id) > 4 then outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 1-4 değeri arasında bir sayı giriniz.", 255, 0, 0, true) return end
        changeCrosshair(tonumber(id))
		outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Crosshairinizi "..tonumber(id).." ID'li Crosshair olarak ayarladınız.", 0, 255, 255, true)
    end
end)

addEventHandler("onClientResourceStart", root, function()
    changeCrosshair(4)
end)
