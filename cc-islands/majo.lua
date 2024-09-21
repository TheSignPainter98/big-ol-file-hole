local verbose, main, start
local ArgParser, Flag, Param, Subcommand
do
	local _obj_0 = require('clap')
	ArgParser, Flag, Param, Subcommand = _obj_0.ArgParser, _obj_0.Flag, _obj_0.Param, _obj_0.Subcommand
end
verbose = false
main = function(args)
	local arg_parser
	do
		local _with_0 = ArgParser('majo')
		_with_0:version('0.1')
		_with_0:description('a cargo auto-router')
		_with_0:add((function()
			local _with_1 = Subcommand('start')
			_with_1:description('start a majo node')
			_with_1:add((function()
				local _with_2 = Param('type')
				_with_2:options({
					'commander',
					'factory'
				})
				return _with_2
			end)())
			return _with_1
		end)())
		_with_0:add((function()
			local _with_1 = Subcommand('node')
			_with_1:description('station node')
			_with_1:add(Param('a'))
			return _with_1
		end)())
		arg_parser = _with_0
	end
	local ok
	args, ok = arg_parser:parse(args)
	if not ok then
		return
	end
	if (args.start ~= nil) then
		return start(args.start)
	end
end
start = function(args)
	return print('fdhsjak')
end
return main({
	...
})
