local kenevirpaketleme = createMarker(95.3154296875, -164.658203125, 0.59375, "cylinder",6, 255,0,0,50, source) --paketleme marker
local kenevirSatma = createMarker(2457.7734375, -1968.1416015625, 11.510054588318, "cylinder",4, 255,0,0,50, source) --Satma marker

local alpha = 0
local r, g, b = 244, 193, 9
local size = 0.5
local typem = "cylinder"
local posx, posy, posz =  95.3154296875, -164.658203125, 2.59375

local entradaB = createMarker (posx, posy, posz, typem, size, r, g, b, alpha)

addEventHandler( "onClientRender", root, function (  )
       local x, y, z = getElementPosition( entradaB )
       local Mx, My, Mz = getCameraMatrix(   )
        if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 30 ) then
           local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z +1, 0.07 )
            if ( WorldPositionX and WorldPositionY ) then
			    dxDrawText("/kenevirpaketle", WorldPositionX - 1, WorldPositionY - 1, WorldPositionX - 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/kenevirpaketle", WorldPositionX + 1, WorldPositionY - 1, WorldPositionX + 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/kenevirpaketle", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/kenevirpaketle", WorldPositionX + 1, WorldPositionY + 1, WorldPositionX + 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/kenevirpaketle", WorldPositionX, WorldPositionY, WorldPositionX, WorldPositionY, tocolor(255, 0, 0), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
            end
      end
end 
)



local alpha = 0
local r, g, b = 244, 193, 9
local size = 0.5
local typem = "cylinder"
local posx, posy, posz =  2457.7734375, -1968.1416015625, 13.510054588318

local entradaB = createMarker (posx, posy, posz, typem, size, r, g, b, alpha)

addEventHandler( "onClientRender", root, function (  )
       local x, y, z = getElementPosition( entradaB )
       local Mx, My, Mz = getCameraMatrix(   )
        if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 30 ) then
           local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z +1, 0.07 )
            if ( WorldPositionX and WorldPositionY ) then
			    dxDrawText("/kenevirsat", WorldPositionX - 1, WorldPositionY - 1, WorldPositionX - 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/kenevirsat", WorldPositionX + 1, WorldPositionY - 1, WorldPositionX + 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/kenevirsat", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/kenevirsat", WorldPositionX + 1, WorldPositionY + 1, WorldPositionX + 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/kenevirsat", WorldPositionX, WorldPositionY, WorldPositionX, WorldPositionY, tocolor(255, 0, 0), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
            end
      end
end 
)


local alpha = 0
local r, g, b = 244, 193, 9
local size = 0.5
local typem = "cylinder"
local posx, posy, posz =  -18.7841796875, -30.2978515625, 3.1171875

local entradaB = createMarker (posx, posy, posz, typem, size, r, g, b, alpha)

addEventHandler( "onClientRender", root, function (  )
       local x, y, z = getElementPosition( entradaB )
       local Mx, My, Mz = getCameraMatrix(   )
        if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 30 ) then
           local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z +1, 0.07 )
            if ( WorldPositionX and WorldPositionY ) then
			    dxDrawText("/kenevirtopla", WorldPositionX - 1, WorldPositionY - 1, WorldPositionX - 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/kenevirtopla", WorldPositionX + 1, WorldPositionY - 1, WorldPositionX + 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/kenevirtopla", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/kenevirtopla", WorldPositionX + 1, WorldPositionY + 1, WorldPositionX + 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/kenevirtopla", WorldPositionX, WorldPositionY, WorldPositionX, WorldPositionY, tocolor(255, 0, 0), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
            end
      end
end 
)







