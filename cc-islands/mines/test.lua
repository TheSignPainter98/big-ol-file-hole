local _module_0 = { }
local yield = coroutine.yield
local Vector
do
	local _obj_0 = require('..linalg')
	Vector = _obj_0.Vector
end
local waypoints
waypoints = function(self)
	return coroutine.wrap(function()
		yield(Vector({
			10,
			0,
			0
		}))
		return yield(Vector({
			0,
			0,
			0
		}))
	end)
end
_module_0["waypoints"] = waypoints
return _module_0
