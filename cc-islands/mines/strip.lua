local _module_0 = { }
local yield = coroutine.yield
local Vector
do
	local _obj_0 = require('..linalg')
	Vector = _obj_0.Vector
end
local STRIP_GAP = 4
local waypoints
waypoints = function(self)
	return coroutine.wrap(function()
		local distance = 0
		while true do
			distance = distance + STRIP_GAP
			yield(Vector({
				distance,
				0
			}))
			yield(Vector({
				distance,
				STRIP_GAP
			}))
			yield(Vector({
				distance,
				-STRIP_GAP
			}))
			yield(Vector({
				distance,
				0
			}))
		end
	end)
end
_module_0["waypoints"] = waypoints
return _module_0
