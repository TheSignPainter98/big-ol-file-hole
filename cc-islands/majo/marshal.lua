local _module_0 = { }
local run
local Uplink
do
	local _obj_0 = require('majo.uplink')
	Uplink = _obj_0.Uplink
end
local RefreshRequest
do
	local _obj_0 = require('majo.messages')
	RefreshRequest = _obj_0.RefreshRequest
end
run = function(_args)
	local uplink = Uplink()
	return uplink:broadcast(RefreshRequest())
end
_module_0["run"] = run
return _module_0
