local objects = 
{
createObject(3893,1815.2399900,-1343.1300000,147.8380000,0.0000000,0.0000000,0.0000000,0),
createObject(3891,1803.8180000,-1333.7947000,149.8560000,0.0000000,0.0000000,270.0000000,0),
createObject(3905,1818.3071000,-1343.7100000,151.8900000,0.0000000,0.0000000,0.0000000,0),
createObject(3906,1809.1000000,-1348.3000000,150.0340000,0.0000000,0.0000000,0.0000000,0),
createObject(3898,1812.2200000,-1340.3000000,150.1219900,0.0000000,0.0000000,0.0000000,0),
createObject(3907,1812.0400000,-1325.5800000,152.2300000,0.0000000,0.0000000,0.0000000,0),
createObject(3897,1817.9800000,-1333.6700000,151.4890000,0.0000000,0.0000000,90.0000000,0),
createObject(3923,1817.7099600,-1347.8399700,149.9400000,0.0000000,0.0000000,0.0000000,0),
createObject(3924,1809.3423000,-1341.8875000,148.6580000,0.0000000,0.0000000,88.7500000,0),
createObject(3063,1807.4845000,-1333.8700000,149.5679900,0.0000000,0.0000000,0.0000000,0),
createObject(3064,1808.9301000,-1333.1500000,153.0310100,0.0000000,0.0000000,0.0000000,0),
createObject(3078,1815.3900000,-1345.8199000,148.9689900,0.0000000,0.0000000,240.0000000,0),
createObject(3082,1815.0308000,-1345.6740000,148.7400100,0.0000000,0.0000000,0.0000000,0),
createObject(3112,1808.7900000,-1342.3900000,152.0390000,0.0000000,0.0000000,0.0000000,0),
createObject(1492,1812.5275000,-1327.6700000,151.4396100,0.0000000,0.0000000,0.0000000,0),
createObject(1492,1811.6960000,-1333.0530000,151.4396100,0.0000000,0.0000000,270.0000000,0),
createObject(1492,1813.8733000,-1336.6270000,151.4396100,0.0000000,0.0000000,180.0000000,0),
createObject(1492,1804.9279000,-1336.9828000,148.0646100,0.0000000,0.0000000,179.9950000,0),
createObject(1492,1797.7408000,-1349.7902000,148.6396000,0.0000000,0.0000000,89.9950000,0),
createObject(3034,1824.3352000,-1345.7196000,148.7236000,0.0000000,0.0000000,270.0000000,0),
createObject(8324,1804.9386000,-1387.7083000,146.9008000,0.0000000,0.0000000,0.0000000,0),
createObject(8324,1804.9385000,-1387.7080000,142.9010000,0.0000000,0.0000000,0.0000000,0),
createObject(3051,1815.5170000,-1401.5527000,146.2285000,0.0000000,0.0000000,46.0000000,0),
createObject(3051,1815.5212000,-1402.7288000,146.2285000,0.0000000,0.0000000,46.0000000,0),
createObject(7708,1807.7650000,-1374.3590000,144.9413000,0.0000000,0.0000000,180.0000000,0),
}

local col = createColSphere(1815.2399900,-1343.1300000,147.8380000,150)
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

for index, object in ipairs ( objects ) do
    setElementDoubleSided ( object, true )
	if getElementModel(object) == 3034 then
		setObjectScale ( object, 3 )
	end

end