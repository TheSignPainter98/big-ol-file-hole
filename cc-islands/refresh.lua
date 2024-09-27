local quiet, verbose, main, make_sources_url, get_paths, get_file_content, log, debug
local ArgParser, Flag, Param
do
	local _obj_0 = require('clap')
	ArgParser, Flag, Param = _obj_0.ArgParser, _obj_0.Flag, _obj_0.Param
end
quiet = false
verbose = false
main = function(args)
	local arg_parser
	do
		local _with_0 = ArgParser('refresh')
		_with_0:version('1.0')
		_with_0:description('a downloader of up-to-date files')
		_with_0:add((function()
			local _with_1 = Param('user')
			_with_1:description('whose repo to pull from')
			return _with_1
		end)())
		_with_0:add((function()
			local _with_1 = Param('repo')
			_with_1:description('repo name to pull from')
			return _with_1
		end)())
		_with_0:add((function()
			local _with_1 = Param('folder')
			_with_1:description('folder to pull from')
			_with_1:default(nil)
			return _with_1
		end)())
		_with_0:add((function()
			local _with_1 = Flag('quiet')
			_with_1:description('output quietly')
			return _with_1
		end)())
		_with_0:add((function()
			local _with_1 = Flag('verbose')
			_with_1:description('output verbosely')
			return _with_1
		end)())
		_with_0:add((function()
			local _with_1 = Flag('url-template')
			_with_1:default('https://raw.githubusercontent.com/{user}/{repo}/{branch}{folder}')
			_with_1:description('where to get the files from')
			return _with_1
		end)())
		_with_0:add((function()
			local _with_1 = Flag('branch')
			_with_1:description('branch in the repo to pull from')
			_with_1:default('master')
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
	verbose = args.verbose
	local sources_url = make_sources_url(args)
	local err
	ok, err = http.checkUrl(source)
	if not ok then
		print("url invalid: " .. tostring(err))
		return
	end
	local resp
	resp, err = http.get(sources_url)
	if not (resp ~= nil) then
		print(err)
		return
	end
	local content
	do
		content = resp:readAll()
		resp:close()
	end
	error("downloading from " .. tostring(resp))
	debug("downloading files from " .. tostring(source))
	local any_failed = false
	local _list_0 = get_paths('/')
	for _index_0 = 1, #_list_0 do
		local path = _list_0[_index_0]
		log(tostring(path) .. "...")
		local file_content
		file_content, err = get_file_content(source, path)
		if (err ~= nil) then
			log(err)
			any_failed = true
			goto _continue_0
		end
		debug("got " .. tostring(#file_content) .. "B")
		local file = fs.open(path, 'w')
		if not (file ~= nil) then
			error("cannot write to " .. tostring(path))
		end
		file.write(file_content)
		file.close()
		::_continue_0::
	end
	if not any_failed then
		return log('SUCCESS')
	end
end
make_sources_url = function(args)
	local url_template, user, repo, branch, folder = args.url_template, args.user, args.repo, args.branch, args.folder
	if folder == nil then
		folder = ""
	end
	if #folder > 0 then
		folder = "/" .. tostring(folder)
	end
	return (url_template:gsub('{user}', user)):gsub('{repo}', repo):gsub('{branch}', branch):gsub('{folder}', folder)
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
		local child_path
		if path ~= '/' then
			child_path = tostring(path) .. "/" .. tostring(child)
		else
			child_path = "/" .. tostring(child)
		end
		if fs.isDir(child_path) then
			get_paths(child_path, paths)
		else
			paths[#paths + 1] = child_path
		end
	end
	return paths
end
get_file_content = function(repo, path)
	assert('/' == path:sub(1, 1))
	local url = tostring(repo) .. tostring(path)
	local ok, err = http.checkURL(url)
	if not ok then
		return nil, err
	end
	debug("downloading " .. tostring(url) .. "...")
	local resp = http.get(url)
	if not (resp ~= nil) then
		return nil, 'FAILED'
	end
	debug('done')
	local content = resp:readAll()
	resp:close()
	if not (content ~= nil) then
		error('received content nil for some reason')
	end
	return content, nil
end
log = function(message)
	if quiet then
		return
	end
	return print(message)
end
debug = function(message)
	if not verbose then
		return
	end
	return print(message)
end
return main({
	...
})
