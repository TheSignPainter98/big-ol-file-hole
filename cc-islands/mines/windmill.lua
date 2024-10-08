local _module_0 = { }
local yield = coroutine.yield
local Vector, Matrix
do
	local _obj_0 = require('..linalg')
	Vector, Matrix = _obj_0.Vector, _obj_0.Matrix
end
local RING_GAP = 4
local ROTATE_LEFT = Matrix:Rotate2d(-math.pi / 2)
local ROTATE_RIGHT = Matrix:Rotate2d(math.pi / 2)
local waypoints
waypoints = function(self)
	return coroutine.wrap(function()
		yield(Vector({
			RING_GAP,
			0
		}))
		local radius = 0
		local rotation = Matrix:Identity(2)
		while true do
			radius = radius + RING_GAP
			for i = 1, 4 do
				yield(rotation * Vector({
					radius,
					RING_GAP + radius
				}))
				yield(rotation * Vector({
					radius,
					-radius
				}))
				rotation = ROTATE_LEFT * rotation
			end
			yield(rotation * Vector({
				radius,
				RING_GAP + radius
			}))
			rotation = ROTATE_RIGHT * rotation
		end
	end)
end
_module_0["waypoints"] = waypoints
return _module_0
