-- Hanz
mysql = exports.titan_mysql
TESTER = 25
SCRIPTER = 32
LEADSCRIPTER = 79
COMMUNITYLEADER = 14
TRIALADMIN = 18
ADMIN = 17
SENIORADMIN = 64
LEADADMIN = 15
SUPPORTER = 30
VEHICLE_CONSULTATION_TEAM_LEADER = 39
VEHICLE_CONSULTATION_TEAM_MEMBER = 43
MAPPING_TEAM_LEADER = 44
MAPPING_TEAM_MEMBER = 28
STAFF_MEMBER = {32, 14, 18, 17, 64, 15, 30, 39, 43, 44, 28}
AUXILIARY_GROUPS = {32, 39, 43, 44, 28}
ADMIN_GROUPS = {14, 18, 17, 64, 15}

staffTitles = {
	[1] = {
		[0] = "Oyuncu",
		[1] = "Trial Admin",
		[2] = "Admin I",
		[3] = "Admin II",
		[4] = "Admin III",
		[5] = "Leader Admin",
		[6] = "Senior Admin",
		[7] = "Head Admin",
		[8] = "Developer",
	}, 
	[2] = {
		[0] = "Oyuncu",
		[1] = "Trial Helper",
		[2] = "Helper I",
		[3] = "Helper II",
		[4] = "Leader Helper",
	}, 
	[3] = {
		[0] = "Oyuncu",
		[1] = "VCT",
		[2] = "Leader VCT",
	}, 
	[4] = {
		[0] = "Oyuncu",
		[1] = "Trial Scripter",
		[2] = "Scripter",
		[3] = "Leader Scripter",
	}, 
	[5] = {
		[0] = "Oyuncu",
		[1] = "Mapper",
		[2] = "Leader Mapper",
	}, 
}

function getStaffTitle(teamID, rankID) 
	return staffTitles[tonumber(teamID)][tonumber(rankID)]
end

function getStaffTitles()
	return staffTitles
end