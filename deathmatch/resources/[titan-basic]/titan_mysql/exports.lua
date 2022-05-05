local hostname = "localhost"
local username ="root"
local password = ""
local database = "titandevelopment"
local port =  3306

local MySQLConnection = nil
local queryPool = {}
--@tablo mantığı:

local serverDatabase

local db = {}


addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		serverDatabase = dbConnect("mysql", "dbname=titandevelopment;host=localhost;charset=utf8", "root", "", "multi_statements=1")
		
		if not serverDatabase then
			outputDebugString("[MySQL]: Bağlantı kurulamadı!", 1)
			cancelEvent()
		else
			--dbExec(serverDatabase, "SET NAMES utf8")
			outputDebugString("[MySQL]: Bağlantı kuruldu.")
		end
	end
)

function connectionGet()
	return serverDatabase, db
end


local sqllog = false
local countqueries = 0


function getMySQLUsername()
	return username
end

function getMySQLPassword()
	return password
end

function getMySQLDBName()
	return db
end

function getMySQLHost()
	return host
end

function getMySQLPort()
	return port
end

function connectToDatabase(res)
	MySQLConnection = mysql_connect("localhost", "root", "", "titandevelopment", "3306")
	conn = dbConnect( "mysql", "dbname="..database..";host="..hostname..";port=3306;charset=latin1", username, password, "autoreconnect=1" )
	mysql_set_character_set(MySQLConnection, "latin1")
	if (not MySQLConnection) then
		if (res == getThisResource()) then
			outputDebugString("Cannot connect to the MTA database.")
			cancelEvent(true, "Cannot connect to the database.")
		end
		return nil
	else
		outputDebugString("MySQL connection succesfuly.")
	end
	if not conn then outputDebugString("Yeni MySQL ağına bağlanılamadı.") end
	
	return nil
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), connectToDatabase, false)
	
function getConnection()
	return conn
end

function getDBConnection()
	return conn
end

-- destroyDatabaseConnection - Internal function, kill the connection if theres one.
function destroyDatabaseConnection()
	if (not MySQLConnection) then
		return nil
	end
	mysql_close(MySQLConnection)
	return nil
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), destroyDatabaseConnection, false)

-- do something usefull here
function logSQLError(str)
	local message = str or 'N/A'
	outputDebugString("MYSQL ERROR "..mysql_errno(MySQLConnection) .. ": " .. mysql_error(MySQLConnection))
	exports['arp_logs']:logMessage("MYSQL ERROR [QUERY] " .. message .. " [ERROR] " .. mysql_errno(MySQLConnection) .. ": " .. mysql_error(MySQLConnection), 24)
end

function getFreeResultPoolID()
	local size = #queryPool
	return size + 1
end

------------ EXPORTED FUNCTIONS ---------------

function ping()
	if (mysql_ping(MySQLConnection) == false) then
		destroyDatabaseConnection()
		connectToDatabase(nil)
		if (mysql_ping(MySQLConnection) == false) then
			logSQLError()
			return false
		end
		return true
	end

	return true
end

function escape_string(str)
	if (ping()) then
		return mysql_escape_string(MySQLConnection, str)
	end
	return false
end

function query(str)
	if sqllog then
		exports['arp_logs']:logMessage(str, 24)
	end
	countqueries = countqueries + 1
	
	if (ping()) then
		local result = mysql_query(MySQLConnection, str)
		if (not result) then
			logSQLError(str)
			return false
		end

		local resultid = getFreeResultPoolID()
		--queryPool[resultid][2] = result
		queryPool[resultid] = {str, result}
		return resultid
	end
	return false
end

function unbuffered_query(str)
	if sqllog then
		exports['arp_logs']:logMessage(str, 24)
	end
	countqueries = countqueries + 1
	
	if (ping()) then
		local result = mysql_unbuffered_query(MySQLConnection, str)
		if (not result) then
			logSQLError(str)
			return false
		end

		local resultid = getFreeResultPoolID()
		--queryPool[resultid][2] = result
		queryPool[resultid] = {str, result}
		return resultid
	end
	return false
end

function query_free(str)
	--return dbExec(getConnection(), str)
	local queryresult = query(str)
	if  not (queryresult == false) then
		free_result(queryresult)
		return true
	end
	return false
end

function rows_assoc(resultid)
	if (not queryPool[resultid][2]) then
		return false
	end
	return mysql_rows_assoc(queryPool[resultid][2])
end

function fetch_assoc(resultid)
	if not queryPool[resultid] then return false end
	if queryPool[resultid] and (not queryPool[resultid][2]) then
		return false
	end
	return mysql_fetch_assoc(queryPool[resultid][2])
end

function free_result(resultid)
	return true
end

-- incase a nub wants to use it, FINE
function result(resultid, row_offset, field_offset)
	if (not queryPool[resultid][2]) then
		return false
	end
	return mysql_result(queryPool[resultid][2], row_offset, field_offset)
end

function num_rows(resultid)
	if (not queryPool[resultid] and not queryPool[resultid][2]) then
		return false
	end
	return mysql_num_rows(queryPool[resultid][2])
end

function insert_id()
	return mysql_insert_id(MySQLConnection) or false
end

function query_fetch_assoc(str)
	local queryresult = query(str)
	if  not (queryresult == false) then
		local result = fetch_assoc(queryresult)
		free_result(queryresult)
		return result
	end
	return false
end

function query_rows_assoc(str)
	local queryresult = query(str)
	if  not (queryresult == false) then
		local result = rows_assoc(queryresult)
		free_result(queryresult)
		return result
	end
	return false
end

function query_insert_free(str)
	local queryresult = query(str)
	if  not (queryresult == false) then
		local result = insert_id()
		free_result(queryresult)
		return result
	end
	return false
end

function escape_string(str)
	if not (str) then return false end
	return mysql_escape_string(MySQLConnection, str)
end

function debugMode()
	if (sqllog) then
		sqllog = false
	else
		sqllog = true
	end
	return sqllog
end

function returnQueryStats()
	return countqueries
	-- maybe later more
end

function getOpenQueryStr( resultid )
	if (not queryPool[resultid][1]) then
		return false
	end
	
	return queryPool[resultid][1]
end

function clearTables()
	local count = 0
	for i, v in ipairs(queryPool) do
		count = count + 1
		if count ~= #queryPool then
			table.remove(queryPool, i)
		end
	end
end
setTimer(clearTables, 1000*60*5, 0)

addCommandHandler( 'mysqlleaky',
	function(thePlayer)
		if exports.arp_integration:isPlayerDeveloper(thePlayer) then
			outputDebugString("queryPool="..tostring(#queryPool))
			outputChatBox("#queryPool="..tostring(#queryPool), thePlayer)
		end
	end
)

addCommandHandler("clearlag",
	function(thePlayer)
		if exports.arp_integration:isPlayerDeveloper(thePlayer) then
			queryPool = {}
			outputChatBox("OK")
			outputDebugString("queryPool="..tostring(#queryPool))
		end
	end
)

local function createWhereClause( array, required )
	if not array then
		-- will cause an error if it's required and we wanna concat it.
		return not required and '' or nil
	end
	local strings = { }
	for i, k in pairs( array ) do
		table.insert( strings, "`" .. i .. "` = '" .. ( tonumber( k ) or escape_string( k ) ) .. "'" )
	end
	return ' WHERE ' .. table.concat(strings, ' AND ')
end

function select( tableName, clause )
	local array = {}
	local result = query( "SELECT * FROM " .. tableName .. createWhereClause( clause ) )
	if result then
		while true do
			local a = fetch_assoc( result )
			if not a then break end
			table.insert(array, a)
		end
		free_result( result )
		return array
	end
	return false
end

function select_one( tableName, clause )
	local a
	local result = query( "SELECT * FROM " .. tableName .. createWhereClause( clause ) .. ' LIMIT 1' )
	if result then
		a = fetch_assoc( result )
		free_result( result )
		return a
	end
	return false
end

function insert( tableName, array )
	local keyNames = { }
	local values = { }
	for i, k in pairs( array ) do
		table.insert( keyNames, i )
		table.insert( values, tonumber( k ) or escape_string( k ) )
	end
	
	local q = "INSERT INTO `"..tableName.."` (`" .. table.concat( keyNames, "`, `" ) .. "`) VALUES ('" .. table.concat( values, "', '" ) .. "')"
	
	return query_insert_free( q )
end

function update( tableName, array, clause )
	local strings = { }
	for i, k in pairs( array ) do
		table.insert( strings, "`" .. i .. "` = " .. ( k == mysql_null() and "NULL" or ( "'" .. ( tonumber( k ) or escape_string( k ) ) .. "'" ) ) )
	end
	local q = "UPDATE `" .. tableName .. "` SET " .. table.concat( strings, ", " ) .. createWhereClause( clause, true )
	
	return query_free( q )
end

function delete( tableName, clause )
	return query_free( "DELETE FROM " .. tableName .. createWhereClause( clause, true ) )
end