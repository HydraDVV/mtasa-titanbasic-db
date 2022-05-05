local modsTable = {}
local index = 1314
modsTable[index] = {
	txd = "mods/icons.txd",
	dff = "mods/disabledicon.dff",
}

local index = 14776
modsTable[index] = {
	col = "mods/fixes/interior24.col",
}

local index = 3916
modsTable[index] = {
	txd = "items/armour.txd",
	dff = "items/armour.dff",
}

local index = 3027
modsTable[index] = {
	txd = "items/Ciggy1.txd",
	dff = "items/Ciggy1.dff",
}

local index = 2012
modsTable[index] = {
	dff = "items/exhale.dff",
}

local index = 494
modsTable[index] = {
	txd = "mods/hsu.txd",
	dff = "mods/hsu.dff",
}

local index = 417
modsTable[index] = {
	txd = "mods/levi.txd",
	dff = "mods/levi.dff",
}

local index = 470
modsTable[index] = {
	txd = "mods/vehicles/patriot.txd",
	dff = "mods/vehicles/patriot.dff",
}

local index = 578
modsTable[index] = {
	txd = "mods/vehicles/dft30.txd",
	dff = "mods/vehicles/dft30.dff",
}

local index = 538
modsTable[index] = {
	txd = "mods/vehicles/streak.txd",
	dff = "mods/vehicles/streak.dff",
}

local index = 570
modsTable[index] = {
	txd = "mods/vehicles/streakc.txd",
	dff = "mods/vehicles/streakc.dff",
}

local index = 611
modsTable[index] = {
	txd = "mods/vehicles/trailer.txd",
	dff = "mods/vehicles/trailer.dff",
}

local index = 582
modsTable[index] = {
	txd = "mods/vehicles/newsvan.txd",
}

local index = 488
modsTable[index] = {
	txd = "mods/vehicles/vcnmav.txd",
}

local index = 2287
modsTable[index] = {
	col = "mods/cols/frame_4.col",
}

local index = 330
modsTable[index] = {
	txd = "mods/items/cellphone.txd",
	dff = "mods/items/cellphone.dff",
}

local index = 2880
modsTable[index] = {
	txd = "items/cola.txd",
	dff = "items/cola.dff",
}

local index = 1313
modsTable[index] = {
	txd = "mods/Wrench1.txd",
	dff = "mods/Wrench1.dff",
}
--[[
local index = 283
modsTable[index] = {
	txd = "skins/283.txd",
	dff = "skins/283.dff",
}

local index = 266
modsTable[index] = {
	txd = "skins/266.txd",
	dff = "skins/266.dff",
}

local index = 27
modsTable[index] = {
	txd = "skins/27.txd",
	dff = "skins/27.dff",
}

local index = 37
modsTable[index] = {
	txd = "skins/37.txd",
	dff = "skins/37.dff",
}

local index = 127
modsTable[index] = {
	txd = "skins/127.txd",
	dff = "skins/127.dff",
}
]]--
local index = 416
modsTable[index] = {
	txd = "mods/vehicles/ambulance.txd",
	dff = "mods/vehicles/ambulance.dff",
}

--create temp skin table
local skins = {1,2,7,14,15,16,23,29,30,34,40,41,45,47,48,54,55,56,60,63,64,66,67,75,90,91,92,93,96,101,102,104,108,111,114,122,123,124,125,128,132,133,134,135,136,138,141,151,152,153,156,165,172,174,175,176,179,188,191,193,202,204,206,211,218,223,228,234,236,237,238,239,240,245,247,250,256,257,258,259,263,267,292,294,295,299,303,311,312}

--for index, value in ipairs(skins) do
--	modsTable[value] = {
--		txd = "skins/"..value..".txd",
--		dff = "skins/"..value..".dff",
--	}
--end

function getModdedSkins()
	return skins or {}
end

function loadMods()
	for index, value in pairs(modsTable) do
	--thread:foreach(modsTable, function(value)
		if value.txd and fileExists(value.txd) then
			txd = engineLoadTXD(value.txd)
			engineImportTXD(txd, index)
		end
		if value.dff and fileExists(value.dff) then
			dff = engineLoadDFF(value.dff)
			engineReplaceModel(dff, index)
		end
		if value.col and fileExists(value.col) then
			col = engineLoadCOL(value.col)
			engineReplaceCOL(col, index)
		end
	end
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		loadMods()
	end
)