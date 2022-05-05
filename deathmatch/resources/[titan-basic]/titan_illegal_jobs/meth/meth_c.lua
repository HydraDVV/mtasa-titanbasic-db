local methpaketleme = createMarker( 113.392578125, -154.103515625, -1.578125, "cylinder",6, 0,128,0,50, source) --Paketleme marker
local methsatma = createMarker( 2442.51953125, -1966.400390625, 11.546875, "cylinder",4, 0,128,0,50, source) --Satma marker

--Bundan aşağısı yazı font yazı şekli.
local alpha = 0
local r, g, b = 244, 193, 9
local size = 0.5
local typem = "cylinder"
local posx, posy, posz =  113.392578125, -154.103515625, 1.578125

local entradaB = createMarker (posx, posy, posz, typem, size, r, g, b, alpha)

addEventHandler( "onClientRender", root, function (  )
       local x, y, z = getElementPosition( entradaB )
       local Mx, My, Mz = getCameraMatrix(   )
        if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 30 ) then
           local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z +1, 0.07 )
            if ( WorldPositionX and WorldPositionY ) then
			    dxDrawText("/methpaketle", WorldPositionX - 1, WorldPositionY - 1, WorldPositionX - 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/methpaketle", WorldPositionX + 1, WorldPositionY - 1, WorldPositionX + 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/methpaketle", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/methpaketle", WorldPositionX + 1, WorldPositionY + 1, WorldPositionX + 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/methpaketle", WorldPositionX, WorldPositionY, WorldPositionX, WorldPositionY, tocolor(0, 128, 0), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
            end
      end
end 
)



local alpha = 0
local r, g, b = 244, 193, 9
local size = 0.5
local typem = "cylinder"
local posx, posy, posz =  2442.51953125, -1966.400390625, 13.546875

local entradaB = createMarker (posx, posy, posz, typem, size, r, g, b, alpha)

addEventHandler( "onClientRender", root, function (  )
       local x, y, z = getElementPosition( entradaB )
       local Mx, My, Mz = getCameraMatrix(   )
        if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 30 ) then
           local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z +1, 0.07 )
            if ( WorldPositionX and WorldPositionY ) then
			    dxDrawText("/methsat", WorldPositionX - 1, WorldPositionY - 1, WorldPositionX - 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/methsat", WorldPositionX + 1, WorldPositionY - 1, WorldPositionX + 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/methsat", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/methsat", WorldPositionX + 1, WorldPositionY + 1, WorldPositionX + 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/methsat", WorldPositionX, WorldPositionY, WorldPositionX, WorldPositionY, tocolor(0, 128, 0), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
            end
      end
end 
)


local alpha = 0
local r, g, b = 244, 193, 9
local size = 0.5
local typem = "cylinder"
local posx, posy, posz = 1093.8095703125, -256.53515625, 74.652481079102

local entradaB = createMarker (posx, posy, posz, typem, size, r, g, b, alpha)

addEventHandler( "onClientRender", root, function (  )
       local x, y, z = getElementPosition( entradaB )
       local Mx, My, Mz = getCameraMatrix(   )
        if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 30 ) then
           local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z +1, 0.07 )
            if ( WorldPositionX and WorldPositionY ) then
			    dxDrawText("/methtopla", WorldPositionX - 1, WorldPositionY - 1, WorldPositionX - 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/methtopla", WorldPositionX + 1, WorldPositionY - 1, WorldPositionX + 1, WorldPositionY - 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/methtopla", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/methtopla", WorldPositionX + 1, WorldPositionY + 1, WorldPositionX + 1, WorldPositionY + 1, tocolor(0, 0, 0, 255), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
			    dxDrawText("/methtopla", WorldPositionX, WorldPositionY, WorldPositionX, WorldPositionY, tocolor(0, 128, 0), 1.00, "bankgothic", "center", "center", false, false, false, false, false)
            end
      end
end 
)







