--[[
eChat Configuration Module
Here we will take care of parsing the conf file
and fill them into the eChat table for further use.

]]

echat.config = {}

local default_config = {
	log_chat = true,
	allow_channels = false,
	password_channels = false,		-- WIP
	persistent_channels = false,	-- WIP
	allow_filter = true,
	allow_modrank = true,			-- WIP
	mod_can_kick = true,
	mod_can_mute = true,
	time_format = '%H:%M',
	range_chat_active = false,
	range_chat_range = 50,
	city_chat_active = false,		-- WIP
	player_timeout = 60,
	senseless_replies = true,
	allow_mails = true,
	log_buffer = 20,
	}

local function read_and_parse( fpath )
	-- instead of using the builtin Settings() interface, we
	-- build something new. Just .. because
	-- Maybe replace it with the real interface later on
	local tmp_file = io.open( fpath, 'r' )
	if not tmp_file then
		return nil
	end
	local data = tmp_file:read( '*all' )
	io.close( tmp_file )
	if not data or data == '' then
		return false
	end
	-- Parsing part
	local sdata = 0
	local sindex = 1
	local eindex = 1
	local seindex = 1
	local tmp_table = {}
	local running = true
	while running do
		eindex = string.find( data:sub(sindex), '\n' )
		if eindex then
			eindex = eindex + sindex
			sdata = data:sub( sindex, eindex - 1 )
			seindex = string.find( sdata, '=' )
			if seindex and seindex ~= 0 then
				local key = sdata:sub( 1, seindex - 1 )
				local value = sdata:sub( seindex + 1, eindex )
				if key:sub(1,1) == ' 'then
					key = key:sub( 2 )
				elseif key:sub( #key - 1 ) then
					key = key:sub( 1, #key - 1 )
				end
				if value:sub(1,1) == ' 'then
					key = key:sub( 2 )
				elseif key:sub( #key - 1 ) then
					key = key:sub( 1, #key - 1 )
				end
				tmp_table[sdata:sub( 1, seindex-1 )] = sdata:sub( seindex +1, eindex - 1 )
			end
			sindex = eindex
		else
			running = false
		end
	end
	return tmp_table
end

local function parse_and_save( fpath, value_table )
	local tmp_file = io.open( fpath, 'w' )
	if not tmp_file then
		return nil
	end
	if not value_table then
		return nil
	end
	for key, value in pairs( value_table ) do
		if value == true then
			value = 'true'
		elseif value == false then
			value = 'false'
		end
		local write_str = key..'='..value..'\n'
		tmp_file:write( write_str )
	end
	io.close( tmp_file )
	return true
end

function echat.config_init( )
	if not echat.config then
		echat.config = {}
	end
	local status = 0
	status = read_and_parse( echat.configpath )
	if type( status ) == type( {} ) then
		-- we have our data, point to it and leave
		echat.config = status
		for key, value in pairs( default_config ) do
			if not echat.config[key] then
				echat.config[key] = value
			end
		end
		parse_and_save( echat.configpath, echat.config )
		return true
	end
	-- In any case, we should build up a new file here
	status = parse_and_save( echat.configpath , default_config )
	echat.config = default_config
	return status
end
