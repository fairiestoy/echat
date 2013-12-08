--[[
Player data related stuff goes here. That
includes mails, settings and such things.

Decided to make the player table local, so
other mods can access this data only over
the interface. Otherwise it could mess up
things.

Something new is also the time related cleanup
of old player data. If a player is not
present for a specific time, his data will
be deleted even though he might have some
messages. The amount is configurable.

See the 'player_timeout' setting in the
config lib. The value is a day based
amount. Default is 60 days.

<player_list>
	<player 1>
		<mails>
		<settings>
		(?) <friends>
	<player 2>
		[..]
</player_list>

]]

local player_list = {}

function echat.player_add( name )
	-- We are doing no check here for now. Could be
	-- used for mailbots etc
	if not player_list[name] then
		player_list[name] = {}
		player_list[name]['last_login'] = os.time( )
		return true
	end
	return false
end

function echat.player_remove( name )
	if player_list[name] then
		player_list[name] = nil
		return true
	end
	return false
end

function echat.player_set_data( name, key, value )
	if not player_list[name] then
		return false
	end
	player_list[name][key] = value
	return true
end

function echat.player_get_data( name, key )
	if name and key and value then
		if player_list[name] and player_list[name][key] then
			return player_list[name][key]
		end
	end
	return nil
end

function echat.player_update_login( name )
	if player_list[name] then
		player_list[name]['last_login'] = os.time()
	end
end

function echat.player_save_data()
	local tmp_file = io.open( echat.datapath..'player_file', 'w' )
	if not tmp_file then
		return false
	end
	tmp_file:write( freeminer.serialize( player_list ) )
	io.close( tmp_file )
	return true
end

function echat.player_load_data( )
	local tmp_file = io.open( echat.datapath..'player_file', 'r' )
	local tmp_data = freeminer.deserialize( tmp_file:read( '*all' ) )
	io.close( tmp_file )
	if type( tmp_data ) == type( {} ) then
		player_list = tmp_data
		return true
	end
	return false
end
