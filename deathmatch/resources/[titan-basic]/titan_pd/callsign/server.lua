
addCommandHandler("callsign",function(plr,cmd,...)
	if plr:getData("faction") == 1 or plr:getData("faction") == 23 then
		if not plr:getOccupiedVehicle() then
			outputChatBox("#822828"..exports["titan_pool"]:getServerName()..":#ffffff Bu komutu yalnızca aracın içerisinde kullanabilirsiniz.",plr,255,0,0,true)
		return end
			if not ... then 
			exports["titan_infobox"]:addBox(plr, "info", "Kullanım: /"..cmd.." [Birim Kodu]")
			plr:getOccupiedVehicle():setData("callsign", nil)
			return end
			local kod = table.concat({...}, " ")
			plr:getOccupiedVehicle():setData("callsign", kod)
	end
end)