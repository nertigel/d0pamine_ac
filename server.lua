--[[
	d0pamine anti-cheat by Nertigel
]]

load(d0pamine.serverCode)()
print('d0pamine ac: server code has been loaded')

createClientCode = function()
	local path = GetResourcePath(GetCurrentResourceName())
	local file = io.open(path..'/client.lua', 'w+')
	if file then
		file:seek('set', 0)
		file:write(d0pamine.clientCode)
		file:close()
	end

	print('d0pamine ac: client.lua has been created')
end
createClientCode()

local bansList = ''
AddEventHandler('onServerResourceStart', function(resource_name)
	if resource_name == GetCurrentResourceName() then
		local path = GetResourcePath(resource_name)
		local file = io.open(path..'/bans.txt', 'r')
		if file then
			file:seek('set', 0)
			bansList = file:read('*a')
			file:close()
		else
			print('Couldn\'t find bans.txt in: '..path..' | '..GetCurrentResourceName())
		end

		while true do
			file = io.open(path..'/bans.txt', 'w')
			if file then
				file:seek('set', 0)
				file:write(bansList)
				file:close()
			else
				print('Couldnt write in: '..path..'/bans.txt')
			end
			Wait(15000)
		end
	end
end)

AddEventHandler('playerConnecting', function(name, shouldDrop, deferrals)
	local num = GetNumPlayerIdentifiers(source)
	local _i = 0
	while _i < num-1 do
		local identifier = GetPlayerIdentifier(source, _i)
		if string.find(bansList, identifier) then 
			banUser(source)
			shouldDrop('d0pamine ac \nYou have been banned from this server for cheating.')
			CancelEvent()
		end
		_i = _i + 1
	end
end)

AddEventHandler('playerDropped', function(reason)
	local disallowedReasons = {
		'gta-streaming-five.dll+4AE92',
		'citizen-scripting-lua.dll+3FA40B',
		'citizen-scripting-lua.dll+3FB324',
		'kernelbase.dll+3A799',
		'ntdll.dll+1E312',
		'ntdll.dll+FBF18',
	}
	for _i=1, #disallowedReasons do
		if string.find(reason, disallowedReasons[_i]) then
			print('Player '..GetPlayerName(source)..' has been banned for cheat crash.')
			banUser(source)
		end
	end
	print('Player ' .. GetPlayerName(source) .. ' dropped (Reason: ' .. reason .. ')')
end)

banUser = function(player)
	local num = GetNumPlayerIdentifiers(player)
	for _i = 0, num-1 do
		local identifier = GetPlayerIdentifier(player, _i)
		if not string.find(bansList, identifier) then
			bansList = bansList..identifier..'\n'
		end
	end
end