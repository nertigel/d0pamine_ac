--[[
	d0pamine anti-cheat by Nertigel
]]

local resources = nil
local fileName = 'client_script \'@'..GetCurrentResourceName()..'/client.lua\''
RegisterCommand('d0pamine', function(source, args, rawCommand)
	if source == 0 then
		if args[1] == "install" then
			if args[2] then
				if not resources then resources = {0, 0, 0} end
				if args[2] == "all" then
					local resourcenum = GetNumResources()
					for i = 0, resourcenum-1 do
						if GetResourceByFindIndex(i) == GetCurrentResourceName() or 
							GetResourceByFindIndex(i) == 'mapmanager' then 
							i = i+1 
						end
						local path = GetResourcePath(GetResourceByFindIndex(i))
						if string.len(path) > 4 then
							setall(path)
						end
					end
					print("^4Done! ("..resources[1].."/"..resources[2].." successfully). "..resources[3].." skipped (not necessary).^7")
				else
					local setin = GetResourcePath(args[2])
					if setin then
						setall(setin)
						print("------------------------------------------------------------------")
						print("^4Done! ("..resources[1].."/"..resources[2].." successfully). "..resources[3].." skipped (not necessary).^7")
					else
						print("^1The resource "..args[2].." doesn't exist.^7")
					end
				end
				resources = nil
			else
				print('Unspecified arguement(s). (all | resource_name)')
			end
		elseif args[1] == "uninstall" then
			if args[2] then
				if not resources then resources = {0, 0, 0} end
				if args[2] == "all" then
					local resourcenum = GetNumResources()
					for i = 0, resourcenum-1 do
						local path = GetResourcePath(GetResourceByFindIndex(i))
						if string.len(path) > 4 then
							setall(path, true)
						end
					end
					print("^4Done! ("..resources[1].."/"..resources[2].." successfully). "..resources[3].." skipped (not necessary).^7")
				else

				end
				resources = nil
			else
				print('Unspecified arguement(s). (all | resource_name)')
			end
		else
			print('Unspecified arguement(s). (install | uninstall)')
		end
	end
end)

function setall(dir, bool)
	local file = io.open(dir.."/"..d0pamine.fsManifest, "r")
	local tab = split(dir, "/")
	local resname = tab[#tab]
	tab = nil
	if file then
		if not bool then
			file:seek("set", 0)
			local r = file:read("*a")
			file:close()
			local table1 = split(r, "\n")
			local found = false
			local found2 = false
			for a, b in ipairs(table1) do
				if b == fileName then
					found = true
				end
				if not found2 then
					local fi = string.find(b, "client_script") or -1
					local fin = string.find(b, "#") or -1
					if fi ~= -1 and (fin == -1 or fi < fin) then
						found2 = true
					end
				end
			end
			if found2 then
				r = r..'\n'..fileName
				if not found then
					os.remove(dir.."/"..d0pamine.fsManifest)
					file = io.open(dir.."/"..d0pamine.fsManifest, "w")
					if file then
						file:seek("set", 0)
						file:write(r)
						file:close()
					end
				end
				resources[1] = resources[1]+1
				print("^2Finished guarding "..resname.." resource successfully.^7")
				
				resources[2] = resources[2]+1
			else
				resources[3] = resources[3]+1
			end
		else
			file:seek("set", 0)
			local r = file:read("*a")
			file:close()
			local table1 = split(r, "\n")
			r = ""
			local found = false
			local found2 = false
			for a, b in ipairs(table1) do
				if b == fileName then
					found = true
				else
					r = r..b.."\n"
				end
			end
			if not found and not found2 then resources[3] = resources[3]+1 end
			if found then
				resources[2] = resources[2]+1
				os.remove(dir.."/"..d0pamine.fsManifest)
				file = io.open(dir.."/"..d0pamine.fsManifest, "w")
				if file then
					file:seek("set", 0)
					file:write(r)
					file:close()
				else
					print("^2Failed uninstalling anticheat from "..resname.." successfully.^7")
					found, found2 = false, false
				end
			end
			if found or found2 then
				print("^2Finished uninstalling anticheat from "..resname.." successfully.^7")
				resources[1] = resources[1]+1
			end
		end
	else
		resources[3] = resources[3]+1
	end
end

function searchall(dir, bool)
	local file = io.popen("dir \""..dir.."\" /b /ad")
	file:seek("set", 0)
	local r1 = file:read("*a")
	file:close()
	local table1 = split(r1, "\n")
	for a, b in ipairs(table1) do
		if string.len(b) > 0 then
			setall(dir.."/"..b, bool)
			searchall(dir.."/"..b, bool)
		end
	end
end

function split(str, seperator)
	local pos, arr = 0, {}
	for st, sp in function() return string.find(str, seperator, pos, true) end do
		table.insert(arr, string.sub(str, pos, st-1))
		pos = sp + 1
	end
	table.insert(arr, string.sub(str, pos))
	return arr
end