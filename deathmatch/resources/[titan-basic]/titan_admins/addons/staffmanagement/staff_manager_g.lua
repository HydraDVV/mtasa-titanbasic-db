-- Hanz / 2015.1.8

function canPlayerAccessStaffManager(player)
	return exports.titan_integration:isPlayerTrialAdmin(player) or exports.titan_integration:isPlayerSupporter(player) or exports.titan_integration:isPlayerVCTMember(player) or exports.titan_integration:isPlayerLeadScripter(player) or exports.titan_integration:isPlayerMappingTeamLeader(player)
end
	