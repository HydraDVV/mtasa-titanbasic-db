-- state variables
local speed = 0
local strafespeed = 0
local rotX, rotY = 0,0
local velocityX, velocityY, velocityZ
local startX, startY, startZ

-- configurable parameters
local options = {
	invertMouseLook = false,
	normalMaxSpeed = 2,
	slowMaxSpeed = 0.2,
	fastMaxSpeed = 12,
	smoothMovement = true,
	acceleration = 0.3,
	decceleration = 0.15,
	mouseSensitivity = 0.1,
	maxYAngle = 188,
	key_fastMove = "lshift",
	key_slowMove = "lalt",
	key_forward = "w",
	key_backward = "s",
	key_left = "a",
	key_right = "d"
}

local mouseFrameDelay = 0

local rootElement = getRootElement()
local localPlayer = getLocalPlayer()

local getKeyState = getKeyState
do
	local mta_getKeyState = getKeyState
	function getKeyState(key)
		if isMTAWindowActive() then
			return false
		else
			return mta_getKeyState(key)
		end
	end
end

-- PRIVATE

local function freecamFrame ()
    -- work out an angle in radians based on the number of pixels the cursor has moved (ever)
    local cameraAngleX = rotX
    local cameraAngleY = rotY

    local freeModeAngleZ = math.sin(cameraAngleY)
    local freeModeAngleY = math.cos(cameraAngleY) * math.cos(cameraAngleX)
    local freeModeAngleX = math.cos(cameraAngleY) * math.sin(cameraAngleX)
    local camPosX, camPosY, camPosZ = getCameraMatrix()

    -- calculate a target based on the current position and an offset based on the angle
    local camTargetX = camPosX + freeModeAngleX * 100
    local camTargetY = camPosY + freeModeAngleY * 100
    local camTargetZ = camPosZ + freeModeAngleZ * 100

	-- Calculate what the maximum speed that the camera should be able to move at.
    local mspeed = options.normalMaxSpeed
    if getKeyState ( options.key_fastMove ) then
        mspeed = options.fastMaxSpeed
	elseif getKeyState ( options.key_slowMove ) then
		mspeed = options.slowMaxSpeed
    end
	
	if options.smoothMovement then
		local acceleration = options.acceleration
		local decceleration = options.decceleration
	
	    -- Check to see if the forwards/backwards keys are pressed
	    local speedKeyPressed = false
	    if getKeyState ( options.key_forward ) then
			speed = speed + acceleration 
	        speedKeyPressed = true
	    end
		if getKeyState ( options.key_backward ) then
			speed = speed - acceleration 
	        speedKeyPressed = true
	    end

	    -- Check to see if the strafe keys are pressed
	    local strafeSpeedKeyPressed = false
		if getKeyState ( options.key_right ) then
	        if strafespeed > 0 then -- for instance response
	            strafespeed = 0
	        end
	        strafespeed = strafespeed - acceleration / 2
	        strafeSpeedKeyPressed = true
	    end
		if getKeyState ( options.key_left ) then
	        if strafespeed < 0 then -- for instance response
	            strafespeed = 0
	        end
	        strafespeed = strafespeed + acceleration / 2
	        strafeSpeedKeyPressed = true
	    end

	    -- If no forwards/backwards keys were pressed, then gradually slow down the movement towards 0
	    if speedKeyPressed ~= true then
			if speed > 0 then
				speed = speed - decceleration
			elseif speed < 0 then
				speed = speed + decceleration
			end
	    end

	    -- If no strafe keys were pressed, then gradually slow down the movement towards 0
	    if strafeSpeedKeyPressed ~= true then
			if strafespeed > 0 then
				strafespeed = strafespeed - decceleration
			elseif strafespeed < 0 then
				strafespeed = strafespeed + decceleration
			end
	    end

	    -- Check the ranges of values - set the speed to 0 if its very close to 0 (stops jittering), and limit to the maximum speed
	    if speed > -decceleration and speed < decceleration then
	        speed = 0
	    elseif speed > mspeed then
	        speed = mspeed
	    elseif speed < -mspeed then
	        speed = -mspeed
	    end
	 
	    if strafespeed > -(acceleration / 2) and strafespeed < (acceleration / 2) then
	        strafespeed = 0
	    elseif strafespeed > mspeed then
	        strafespeed = mspeed
	    elseif strafespeed < -mspeed then
	        strafespeed = -mspeed
	    end
	else
		speed = 0
		strafespeed = 0
		if getKeyState ( options.key_forward ) then speed = mspeed end
		if getKeyState ( options.key_backward ) then speed = -mspeed end
		if getKeyState ( options.key_left ) then strafespeed = mspeed end
		if getKeyState ( options.key_right ) then strafespeed = -mspeed end
	end

    -- Work out the distance between the target and the camera (should be 100 units)
    local camAngleX = camPosX - camTargetX
    local camAngleY = camPosY - camTargetY
    local camAngleZ = 0 -- we ignore this otherwise our vertical angle affects how fast you can strafe

    -- Calulcate the length of the vector
    local angleLength = math.sqrt(camAngleX*camAngleX+camAngleY*camAngleY+camAngleZ*camAngleZ)

    -- Normalize the vector, ignoring the Z axis, as the camera is stuck to the XY plane (it can't roll)
    local camNormalizedAngleX = camAngleX / angleLength
    local camNormalizedAngleY = camAngleY / angleLength
    local camNormalizedAngleZ = 0

    -- We use this as our rotation vector
    local normalAngleX = 0
    local normalAngleY = 0
    local normalAngleZ = 1

    -- Perform a cross product with the rotation vector and the normalzied angle
    local normalX = (camNormalizedAngleY * normalAngleZ - camNormalizedAngleZ * normalAngleY)
    local normalY = (camNormalizedAngleZ * normalAngleX - camNormalizedAngleX * normalAngleZ)
    local normalZ = (camNormalizedAngleX * normalAngleY - camNormalizedAngleY * normalAngleX)

    -- Update the camera position based on the forwards/backwards speed
    camPosX = camPosX + freeModeAngleX * speed
    camPosY = camPosY + freeModeAngleY * speed
    camPosZ = camPosZ + freeModeAngleZ * speed

    -- Update the camera position based on the strafe speed
    camPosX = camPosX + normalX * strafespeed
    camPosY = camPosY + normalY * strafespeed
    camPosZ = camPosZ + normalZ * strafespeed
	
	--Store the velocity
	velocityX = (freeModeAngleX * speed) + (normalX * strafespeed)
	velocityY = (freeModeAngleY * speed) + (normalY * strafespeed)
	velocityZ = (freeModeAngleZ * speed) + (normalZ * strafespeed)

    -- Update the target based on the new camera position (again, otherwise the camera kind of sways as the target is out by a frame)
    camTargetX = camPosX + freeModeAngleX * 100
    camTargetY = camPosY + freeModeAngleY * 100
    camTargetZ = camPosZ + freeModeAngleZ * 100

    -- Set the new camera position and target
    setCameraMatrix ( camPosX, camPosY, camPosZ, camTargetX, camTargetY, camTargetZ )
    setElementPosition ( localPlayer, camPosX, camPosY, camPosZ )
end

local function freecamMouse (cX,cY,aX,aY)
	--ignore mouse movement if the cursor or MTA window is on
	--and do not resume it until at least 5 frames after it is toggled off
	--(prevents cursor mousemove data from reaching this handler)
	if isCursorShowing() or isMTAWindowActive() then
		mouseFrameDelay = 5
		return
	elseif mouseFrameDelay > 0 then
		mouseFrameDelay = mouseFrameDelay - 1
		return
	end
	
	-- how far have we moved the mouse from the screen center?
    local width, height = guiGetScreenSize()
    aX = aX - width / 2 
    aY = aY - height / 2
	
	--invert the mouse look if specified
	if options.invertMouseLook then
		aY = -aY
	end
	
    rotX = rotX + aX * options.mouseSensitivity * 0.01745
    rotY = rotY - aY * options.mouseSensitivity * 0.01745
	
	local PI = math.pi
	if rotX > PI then
		rotX = rotX - 2 * PI
	elseif rotX < -PI then
		rotX = rotX + 2 * PI
	end
	
	if rotY > PI then
		rotY = rotY - 2 * PI
	elseif rotY < -PI then
		rotY = rotY + 2 * PI
	end
    -- limit the camera to stop it going too far up or down - PI/2 is the limit, but we can't let it quite reach that or it will lock up
	-- and strafeing will break entirely as the camera loses any concept of what is 'up'
    if rotY < -PI / 2.05 then
       rotY = -PI / 2.05
    elseif rotY > PI / 2.05 then
        rotY = PI / 2.05
    end
end

-- PUBLIC

function getFreecamVelocity()
	return velocityX,velocityY,velocityZ
end

-- params: x, y, z  sets camera's position (optional)
function setFreecamEnabled (x, y, z)
    startX, startY, startZ = getElementPosition(localPlayer)
	addEventHandler("onClientRender", rootElement, freecamFrame)
	addEventHandler("onClientCursorMove",rootElement, freecamMouse)
	setElementData(localPlayer, "freecam:state", true, false)
	setPedWeaponSlot(localPlayer, 0)
	toggleAllControls(false, true, false)
	return true
end

-- param:  dontChangeFixedMode  leaves toggleCameraFixedMode alone if true, disables it if false or nil (optional)
function setFreecamDisabled()
	velocityX,velocityY,velocityZ = 0,0,0
	speed = 0
	strafespeed = 0
	removeEventHandler("onClientRender", rootElement, freecamFrame)
	removeEventHandler("onClientCursorMove",rootElement, freecamMouse)
	setElementData(localPlayer, "freecam:state", false, false)
    setCameraTarget(localPlayer, localPlayer)
	toggleAllControls(true)
	triggerEvent("onClientPlayerWeaponCheck", localPlayer)
    --setElementPosition(localPlayer, startX, startY, startZ)
	return true
end

function isFreecamEnabled()
	return getElementData(localPlayer,"freecamTV:state")
end

function isPlayerFreecamEnabled(player)
	return getElementData(player,"freecamTV:state")
end

function getFreecamOption(theOption, value)
	return options[theOption]
end

function setFreecamOption(theOption, value)
	if options[theOption] ~= nil then
		options[theOption] = value
		return true
	else
		return false
	end
end

addEvent("doSetFreecamEnabled", true)
addEventHandler("doSetFreecamEnabled", rootElement, setFreecamEnabled)

addEvent("doSetFreecamDisabled", true)
addEventHandler("doSetFreecamDisabled", rootElement, setFreecamDisabled)

addEvent("doSetFreecamOption", true)
addEventHandler("doSetFreecamOption", rootElement, setFreecamOption)

function onStart()
	for k, v in pairs(getElementsByType("player")) do
		if getElementData(v, "freecam:state") == true then
			setElementCollisionsEnabled(v, false)
		end
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), onStart)

function onDataChange(name)
	if getElementType(source) == "player" and name == "freecam:state" then
		setElementCollisionsEnabled(source, not getElementData(source, "freecam:state"))
	end
end
addEventHandler("onClientElementDataChange", rootElement, onDataChange)

-- Hanz's rework
function toggleFreecam(cmd)
	if not isEnabled(localPlayer) and cmd == "freecam" then
		if getElementData(localPlayer, "loggedin") == 1 and exports.titan_integration:isPlayerTrialAdmin(localPlayer) or exports.titan_integration:isPlayerScripter(localPlayer) or getElementData(localPlayer, "canFly") then
			--removePedFromVehicle(localPlayer)
			setElementAlpha(localPlayer, 0)
			setElementFrozen(localPlayer, true)
			setFreecamEnabled (x, y, z)
			if getElementData(localPlayer,"reconx") then
				exports['titan_admins']:toggleRecon(false)
			end
			triggerServerEvent("freecam:asyncActivateFreecam", localPlayer)
		end
	elseif isEnabled(localPlayer) then
		setElementAlpha(localPlayer, 255)
		setElementFrozen(localPlayer, false)
		setFreecamDisabled()
		triggerServerEvent("freecam:asyncDeactivateFreecam", localPlayer)
	end
end
addCommandHandler("freecam", toggleFreecam)
addCommandHandler("dropme", toggleFreecam)