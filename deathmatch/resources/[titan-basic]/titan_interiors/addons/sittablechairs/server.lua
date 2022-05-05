function sitOnChair(x, y, z, rz, chair, offset)
	setPedRotation(source, rz-180)
	setElementFrozen(client, true)
	exports.titan_global:applyAnimation( source, "FOOD", "FF_Sit_Look", -1, true, false, true)
	exports.titan_global:sendLocalMeAction(source, "yavaşça kendini arkasındaki sandalyeye bırakır.")
	for k,v in ipairs(getElementsByType("player")) do
		if (v~=source) then
			triggerClientEvent(v,"csit",source,x,y,z)
		end
	end
end
addEvent("sit", true)
addEventHandler("sit", getRootElement(), sitOnChair)

function removeAnim(player)
	exports.titan_global:removeAnimation( player )
end

function standUp(chair)
	checkWastedChairs(client)
	removeAnim( client )
	setTimer(removeAnim, 200, 1, client)
	setElementFrozen(client, false)
	exports.titan_global:sendLocalMeAction(client, "yavaşça doğrulur.")
	
	for k,v in ipairs(getElementsByType("player")) do
		if (v~=client) then
			triggerClientEvent(v,"cstand",source)
		end
	end
end
addEvent("stand", true)
addEventHandler("stand", getRootElement(), standUp)

--

local haxChairs = {}
function checkWastedChairs(source)
	if haxChairs[source] then
		destroyElement(haxChairs[source].e)
		haxChairs[source] = nil
	end
end

local function same(a,b)
	return math.abs(a-b)<0.1
end
addEvent("chair:allocate", true)
addEventHandler("chair:allocate", root,
	function(model, x, y, z, rx, ry, rz)
		checkWastedChairs(client)
		
		-- check if this chair is used
		for k, v in pairs(haxChairs) do
			if v.d == getElementDimension(client) and v.i == getElementInterior(client) then
				if same(v.x, x) and same(v.y, y) and same(v.z, z) then
					outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 O koltukta şu an bir başkası oturuyor.", client, 255, 0, 0, true)
					return
				end
			end
		end
		
		-- create a chair
		local data = {x = x, y = y, z = z, i = getElementInterior(client), d = getElementDimension(client)}
		data.e = createObject(model, x, y, z, rx, ry, rz)
		setElementDimension(data.e, data.d)
		setElementInterior(data.e, data.i)
		setElementAlpha(data.e, 0)
		haxChairs[client] = data
		
		triggerClientEvent(client, "chair:selfsit", data.e)
	end
)

addEventHandler("onPlayerQuit", root, function() checkWastedChairs(source) end)
