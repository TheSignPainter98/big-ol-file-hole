local verbose, main
local ArgParser, Flag, Param, Subcommand
do
	local _obj_0 = require('clap')
	ArgParser, Flag, Param, Subcommand = _obj_0.ArgParser, _obj_0.Flag, _obj_0.Param, _obj_0.Subcommand
end
local config = require('majo.config')
local node = require('majo.node')
verbose = false
main = function(args)
	local arg_parser
	do
		local _with_0 = ArgParser('majo')
		_with_0:version('0.1')
		_with_0:description('a cargo auto-router')
		arg_parser = _with_0
	end
	node.register_args(arg_parser)
	config.register_args(arg_parser)
	local ok
	args, ok = arg_parser:parse(args)
	if not ok then
		return
	end
	if node.is_active(args) then
		return node.run(args)
	else
		if config.is_active(args) then
			return config.run(args)
		end
	end
end
return main({
	...
})
