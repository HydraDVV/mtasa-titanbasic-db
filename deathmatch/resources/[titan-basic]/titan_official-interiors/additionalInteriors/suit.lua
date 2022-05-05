local objects = 
{
	-- Underground Parking Garage
	createObject(14581,1106.0000000,-1312.8000488,50,0.0000000,0.0000000,0.0000000, 1),
	createObject(14638,1108.8837890625, -1312, 47.7,0.0000000,0.0000000,0, 1),
	createObject(1715,1103.8486328125, -1319.205078125, 47.68,0.0000000,0.0000000,180, 1),
	createObject(2206,1103, -1318.0009765625, 47.68,0.0000000,0.0000000,0, 1),
	createObject(1715,1102.76953125, -1317.1396484375, 47.68,0.0000000,0.0000000,90, 1),
	createObject(1715,1104.9853515625, -1317.13671875, 47.68,0.0000000,0.0000000,-90, 1)
}

local col = createColSphere(1106.0000000,-1312.8000488,50,100)
local function watchChanges( )
	if getElementDimension( getLocalPlayer( ) ) > 0 and getElementDimension( getLocalPlayer( ) ) ~= getElementDimension( objects[1] ) and getElementInterior( getLocalPlayer( ) ) == getElementInterior( objects[1] ) then
		for key, value in pairs( objects ) do
			setElementDimension( value, getElementDimension( getLocalPlayer( ) ) )
		end
	elseif getElementDimension( getLocalPlayer( ) ) == 0 and getElementDimension( objects[1] ) ~= 65535 then
		for key, value in pairs( objects ) do
			setElementDimension( value, 65535 )
		end
	end
end
addEventHandler( "onClientColShapeHit", col,
	function( element )
		if element == getLocalPlayer( ) then
			addEventHandler( "onClientRender", root, watchChanges )
		end
	end
)
addEventHandler( "onClientColShapeLeave", col,
	function( element )
		if element == getLocalPlayer( ) then
			removeEventHandler( "onClientRender", root, watchChanges )
		end
	end
)
-- Put them standby for now.
for key, value in pairs( objects ) do
	setElementDimension( value, 65535 )
end