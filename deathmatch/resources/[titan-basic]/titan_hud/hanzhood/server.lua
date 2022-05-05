tablo = {} 

isim = ""
alanlar = {--x,y, boyutX, boyutY, renk, adi
	{1812.05, -1942, 400, 330, "00ff00",  "Şehir İstasyonu"},
	{2440, -1725, 105, 95, "00ff00",  "Grove Street"},
	{1378.96, -1834.46, 300, 275, "00ff00",  "Şehir Merkezi"},
	{2722, -1989, 90, 90, "00ff00",  "Aztecas Street"},
	{2396, -1434, 90, 160, "00ff00",  "Vagos Street"},
	{2076, -1345, 90, 110, "00ff00",  "Ballas Street"},
}


addEventHandler("onResourceStart", resourceRoot, function() 
	for i,cols in ipairs (alanlar) do 
		local x,y,bx,by,renk,adi = unpack(cols) 
		local r,g,b = hexToRGB( renk ) 
		local alan = createColCuboid (x,y,-50,bx,by, 5000) 
		local area = createRadarArea (x,y,bx,by,r,g,b,60) 
		if not tablo[alan] then tablo[alan] = {} end 
		tablo[alan].area = area
		isim = "#64b464'"..adi.."' #ffffffBu Alanda İl-legal Roleplay Yapmanız Yasaktır."
		tablo[alan].adi = isim
		addEventHandler("onColShapeHit", alan, alanaGirince) 
		addEventHandler("onColShapeLeave", alan, alandanCikinca) 
	end
end)	


function alanaGirince(giren)
	if isElement(giren) and getElementType(giren) == "player" then 
		triggerClientEvent(giren, "KorumaliAlan:AlanKontrol", giren, tablo[source].area, "Girdi") 
		setElementData(giren, "Alan:giren" ,tablo[source].adi)
		triggerClientEvent(giren, "Alan", giren)
	end
end

function alandanCikinca(cikan) 
	if isElement(cikan) and getElementType(cikan) == "player" then 
		removeElementData(cikan, "Alan:giren")
		triggerClientEvent(cikan, "KorumaliAlan:AlanKontrol", cikan, tablo[source].area, "Cikti") 
	end
end

function hexToRGB( num ) 
  num = string.gsub( num, "#", "" )
  local r = tonumber( "0x" .. string.sub( num, 1, 2 ) ) or 255
  local g = tonumber( "0x" .. string.sub( num, 3, 4 ) ) or 255	
  local b = tonumber( "0x" .. string.sub( num, 5, 6 ) ) or 255
  return r, g, b 
end



