--[[
Channel Module.
The configuration 'allow_channels' is only
meant for adding more then the already
registered channels 'global' and 'local'
since those are used for internal functionality
like global muting and local saying.

NOTE:
Changed 'local' to be not a channel. Instead
its a hardcoded way of telling everybody
(except those who ignore you ) in a specific
distance what you want them to tell.

]]

local channels = {}
channels['global'] = {}

function echat.send_global( user, message )
	for key, value in pairs( channels['global'] ) do
		-- value should be the username
		if user ~= value then
			if not echat.player_get_data( value, 'ignore' )[user] then
				freeminer.chat_send_player( value, message )
			end
		end
	end
end

function echat.send_local( user, message )
	local distance = tonumber( echat.config['range_chat_range'] )
	if not distance then
		echat.send_global( user, message )
		return nil
	elseif distance == 0 then
		return nil
	end
	-- Collect all players in range and send the message
	local user_ref = freeminer.get_user_by_name( user )
	local player_list = freeminer.get_objects_inside_radius( user_ref:getpos() , distance )
	for key, value in pairs( player_list ) do
		if value:is_player() and value:get_player_name() ~= user then
			freeminer.chat_send_player( value:get_player_name(), message )
		end
	end
end

local function player_within_distance( p1, p2, dist )
	-- Math based routine seemed for some reason slower than this, so we stick with it
	if( ( p2.x < (p1.x + dist) ) and ( p2.x > ( p1.x - dist ) ) ) then
		if( ( p2.y < (p1.y + dist) ) and ( p2.y > ( p1.y - dist ) ) ) then
			if( ( p2.z < (p1.z + dist) ) and ( p2.z > ( p1.z - dist ) ) ) then
				return true
			end
		end
	end
	return false
end
