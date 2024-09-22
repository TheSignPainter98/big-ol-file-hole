local _module_0 = { }
local INPUT_STARVATION_THRESHOLD_KEY, OUTPUT_READY_THRESHOLD_KEY, is_active, register_args, run, run_get, run_set, input_starvation_threshold, output_ready_threshold, get
local Param, Subcommand
do
	local _obj_0 = require('clap')
	Param, Subcommand = _obj_0.Param, _obj_0.Subcommand
end
INPUT_STARVATION_THRESHOLD_KEY = 'input-starvation-threshold'
_module_0["INPUT_STARVATION_THRESHOLD_KEY"] = INPUT_STARVATION_THRESHOLD_KEY
OUTPUT_READY_THRESHOLD_KEY = 'output-ready-threshold'
_module_0["OUTPUT_READY_THRESHOLD_KEY"] = OUTPUT_READY_THRESHOLD_KEY
is_active = function(args)
	return (args.get ~= nil) or (args.set ~= nil)
end
_module_0["is_active"] = is_active
register_args = function(parser)
	local config_keys = {
		INPUT_STARVATION_THRESHOLD_KEY,
		OUTPUT_READY_THRESHOLD_KEY
	}
	parser:add((function()
		local _with_0 = Subcommand('get')
		_with_0:description('get config value')
		_with_0:add((function()
			local _with_1 = Param('option')
			_with_1:options(config_keys)
			_with_1:description('config value to print')
			return _with_1
		end)())
		return _with_0
	end)())
	parser:add((function()
		local _with_0 = Subcommand('set')
		_with_0:description('set config value')
		_with_0:add((function()
			local _with_1 = Param('option')
			_with_1:options(config_keys)
			_with_1:description('config key to set')
			return _with_1
		end)())
		_with_0:add((function()
			local _with_1 = Param('value')
			_with_1:description('new config value')
			return _with_1
		end)())
		return _with_0
	end)())
	return parser
end
_module_0["register_args"] = register_args
run = function(args)
	if (args.set ~= nil) then
		return run_set(args.option, args.value)
	else
		if (args.get ~= nil) then
			return run_get(args.option)
		end
	end
end
_module_0["run"] = run
run_get = function(option)
	if not (settings ~= nil) then
		error('settings unavailable')
	end
	settings.load()
	return print(settings.get(option))
end
run_set = function(option, value)
	if not (settings ~= nil) then
		error('settings unavailable')
	end
	settings.load()
	settings.set(option, value)
	return settings.save()
end
input_starvation_threshold = function()
	return get(INPUT_STARVATION_THRESHOLD_KEY)
end
_module_0["input_starvation_threshold"] = input_starvation_threshold
output_ready_threshold = function()
	return get(OUTPUT_READY_THRESHOLD_KEY)
end
_module_0["output_ready_threshold"] = output_ready_threshold
get = function(option)
	if not (settings ~= nil) then
		error('settings unavailable')
	end
	settings.load()
	return settings.get(option)
end
return _module_0
