local REPO, quiet, main, get_file, log
local checkURL = http.checkURL
local Args, Flag, Param
do
	local _obj_0 = 'argparse'
	Args, Flag, Param = _obj_0.Args, _obj_0.Flag, _obj_0.Param
end
REPO = 'TheSignPainter98/big-ol-file-hole'
quiet = false
main = function(args)
	local arg_parser
	do
		local _with_0 = Args('refresh')
		_with_0:add_flag(Flag('quiet'))
		_with_0:add_param(Param('source'))
		arg_parser = _with_0
	end
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
