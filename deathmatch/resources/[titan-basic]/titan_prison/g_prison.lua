--[[
All stored here for ease of use.

New jail system by: Hanz for "..exports["titan_pool"]:getServerName().."Roleplay
]]

pd_offline_jail = false -- PD Offline Jailing enabled or disabled. Reminder: Always enabled for admins.

pd_update_access = 59 -- Allows this faction ID to update/remove offline prisoners

hourLimit = 0 -- 0 is infinite, otherwise this is the max they can jail in hours

gateDim = 45
gateInt = 0
objectID = 2930

speakerDimensions = { [812] = true, [851] = true, [857] = true, [861] = true, [862] = true, [880] = true, [881] = true, [882] = true }
speakerInt = 0
speakerOutX, speakerOutY, speakerOutZ = -1046.16015625, -723.65625, 32.0078125

-- Skins, ID = clothing:id
-- Male Skins 
bMale = 50
bMaleID = 1109
wMale = 50
wMaleID = 1110
aMale = 50
aMaleID = 1110

-- Female Skins
bFemale = 69
bFemaleID = 1111
wFemale = 69
wFemaleID = 1112
aFemale = 69
aFemaleID = 1112


cells = {

["1A"] = { 1572.0986328125, -1663.05078125, 12.1796875, 0, 45 },
["2A"] = { 1582.26953125, -1663.02734375, 12.1796875, 0, 45 },
["3A"] = { 1571.4375, -1659.3037109375, 12.1796875, 0, 45 },
["4A"] = { 1582.6064453125, -1659.0673828125, 12.181518554688, 0, 45 },
}

cells2 = { }

--[[for k, v in pairs( cells ) do
  local sphere = createColSphere(v[1], v[2], v[3], 90)
  setElementDimension(sphere, v[5])
  setElementInterior(sphere, v[4])
  table.insert(cells2, sphere)
end]]

local sphere = createColSphere(1572.0986328125, -1663.05078125, 12.1796875, 12)
setElementDimension(sphere, 45)
setElementInterior(sphere, 0)

function isCloseTo( thePlayer, targetPlayer )
  if exports.titan_integration:isPlayerTrialAdmin(thePlayer) then
    return true
  end

  local theTeam = getPlayerTeam(thePlayer)
  local factionId = tonumber(getElementData(theTeam, "id"))
  if factionId == pd_update_access then
    return true
  end

  if targetPlayer then
    local dx, dy, dz = getElementPosition(thePlayer)
    local dx1, dy1, dz1 = getElementPosition(targetPlayer)
    if getDistanceBetweenPoints3D(dx, dy, dz, dx1, dy1, dz1) < ( 30 ) then
      if getElementDimension(thePlayer) == getElementDimension(targetPlayer) then
        return true
      end
    end
  end
    return false
end

function isInArrestColshape( thePlayer )
    if isElementWithinColShape( thePlayer, sphere ) and (getElementDimension( thePlayer ) == 45) then -- Don't forget to change this
      return true
  end
  return false
end

function cleanMath(number)
    if type(number) == "boolean" then
        return
    end
    local currenttime = getRealTime()
    local currentTime = currenttime.timestamp
    local remainingtime = tonumber(number) - currentTime
    local hours = (remainingtime /3600)
    local days = math.floor(hours/24)
    local remaininghours = hours - days*24
    local hours = ("%.1f"):format(hours - days*24)

    if remainingtime<0 then
        return "Awaiting", "Release", tonumber(remainingtime)
    end

    if days>999 then
      return "Life", "Sentence", tonumber(remainingtime)
    end
     
    return days, hours, tonumber(remainingtime)
end

-- Released
x, y, z = 2120.890625, -2286.6826171875, 13.494735717773 -- Anumaz edit this for when they get released
dim = 0
int = 0

gates = {
  -- ["cell"] = { openx, openy, openz, openRx, openRy, openRz, closedx, closedy, closedz, closedRx, closedRy, closedRz }
["1A"] = { 1047.1, 1253.2, 1493, 0, 0, 0, 1047.1, 1254.9, 1493, 0, 0, 0 },
["2A"] = { 1047.1, 1244.7, 1493, 0, 0, 0, 1047.1, 1246.4, 1493, 0, 0, 0 },
["3A"] = { 1047.1, 1239.7, 1493, 0, 0, 0, 1047.1, 1241.4, 1493, 0, 0, 0 },
["4A"] = { 1047.1, 1234.7, 1493, 0, 0, 0, 1047.1, 1236.4, 1493, 0, 0, 0 },
}

--[[
----- SQL STRUCTURE -----

-- Host: 127.0.0.1
-- Generation Time: Aug 25, 2014 at 12:46 AM
-- Server version: 5.6.16
-- PHP Version: 5.5.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

-- --------------------------------------------------------

--
-- Table structure for table `jailed`
--

CREATE TABLE IF NOT EXISTS `jailed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `charid` int(11) NOT NULL,
  `charactername` text NOT NULL,
  `jail_time` bigint(12) NOT NULL,
  `convictionDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedBy` text NOT NULL,
  `charges` text NOT NULL,
  `cell` text NOT NULL,
  `fine` int(5) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=0 ;
]]