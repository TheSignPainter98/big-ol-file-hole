local REPO, quiet, main, get_file, log
local checkURL = http.checkURL
REPO = 'TheSignPainter98/big-ol-file-hole'
quiet = false
main = function(args)
	for i = 1, #args do
		local arg = args[i]
		if '-q' == arg then
			quiet = true
		else
			error("Unrecognised argument '" .. tostring(arg) .. "'")
		end
	end
end
get_file = function(path)
	local url = tostring(REPO) .. "/" .. tostring(path)
	local ok, err = http.checkUrl(url)
	if not ok then
		return err
	end
	log("downloading " .. tostring(url) .. "...")
	local resp = http.get(url)
	if not (response ~= nil) then
		return "failed"
	end
	log('success')
	local content = resp.readAll()
	resp.close()
	if not (content ~= nil) then
		error("received content nil for some reason")
	end
	return content
end
log = function(message)
	if quiet then
		return
	end
	return write(message)
end
return main({
	...
})
