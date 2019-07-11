hook.Add("CheckPassword", "ProxyBlocker_Cpassword", function(sid, ip, a, b, name)
	http.Fetch("http://proxy.mind-media.com/block/proxycheck.php?ip="..ip, function(body)		
		if body == 'Y' then
			return false
		end
	end,
	
	function(err)
		ServerLog(string.format("%s Failed to check for player %s [%s], HTTP Error: %s\n", "[proxyblocker]", name, util.SteamIDFrom64(sid), tostring(err)))
	end)
end)