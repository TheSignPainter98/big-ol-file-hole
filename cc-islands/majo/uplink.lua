local _module_0 = { }
local TIMEOUT
TIMEOUT = setmetatable({ }, {
	__tostring = function(self)
		return "<timeout>"
	end
})
local Uplink
do
	local _class_0
	local _base_0 = {
		broadcast = function(self, message)
			print("broadcasting a " .. tostring(message:protocol()))
			return rednet.broadcast(message, message:protocol())
		end,
		send_to = function(self, to_id, message)
			print("sending a " .. tostring(message:protocol()) .. " to PC#" .. tostring(to_id))
			local ok = rednet.send(supplier_id, message)
			if not ok then
				return "failed to send " .. tostring(message:protocol())
			end
			return nil
		end,
		receive_from_any = function(self, message_type, opts)
			if opts == nil then
				opts = { }
			end
			print("awaiting a " .. tostring(message_type:protocol()) .. " from anyone")
			return self:_receive_from(nil, message_type, opts)
		end,
		receive_from = function(self, from_id, message_type, opts)
			if opts == nil then
				opts = { }
			end
			print("awaiting a " .. tostring(message_type:protocol()) .. " from PC#" .. tostring(from_id))
			return self:_receive_from(from_id, message_type, opts)
		end,
		_receive_from = function(self, from_id, message_type, opts)
			if opts == nil then
				opts = { }
			end
			local timeout = opts.timeout
			if timeout == nil then
				timeout = 5
			end
			local id, message
			while true do
				id, message = rednet.receive(message_type:protocol(), timeout)
				if not (id ~= nil) then
					return nil, TIMEOUT
				end
				if (from_id ~= nil) and id == from_id then
					break
				end
			end
			local data, ok = message_type:from(message)
			if not ok then
				return nil, "unexpected message " .. tostring(message) .. ", expected " .. tostring(message_type:protocol())
			end
			local ret = {
				from_id = from_id,
				data = data
			}
			return ret, nil
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self)
			peripheral.find('modem', rednet.open)
			if not rednet.isOpen() then
				return error('cannot find modem')
			end
		end,
		__base = _base_0,
		__name = "Uplink"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Uplink = _class_0
end
_module_0["Uplink"] = Uplink
return _module_0
