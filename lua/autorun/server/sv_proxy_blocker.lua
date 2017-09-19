local string.format, http_Fetch = string.format, http.Fetch

local tag = "[proxyblocker]"

hook.Add("CheckPassword", "ProxyBlocker_Cpassword", function(sid64, ip, sPass, enteredPass, name)
	local steamid = util.SteamIDFrom64(steamid64)
	local url = string_format("http://proxy.mind-media.com/block/proxycheck.php?ip=%s", ip)
	
	http_Fetch(url, function(info)
		if (info == "NOT a proxy") then
			print(string_format("%s %s don't using proxy/vpn\n", tag, name))
			return
		end
		
		return false -- не пускаем на сервер.
	end,
	
	function(err)
		ServerLog(string_format("%s Failed to check for player %s [%s], HTTP Error: %s\n", tag, name, steamid, tostring(err)))
	end)
end)

-- https://facepunch.com/showthread.php?t=1578619&p=52680071&viewfull=1#post52680071