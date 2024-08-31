local quiet, main, get_paths, get_file_content, log
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
			_with_1:default('github.com/TheSignPainter98/big-ol-file-hole')
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
	log("downloading files from " .. tostring(args.source))
	local _list_0 = get_paths('/')
	for _index_0 = 1, #_list_0 do
		local path = _list_0[_index_0]
		log("downloading " .. tostring(path) .. "...")
		local file_content, err = get_file_content(args.source, path)
		if (err ~= nil) then
			error(err)
		end
		log("writing content to " .. tostring(path) .. "...")
		do
			local _with_0 = fs.open(path, 'w+')
			_with_0:write(file_content)
			_with_0:close()
		end
	end
	return log('success')
end
get_paths = function(path, paths)
	if paths == nil then
		paths = { }
	end
	if not fs.isDir(path) then
		error("get_paths must be called with a directory, got " .. tostring(path))
	end
	if path == '/rom' then
		return paths
	end
	local _list_0 = fs.list(path)
	for _index_0 = 1, #_list_0 do
		local child = _list_0[_index_0]
		local child_path = tostring(path) .. "/" .. tostring(child)
		if fs.isDir(child_path) then
			get_paths(child_path, paths)
		else
			paths[#paths + 1] = child_path
		end
	end
	return paths
end
get_file_content = function(repo, path)
	local url = tostring(repo) .. "/" .. tostring(path)
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
	return print(message)
end
return main({
	...
})
