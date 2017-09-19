local string_format, http_Fetch, player_GetHumans, string_find, string_lower = string.format, http.Fetch, player.GetHumans, string.find, string.lower
local ipairs, type, IsValid, util_SteamIDFrom64 = ipairs, type, IsValid, util.SteamIDFrom64
local tag = "[proxyblocker]"

local function FindPlayer(yep)
	if (type(yep) == "string") then
		for k, v in ipairs(player_GetHumans()) do
			if (string_find(string_lower(v:Name()), string_lower(yep))) then
				return v
			elseif (string_find(string_lower(v:SteamID()), string_lower(yep))) then
				return v
			end
		end
	elseif (type(yep) == "number") then
		for k, v in ipairs(player_GetHumans()) do
			if (string_find(v:Name(), yep)) then
				return v
			elseif (string_find(v:SteamID64(), yep)) then
				return v
			elseif (string_find(v:SteamID(), yep)) then
				return v
			end
		end
		
		if (IsValid(player_GetHumans()[yep])) then
			return player_GetHumans()[yep]
		end
	else
		print("FindPlayer: Search yep has unexpected value type! (string expected, got "..type(yep)..")")
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
