appNames = {
	["history"] = "Geçmiş",
	["contacts"] = "Rehber",
	["settings"] = "Ayarlar",
	["appstore"] = "App Store",
	["emails"] = "E-posta",
	["safari"] = "Safari",
	["vergi"] = "Vergi",
	["flappy-bird"] = "F. Bird",
	["lsbank"] = "Banka",
	["spotify"] = "Spotify",
	["twitter"] = "Twitter",
}

guiApps = {}
local maxAppsPerRow = 3
local appsMaxRows = 4
local iconSize = 60
local iconSpacing = 15
local btnAlpha = 0

function drawAllPaneOfApps(xoffset, yoffset)
	drawApps = true
end

function togglePanesOfApps(state)
	drawApps = state
end

function convertString(_name)
	return appNames[_name]
end