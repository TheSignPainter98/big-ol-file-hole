local quiet, main, get_file, log
local ArgParser, Flag, Param
do
	local _obj_0 = require('clap')
	ArgParser, Flag, Param = _obj_0.ArgParser, _obj_0.Flag, _obj_0.Param
end
quiet = false
main = function(args)
	local arg_parser
	do
		local _with_0 = ArgParser('refresh')
		_with_0:version('0.1')
		_with_0:description('a downloader of up-to-date files')
		_with_0:add_arg((function()
			local _with_1 = Flag('quiet')
			_with_1:description('output quietly')
			return _with_1
		end)())
		_with_0:add_arg((function()
			local _with_1 = Param('source')
			_with_1:description('where to get the files from')
			return _with_1
		end)())
		arg_parser = _with_0
	end
	local ok
	args, ok = arg_parser:parse(args)
	if not ok then
		return
	end
	quiet = args.quiet
	print("quiet: " .. tostring(args.quiet))
	return print("source: " .. tostring(args.source))
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
