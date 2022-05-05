local secretHandle = 'some_shit_that_is_really_secured'

addEventHandler ( "onPlayerJoin", getRootElement(), 
	function ()
		protectElementData(source, "account:id")
		protectElementData(source, "account:username")
		protectElementData(source, "legitnamechange")
		protectElementData(source, "dbid")
	end
);

function allowElementData(thePlayer, index)
	setElementData(thePlayer, secretHandle.."p:"..index, false, false)
end

function protectElementData(thePlayer, index)
	setElementData(thePlayer, secretHandle.."p:"..index, true, false)
end

function changeProtectedElementData(thePlayer, index, newvalue)
	allowElementData(thePlayer, index)
	setElementData(thePlayer, index, newvalue)
	protectElementData(thePlayer, index)
end

function changeProtectedElementDataEx(thePlayer, index, newvalue, sync, nosyncatall)
	if (thePlayer) and (index) then
		if not newvalue then
			newvalue = nil
		end
		if not nosyncatall then
			nosyncatall = false
		end
	
		allowElementData(thePlayer, index)
		setElementData(thePlayer, index, newvalue, sync)

		if not sync then
			if not nosyncatall then
				if getElementType ( thePlayer ) == "player" then
					triggerClientEvent(thePlayer, "edu", getRootElement(), thePlayer, index, newvalue)
				end
			end
		end
		protectElementData(thePlayer, index)
		return true
	end
	return false
end

function changeEld(thePlayer, index, newvalue)
	if source then thePlayer = thePlayer end
	return changeProtectedElementData(thePlayer, index, newvalue)
end
addEvent("anticheat:changeEld", true)
addEventHandler("anticheat:changeEld", root, changeEld)

function setEld(thePlayer, index, newvalue, sync)
	if source then thePlayer = thePlayer end
	local sync2 = false
	local nosyncatall = true
	if sync == "one" then
		sync2 = false
		nosyncatall = false
	elseif sync == "all" then
		sync2 = true
		nosyncatall = false
	else
		sync2 = false
		nosyncatall = true
	end
	return changeProtectedElementDataEx(thePlayer, index, newvalue, sync2, nosyncatall)
end
addEvent("anticheat:setEld", true)
addEventHandler("anticheat:setEld", root, setEld)


function genHandle()
	local hash = ''
	for Loop = 1, math.random(5,16) do
		hash = hash .. string.char(math.random(65, 122))
	end
	return hash
end

function fetchH()
	return secretHandle
end

secretHandle = genHandle()