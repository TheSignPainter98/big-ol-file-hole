local _module_0 = { }
local is_active, register_args, run, install
local Flag, Param, Subcommand
do
	local _obj_0 = require('clap')
	Flag, Param, Subcommand = _obj_0.Flag, _obj_0.Param, _obj_0.Subcommand
end
local producer = require('majo.producer')
local consumer = require('majo.consumer')
is_active = function(args)
	return (args.start ~= nil)
end
_module_0["is_active"] = is_active
register_args = function(parser)
	parser:add((function()
		local _with_0 = Subcommand('start')
		_with_0:description('start a majo node')
		_with_0:add((function()
			local _with_1 = Param('type')
			_with_1:description('the node type to assign to this computer')
			_with_1:options({
				'producer',
				'consumer',
				'marshal'
			})
			return _with_1
		end)())
		_with_0:add((function()
			local _with_1 = Flag('no-install')
			_with_1:short(nil)
			_with_1:description('skip startup hook installation')
			return _with_1
		end)())
		return _with_0
	end)())
	return parser
end
_module_0["register_args"] = register_args
run = function(args)
	if not args.start.no_install then
		install(args.start)
	end
	local _exp_0 = args.start.type
	if 'producer' == _exp_0 then
		return producer.run(args.start)
	elseif 'consumer' == _exp_0 then
		return consumer.run(args.start)
	elseif 'marshal' == _exp_0 then
		return error('todo')
	else
		return error("internal error: unrecognised node type " .. tostring(args.start.type))
	end
end
_module_0["run"] = run
install = function(start_args)
	local node_type = start_args.type
	local file = io.open('startup.lua', 'w+')
	if file ~= nil then
		file:write("\n      shell.run('set motd.enable false')\n      shell.run('majo start " .. tostring(node_type) .. " --no-install')\n    ")
	end
	return file
end
return _module_0
