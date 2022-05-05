-- Displaying the increase in skill
local sx, sy, text, count, addedEvent, alpha
local langInc = 0

function increaseInSkill(language)
	local localPlayer = getLocalPlayer()
	
	local x, y, z = getPedBonePosition(localPlayer, 6)
	sx, sy = getScreenFromWorldPosition(x, y, z+0.2, 100, false)
	
	langInc = langInc + 1
	
	text = "+" .. langInc .. " " .. languages[language] .. " (" .. string.gsub(getPlayerName(source), "_", " ") .. ")"
	
	count = 0
	alpha = 255
	if not (addedEvent) then
		addedEvent = true
		addEventHandler("onClientRender", getRootElement(), renderText)
	end
end
addEvent("increaseInSkill", true)
addEventHandler("increaseInSkill", getRootElement(), increaseInSkill)

function renderText()
	if not sx or not sy then return end
	count = count + 1
	dxDrawText(text, sx-150, sy, sx+200, sy+50, tocolor(255, 255, 255, alpha), 1, "diploma", "center", "center")
	
	sy = sy - 3
	alpha = alpha - 6
	
	if (alpha<0) then alpha = 0 end
	
	if (count>50) then
		removeEventHandler("onClientRender", getRootElement(), renderText)
		addedEvent = false
		langInc = 0
	end
end

tlanguages = nil
currslot = nil
wLanguages = nil

