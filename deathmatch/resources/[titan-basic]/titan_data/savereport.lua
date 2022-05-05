mysql = exports.titan_mysql
reports = { }

function saveReports(reports1)
	if reports1 and type(reports1) == "table" then
		reports = reports1
		return true
	else
		return false
	end
end

function loadReports()
	if reports and type(reports) == "table" then
		return reports
	else
		return false
	end
end
