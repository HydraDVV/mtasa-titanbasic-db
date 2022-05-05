
local subTag = "titan_"
local importantResources = {
    [subTag .. "mysql"] = true,
    [subTag .. "global"] = true,
	[subTag .. "integration"] = true,
	[subTag .. "data"] = true,
	[subTag .. "pool"] = true,
	[subTag .. "bone_attach"] = true,
	[subTag .. "logs"] = true,
	[subTag .. "vehicle_manager"] = true,
	[subTag .. "vehicle_interiors"] = true,
}
local threadTimer
local threads = {}
local load_speed = 1000
local load_speed_multipler = 6
local canConnect = false

addEventHandler("onResourceStart", resourceRoot,
    function()
        
        for k, v in pairs(importantResources) do
            local res = getResourceFromName(k)
            if res then
                startResource(res)
                outputDebugString(k.. " started.", 3)
            end
        end
        
        for k,v in pairs(getResources()) do
            local subText = utfSub(getResourceName(v), 1, #subTag)
            if subText == subTag and not importantResources[getResourceName(v)] and v ~= getThisResource() then 
                threads[v] = true
            end
        end
        
        threadTimer = setTimer(
            function()
                local num = 0
                
                for k,v in pairs(threads) do
                    num = num + 1
                    
                    if num > load_speed_multipler then
                        break
                    end
                    
                    startResource(k)
                    
                    threads[k] = nil
                    
                    outputDebugString(getResourceName(k).. " started.", 0)
                end
                
                local length = 0
                for k,v in pairs(threads) do length = length + 1 end
                if length == 0 then
                    killTimer(threadTimer)
                    threadTimer = nil
                    canConnect = true
                end
            end, load_speed, 0
        )
    end
)

addEventHandler("onPlayerConnect", root,
    function()
        if not canConnect then
            cancelEvent(true,"Hata!\nSunucu şu anda açılıyor, sabırla bekle.")
        end
    end
)

function hasPermission(element)
    return exports['titan_global']:getPlayerDeveloper(element)
end