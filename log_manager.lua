--[[
Logging Module

Configuration options: 'log_buffer', 'time_format'
Default: 20, '%H:%M'

]]

local buffer = {}
local counter = 0
local data_path = 0
local log_title = 'Minetest/Freeminer Server'

function echat.log_message( user, message )
	local log_string = ''
	local time_string = os.date( echat.config['time_format'] )
	log_string = log_string..time_string..';'..user..';'..message..'\n'
	if counter == tonumber( echat.config['log_buffer'] ) - 1 then
		local tmp_file = io.open( echat.datapath..tostring( os.time() )..'_log', 'a' )
		if not tmp_file then
			freeminer.log( 'error', 'echat] Could not open file for logging chat...' )
			buffer = {}
			counter = 0
			return nil
		end
		for key, value in pairs( buffer ) do
			tmp_file:write( value )
		end
		tmp_file:write( log_string )
		io.close( tmp_file )
		buffer = {}
		counter = {}
		return nil
	end
	table.insert( buffer, log_string )
end

function echat.log_sysmessage( modul, message )
	local tmp_file = io.open( echat.datapath..'log_sysmsg', 'a' )
	if not tmp_file then
		return nil
	end
	local log_string = tostring( os.time( ) )..';'..modul..';'..message..'\n'
	tmp_file:write( log_string )
	io.close( tmp_file )
end

function echat.init_log( )
	data_path = echat.datapath..tostring( os.time() )..'_log'
	tmp_file = io.open( data_path, 'w' )
	if not tmp_file then
		freeminer.log( 'error', 'echat] Unable to initialize Log Manager' )
		return false
	end
	tmp_file:write( '==== Log from '..log_title..'\n' )
	io.close( tmp_file )
	echat.log_sysmessage( 'log_manager', 'Initialized Log manager.' )
	return true
end
