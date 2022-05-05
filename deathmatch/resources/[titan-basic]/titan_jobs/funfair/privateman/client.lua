
function addLabelOnClick ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
	if button == "right" and state == "down" then
		if clickedElement and getElementData(clickedElement, "hediye:npc")  then
			local x,y,z = getElementPosition(localPlayer)
			local x1,y1,z1 = getElementPosition(clickedElement)
			if getDistanceBetweenPoints3D(x,y,z,x1,y1,z1) < 3 then
				panelim()
			end
	   end
	end
end
addEventHandler ( "onClientClick", getRootElement(), addLabelOnClick )

function addLabelOnClick2 ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
	if button == "right" and state == "down" then
		if clickedElement and getElementData(clickedElement, "hediyebulundu:npc")  then
			local x,y,z = getElementPosition(localPlayer)
			local x1,y1,z1 = getElementPosition(clickedElement)
			if getDistanceBetweenPoints3D(x,y,z,x1,y1,z1) < 3 then
				if getElementData(resourceRoot, "hediye:meslek" .. getElementData(localPlayer, "account:id")) then
				panelim2()
				else
				outputChatBox("[-]#f9f9f9 Mesleğe katılmamışsın.", 255, 0, 0, true)
				end
			end
	   end
	end
end
addEventHandler ( "onClientClick", getRootElement(), addLabelOnClick2 )

function panelim () 
	if isElement(window) then 
		destroyElement(window)
	return end
	window = guiCreateWindow ( 0, 0, 400,110, ""..exports["titan_pool"]:getServerName().." Roleplay - Gizemli Adam", false )
	exports.titan_global:centerWindow(window)
	guiWindowSetSizable ( window, false )
	text = guiCreateLabel(0,25,400,16*2, "Selam dostum, bulmam gereken birisi var.\nBana yardımcı olur musun?",false,window)
	guiLabelSetHorizontalAlign(text,"center")
	guiSetFont(text, "default-bold-small")
	onay = guiCreateButton(0,65,400/2-10,35,"Tabii ki.",false,window)
	if  getElementData(resourceRoot, "hediye:meslek" .. getElementData(localPlayer, "account:id")) then guiSetEnabled(onay, false) guiSetText(onay, "Zaten katılmışsın.") end
	guiSetFont(onay, "default-bold-small")
	iptal = guiCreateButton(200,65,400/2,35,"Arayüzü Kapat",false,window)
	guiSetFont(iptal, "default-bold-small")
end

function panelim2 () 
	if isElement(windowa) then 
		destroyElement(windowa)
	return end
	windowa = guiCreateWindow ( 0, 0, 400,110, "Şüpheli Adam", false )
	exports.titan_global:centerWindow(windowa)
	guiWindowSetSizable ( windowa, false )
	text2 = guiCreateLabel(0,25,400,16*2, "Kahretsin, beni yakaladın.\nSon paramı da sana veriyorum.",false,windowa)
	guiLabelSetHorizontalAlign(text2,"center")
	guiSetFont(text2, "default-bold-small")
	onay2 = guiCreateButton(0,65,400/2-10,35,"Ver ulan parayı.",false,windowa)
	if getElementData(resourceRoot, "hediyebulundu:meslek" .. getElementData(localPlayer, "account:id")) then guiSetEnabled(onay2, false) guiSetText(onay2, "Zaten almışsın.") guiSetText(text2, "Bilader zaten az önce soydun ya beni.\nBir git işine Allah aşkına.") end
	guiSetFont(onay2, "default-bold-small")
	iptal2 = guiCreateButton(200,65,400/2,35,"Arayüzü Kapat",false,windowa)
	guiSetFont(iptal2, "default-bold-small")
end


function tiklama1 (b,s,x,y)
	if b == "left" then
		if source == onay2 then
		if getElementData(resourceRoot, "hediyebulundu:meslek" .. getElementData(localPlayer, "account:id")) then outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Zaten bu ödülü almışsın.", 255, 0, 0, true) return false end
			outputChatBox("[-]#f9f9f9 Şüpheli şahısı yakalayıp gizemli mesleği tamamladın.",120, 237, 107,true)
			outputChatBox("[+]#f9f9f9 10.000 Türk Lirası kazandın.",120,237,107,true)
			triggerServerEvent("gizemliFinish", localPlayer, localPlayer)
			setElementData(resourceRoot, "hediyebulundu:meslek" .. getElementData(localPlayer, "account:id"), true)
			destroyElement(windowa)
		elseif source == iptal2 then
			destroyElement(windowa)
		end
	end
end
addEventHandler ( "onClientGUIClick", root, tiklama1 )

function tiklama (b,s,x,y)
	if b == "left" then
		if source == onay then
		if getElementData(resourceRoot, "hediye:meslek" .. getElementData(localPlayer, "account:id")) then outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#f9f9f9 Zaten bu mesleğe katılmışsın.", 255, 0, 0, true) return false end
			outputChatBox("[-]#f9f9f9 Gizemli mesleğe katıldın, şimdi Los Santos'un Galton veya Winewood ilçesindeki gizemli adamı bul ve büyük ödülü kazan.",120, 237, 107,true)
			outputChatBox("[Tüyo]#f9f9f9 Adam sarı şapkalı birisi mavi şortlu yıldızlı t-shirti var.",220, 37, 107,true)
			setElementData(resourceRoot, "hediye:meslek" .. getElementData(localPlayer, "account:id"), true)
			destroyElement(window)
		elseif source == iptal then
			destroyElement(window)
		end
	end
end
addEventHandler ( "onClientGUIClick", root, tiklama )

