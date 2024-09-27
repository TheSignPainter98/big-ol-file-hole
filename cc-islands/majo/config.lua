local _module_0 = { }
local INPUT_STARVATION_THRESHOLD_KEY, OUTPUT_READY_THRESHOLD_KEY, RESOURCE_KEY, is_active, register_args, run, run_get, run_set, input_starvation_threshold, output_ready_threshold, resource, NOT_SET, get, make_config_key
local Param, Subcommand
do
	local _obj_0 = require('clap')
	Param, Subcommand = _obj_0.Param, _obj_0.Subcommand
end
INPUT_STARVATION_THRESHOLD_KEY = 'input-starvation-threshold'
_module_0["INPUT_STARVATION_THRESHOLD_KEY"] = INPUT_STARVATION_THRESHOLD_KEY
OUTPUT_READY_THRESHOLD_KEY = 'output-ready-threshold'
_module_0["OUTPUT_READY_THRESHOLD_KEY"] = OUTPUT_READY_THRESHOLD_KEY
RESOURCE_KEY = 'resource'
_module_0["RESOURCE_KEY"] = RESOURCE_KEY
is_active = function(args)
	return (args.get ~= nil) or (args.set ~= nil)
end
_module_0["is_active"] = is_active
register_args = function(parser)
	local config_keys = {
		INPUT_STARVATION_THRESHOLD_KEY,
		OUTPUT_READY_THRESHOLD_KEY,
		RESOURCE_KEY
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
		return run_set(args.set.option, args.set.value)
	else
		if (args.get ~= nil) then
			return run_get(args.get.option)
		else
			return error("internal error: could not discern config command")
		end
	end
end
_module_0["run"] = run
run_get = function(option)
	if not (settings ~= nil) then
		error('settings unavailable')
	end
	settings.load()
	print(get(option))
	return nil
end
run_set = function(option, value)
	if not (settings ~= nil) then
		error('settings unavailable')
	end
	settings.load()
	settings.set((make_config_key(option)), value)
	settings.save()
	return nil
end
input_starvation_threshold = function()
	return get(INPUT_STARVATION_THRESHOLD_KEY, 0.3)
end
_module_0["input_starvation_threshold"] = input_starvation_threshold
output_ready_threshold = function()
	return get(OUTPUT_READY_THRESHOLD_KEY, 0.6)
end
_module_0["output_ready_threshold"] = output_ready_threshold
resource = function()
	return get(RESOURCE_KEY)
end
_module_0["resource"] = resource
NOT_SET = setmetatable({ }, {
	__tostring = function(self)
		return "<not-set>"
	end
})
get = function(option, default)
	if default == nil then
		default = NOT_SET
	end
	if not (settings ~= nil) then
		error('settings unavailable')
	end
	settings.load()
	local ret = settings.get((make_config_key(option)), default)
	if ret == NOT_SET then
		error("missing setting, run:\n`majo set " .. tostring(option) .. " <value>'")
	end
	return ret
end
make_config_key = function(option_name)
	return "majo." .. tostring(option_name)
end
return _module_0
