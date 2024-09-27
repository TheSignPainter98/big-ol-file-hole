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
	return xpcall(function()
		local err
		if node.is_active(args) then
			err = node.run(args)
		else
			if config.is_active(args) then
				err = config.run(args)
			else
				err = 'internal error: no active command'
			end
		end
		if (err ~= nil) then
			return error(err)
		end
	end, function(err)
		return xpcall(function()
			local colour = term.getTextColor()
			term.setTextColor(colors.red)
			print(err)
			return term.setTextColor(colour)
		end, function(err2)
			return print("error: caught another error:\n" .. tostring(err2) .. "\nwhilst handling:\n" .. tostring(err))
		end)
	end)
end
return main({
	...
})
