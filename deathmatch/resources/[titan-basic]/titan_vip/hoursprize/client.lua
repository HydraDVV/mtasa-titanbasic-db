----- client ----
local characters = "1,2,3,4,5,6,7,8,9,0,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,R,S,Q,T,U,V,X,W,Z"
local komuts = split (characters, ",")
local bonusRenkler = {
	{0, 255, 0},
	{204, 255, 0},
	{255, 0, 0}
}

local saat,dakika = 0,0
local dakikaTick = getTickCount()
local odulAl = false -- saat dolduğunda bunu true yapıyom, renderda eğer trueysa süreyi arttırmıyom, ödülü aldığında false yapıyom süre devam ediyo
local komut = nil

addEventHandler("onClientRender", root, function()
	local suan = getTickCount()
	if suan - dakikaTick >= 1000*60 and not odulAl then -- eğer ödül alınmicaksa 
		dakika = dakika + 1
		dakikaTick = suan
		if dakika >= 60 then
			dakika = 0 
			saat = saat +1
			odulAl = true -- ödülün alınması gerekiyo, yani true
			oduluVer() -- ödülleri alabilecek
		end	
	end	
end)


function oduluVer()
local sesler = {
    [1] = "hoursprize/sounds/1.mp3",
	[2] = "hoursprize/sounds/2.mp3",
	[3] = "hoursprize/sounds/3.mp3",
	}
	local randomcek = math.random(1,3)
	local cek = sesler[randomcek]
	
local vip = getElementData(localPlayer,"vipver")

if (vip==4) then
			triggerServerEvent("BonusPara:ÖdülVer",localPlayer)
			deneme = playSound(cek,false) 
	setSoundVolume(deneme, 0.1)
	triggerServerEvent("bonus:vipsaatekle",localPlayer, localPlayer, 1)

else
	komut = komuts[math.random(#komuts)]..komuts[math.random(#komuts)]..komuts[math.random(#komuts)]..komuts[math.random(#komuts)]..komuts[math.random(#komuts)]
	local r,g,b = unpack(bonusRenkler[math.random(#bonusRenkler)])
	outputChatBox("#4dd2fa[-]#f0f0f0 Saatlik bonus kazandın! /paraonay <ONAY Kodu> yazarak bonusunu al.", r, g, b, true)
	outputChatBox("#e04646[-]#f0f0f0 Onay Kodun: #90a3b6[#ffffff"..komut.."#90a3b6]", r, g, b, true)
	triggerServerEvent("bonus:saatekle",localPlayer, localPlayer, 1)

    deneme2 = playSound(cek,false) 
	setSoundVolume(deneme2, 0.3)
	setTimer(odulGeriSayim, 1000*60,1)
	end
end

function odulGeriSayim()
	komut = nil
	odulAl = false
end

addCommandHandler("paraonay", function(_,yazilan)
	if komut then
		if yazilan and yazilan == komut then
			triggerServerEvent("BonusPara:ÖdülVer",localPlayer)
			komut = nil
			odulAl = false
		else
			outputChatBox ("#822828"..exports["titan_pool"]:getServerName()..": #ffffffEksik veya yanlış bir kod girdiniz.", 255, 0, 0, true)
		end
	end	
end)
