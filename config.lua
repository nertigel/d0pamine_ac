--[[
	d0pamine anti-cheat by Nertigel
]]

math.randomseed(os.time())

function randomString(length)
    local res = ''
    for i = 1, length do
        res = res .. string.char(math.random(97, 122))
    end
    return res
end

print('d0pamine ac: initialized')

d0pamine = {}
d0pamine.fsManifest = 'fxmanifest.lua' --[[fxmanifest.lua or __resource.lua]]

d0pamine.replaceWords = {
	--[[events]]
	{_from = 'd0pamine:ban', _to = randomString(15)},
	--[[locals]]
	{_from = 'triggerServerEvent', _to = randomString(10)},
	{_from = 'currentResourceName', _to = randomString(11)},
	{_from = 'oldLoad', _to = randomString(11)},
	{_from = 'oldLoadResourceFile', _to = randomString(13)},
	{_from = '_resourceName', _to = randomString(14)},
	{_from = '_fileName', _to = randomString(15)},
	{_from = 'oldPrint', _to = randomString(16)},
	{_from = 'oldTrace', _to = randomString(17)},
	--[[new lines into spaces]]
	--{_from = '\n', _to = '    '},
}

d0pamine.clientCode = [[
print('d0pamine ac loaded')
local triggerServerEvent = (TriggerServerEvent)
local currentResourceName = (GetCurrentResourceName())
local oldLoad = load

Citizen.CreateThread(function()
	while (true) do 
		Citizen.Wait(30000)
		if (_G == nil or _G == {} or _G == '') then
			triggerServerEvent('d0pamine:ban', 1, currentResourceName)
		end
		Citizen.Wait(2500)
		if (load ~= oldLoad or load == nil or oldLoad == nil) then
			triggerServerEvent('d0pamine:ban', 6, currentResourceName)
		end
	end
end)

AddExplosion = function(...)
	triggerServerEvent('d0pamine:ban', 2, currentResourceName)
end

local oldLoadResourceFile = LoadResourceFile
LoadResourceFile = function(_resourceName, _fileName)
	if (_resourceName ~= currentResourceName) then
		triggerServerEvent('d0pamine:ban', 3, currentResourceName)
	else
		oldLoadResourceFile(_resourceName, _fileName)
	end
end

local oldPrint = print
print = function(...)
	for k,v in ipairs({...}) do
		if (v:find(GetCurrentServerEndpoint())) then
			triggerServerEvent('d0pamine:ban', 4, currentResourceName)
		else
			oldPrint(v)
		end
	end
end

local oldTrace = Citizen.Trace
Citizen.Trace = function(...)
	for k,v in ipairs({...}) do
		if (v:find(' menu property changed: { ')) then
			triggerServerEvent('d0pamine:ban', 5, currentResourceName)
		else
			oldTrace(v)
		end
	end
end
]]

print('d0pamine ac: client code initialized')

d0pamine.serverCode = [[
RegisterNetEvent('d0pamine:ban')
AddEventHandler('d0pamine:ban', function(receivedReason, resource)
	local _source = source
	local actualReason = ('')
	if (receivedReason == 1) then
		actualReason = ('setting global var to nil')
	elseif (receivedReason == 2) then
		actualReason = ('triggering AddExplosion native')
	elseif (receivedReason == 3) then
		actualReason = ('triggering LoadResourceFile native')
	elseif (receivedReason == 4) then
		actualReason = ('triggering GetCurrentServerEndpoint native')
	elseif (receivedReason == 5) then
		actualReason = ('attempt to debug with WarMenu')
	elseif (receivedReason == 6) then
		actualReason = ('manipulation load() function')
	else
		actualReason = ('unknown reason')
	end

	if (not resource or resource == '' or resource == nil) then 
		resource = ('unknown' )
	end
	
	banUser(_source)
	DropPlayer(_source, 'd0pamine ac \nYou have been kicked for cheating. \nReason: '..actualReason..'. \nResource: '..resource)
end)
]]

print('d0pamine ac: server code initialized')

for i = 1, #d0pamine.replaceWords do
    d0pamine.clientCode = d0pamine.clientCode:gsub(d0pamine.replaceWords[i]._from, d0pamine.replaceWords[i]._to)
    d0pamine.serverCode = d0pamine.serverCode:gsub(d0pamine.replaceWords[i]._from, d0pamine.replaceWords[i]._to)
end

print('d0pamine ac: code replaced')