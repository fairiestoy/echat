--[[
Rework of the Chatplus Mod.
eChat v00.01.75026

This mod aims at providing some more functionality
to the basic chat of minetest/freeminer.

NOTE:
Decided to move all options into world-related
config files instead of using global minetest.conf
or even some vars within this file. This way we
keep each world as configurable as possible.
]]

echat = {}

-- Freeminer / Minetest compatibility
if not freeminer then
	freeminer = minetest
end

-- configuration
echat.worldpath = freeminer.get_worldpath()..package.config:sub(1,1)
echat.configpath = echat.worldpath..'echat.conf'
echat.datapath = echat.worldpath..'echat_data'..package.config:sub(1,1)

-- Quick test to see if the datapath is already available
local test_file = io.open( echat.datapath..'startuptest', 'w' )
if not test_file then
	os.execute( 'mkdir '..echat.datapath )
	test_file = io.open( echat.datapath..'startuptest', 'w' )
	if not test_file then
		freeminer.log( 'error' , 'echat] Could not access datapath...' )
		return false
	end
	io.close( test_file )
	test_file = false
end

local modpath = freeminer.get_modpath( 'echat' )

dofile( modpath..'/config_lib.lua' )
if not echat.config_init( ) then
	freeminer.log( 'error', 'echat] Initiating config failed' )
	return false
end

dofile( modpath..'/log_manager.lua' )
if not echat.init_log( ) then
	freeminer.log( 'error', 'echat] Initiating Logging failed' )
	return false
end

dofile( modpath..'/player_data.lua' )
echat.player_init()



-- DEBUG PART
for key, value in pairs( echat.config ) do
	freeminer.log('error',  key..':'..value )
end
