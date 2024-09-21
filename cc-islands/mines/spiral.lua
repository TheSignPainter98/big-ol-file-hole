local _module_0 = { }
local yield = coroutine.yield
local Vector, Matrix
do
	local _obj_0 = require('..linalg')
	Vector, Matrix = _obj_0.Vector, _obj_0.Matrix
end
local RING_GAP = 4
local waypoints
waypoints = function(self)
	return coroutine.wrap(function()
		local radius = 0
		while true do
			radius = radius + 1
			for i = 1, 4 do
				yield(Vector({
					radius,
					0,
					radius
				}))
				yield(Vector({
					radius,
					0,
					-radius
				}))
				yield(Vector({
					-radius,
					0,
					-radius
				}))
				yield(Vector({
					-radius,
					0,
					radius
				}))
				yield(Vector({
					-(radius + 1),
					0,
					radius + 1
				}))
			end
		end
	end)
end
_module_0["waypoints"] = waypoints
return _module_0
