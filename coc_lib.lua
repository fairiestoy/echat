--[[
Chat mod control characters unit.
In this module, we will define some functions
to parse control characters and send them to
the appropriate routines with the fitting
parameters. Some of them are these:

@<user name> <message>  = Send a private message
				 to <user name>. @r would reply to latest
				 chat partner
#<message>     = Send message to global *IF* you are
                 in another channel. Otherwise ignore
				 the control character and push it to chat
!<message>	   = Send message to characters within
				 specified range
~<user name>   = Ignore given User
+<user name>   = Unignore given user
*<user name> <message> = Send Mail to <user name>

]]

local parsing_table = {}
parsing_table['@'] = echat.coc_msg_user
parsing_table['#'] = echat.coc_send_global
parsing_table['!'] = echat.coc_send_local

--[[
This replies will appear, when a user tries to use the #<message> short to write
in global, even though he is already there. Just something to play with, and might
go on the nerves of some players. Thats why it is configurable.
]]
local senseless_replies = {}

if echat.config['senseless_replies'] == true then
	table.insert( senseless_replies, 'Everytime you do this, while already in global, an innocent Kitten dies somewhere' )
	table.insert( senseless_replies, 'Guess what mate...          You *are* already in the global channel ... ' )
	table.insert( senseless_replies, 'You are making the Gods *grrr* when calling the global shortcut while in global' )
	table.insert( senseless_replies, 'The last guy who tried this command with beeing in global, got smashed by the Banhammer' )
	table.insert( senseless_replies, 'Should i call the guys with that white jackets for you?' )
	table.insert( senseless_replies, 'Why are you attempting to call global when already within the global?' )
	local function tmp( user, message )
		if echat.player_get_data( user, 'channel' ) == 'global' or echat.player_get_data( user, 'channel' ) == 'Global' then
			freeminer.chat_send_player( user, senseless_replies[math.random(1,#senseless_replies)] )
			return true
		end
		-- pass
		return false
	end
	echat.coc_send_global = tmp
else
	-- pass
end

function echat.coc_parse_message( user, message )
	local status = false
	if parsing_table[message:sub(1,1)] then
		status = parsing_table[message:sub(1,1)](user, message)
	end
	return status
end

function echat.coc_msg_user( user, message )
	if message:sub(1,2) == '@r' and echat.player_get_data( user, 'reply' ) then
		freeminer.chat_send_player( echat.player_get_data( user, 'reply' ) message:sub( 3 ) )
		return true
	end
	return false
end

function echat.coc_send_local( user, message )
	-- pass
end
