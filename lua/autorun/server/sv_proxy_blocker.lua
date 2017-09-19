local string_format, http_Fetch, player_GetHumans, string_find, string_lower = string.format, http.Fetch, player.GetHumans, string.find, string.lower
local ipairs, type, IsValid, util_SteamIDFrom64 = ipairs, type, IsValid, util.SteamIDFrom64
local tag = "[proxyblocker]"

local function FindPlayer(identifier)
	if (type(identifier) == "string") then
		for _, v in ipairs(player_GetHumans()) do
			if (string_find(string_lower(v:Name()), string_lower(identifier)) or string_find(string_lower(v:SteamID()), string_lower(identifier))) then
				return v
			end
		end
	elseif (type(identifier) == "number") then
		for _, v in ipairs(player_GetHumans()) do
			if (string_find(v:Name(), identifier) or string_find(v:SteamID64(), identifier) or string_find(v:SteamID(), identifier)) then
				return v
			end
		end
		
		if (IsValid(player_GetHumans()[identifier])) then
			return player_GetHumans()[identifier]
		end
	else
		print("FindPlayer: Search identifier has unexpected value type! (string expected, got "..type(identifier)..")")
	end
end

hook.Add("CheckPassword", "ProxyBlocker_Cpassword", function(sid64, ip, sPass, enteredPass, name)
	local steamid = util_SteamIDFrom64(steamid64)
	local url = string_format("http://proxy.mind-media.com/block/proxycheck.php?ip=%s", ip)
	local index = FindPlayer(steamid)
	
	http_Fetch(url, function(info)
		if (info == "NOT a proxy") then
			print(string_format("%s %s don't using proxy/vpn", tag, name))
			return
		end
		
		index:Kick("Unable to validate IP address.")
	end,
	
	function(err)
		ServerLog(string_format("%s Failed to check for player %s [%s], HTTP Error: %s\n", tag, name, steamid, tostring(err)))
	end)
end)

-- https://facepunch.com/showthread.php?t=1578619&p=52680071&viewfull=1#post52680071
