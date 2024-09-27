local _module_0 = { }
local run, Consumer
local config = require('majo.config')
local Berth
do
	local _obj_0 = require('majo.berth')
	Berth = _obj_0.Berth
end
local ResourceSupplierRequest, ResourceDeliveryRequest, ResourceSupplierResponse, ResourceDeliveryResponse
do
	local _obj_0 = require('majo.messages')
	ResourceSupplierRequest, ResourceDeliveryRequest, ResourceSupplierResponse, ResourceDeliveryResponse = _obj_0.ResourceSupplierRequest, _obj_0.ResourceDeliveryRequest, _obj_0.ResourceSupplierResponse, _obj_0.ResourceDeliveryResponse
end
local Stockpile
do
	local _obj_0 = require('majo.stockpile')
	Stockpile = _obj_0.Stockpile
end
local Uplink
do
	local _obj_0 = require('majo.uplink')
	Uplink = _obj_0.Uplink
end
run = function(_args)
	local _with_0 = Consumer()
	_with_0:listen()
	return _with_0
end
_module_0["run"] = run
do
	local _class_0
	local _base_0 = {
		listen = function(self)
			self.state.awaiting_train_id = nil
			while true do
				if backed_off then
					sleep(1)
				else
					local backoff = true
				end
				if self.berth:train_present() then
					self.state.awaiting_train_id = nil
				end
				if not (self.state.awaiting_train_id ~= nil) then
					local err = self:listen_for_low_resource()
					if (err ~= nil) and err ~= IGNORE then
						print(err)
					end
				end
				local err = self:listen_for_train_request()
				if (err ~= nil) and err ~= IGNORE then
					print(err)
				end
			end
		end,
		listen_for_low_resource = function(self)
			if self.stockpile:level() < self.input_starvation_threshold then
				local train_id, err = self:negotiate_train_of(self.resource)
				if (err ~= nil) then
					return err
				end
				self.state.awaiting_train_id = train_id
				return nil
			end
		end,
		negotiate_train_of = function(self, resource)
			self.uplink:broadcast(ResourceSupplierRequest(resource))
			local message, err = self.uplink:receive_from_any(ResourceSupplierResponse, {
				timeout = 10
			})
			if (err ~= nil) then
				return nil, "cannot find supplier for " .. tostring(resource) .. ": " .. tostring(err)
			end
			local supplier_id, data = message.from_id, message.data
			if data.resource ~= resource then
				return nil, IGNORE
			end
			err = self.uplink:send(supplier_id, ResourceDeliveryRequest(resource, self.berth:name()))
			if (err ~= nil) then
				return nil, err
			end
			message, err = self.uplink:receive_from(supplier_id, ResourceDeliveryResponse, {
				timeout = 60
			})
			if (err ~= nil) then
				return nil, err
			end
			if data.resource ~= resource then
				return nil, IGNORE
			end
			supplier_id, data = message.from_id, message.data
			return data.train_id, nil
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self)
			self.uplink = Uplink()
			self.berth = Berth:find_sole()
			self.stockpile = Stockpile:find_sole()
			self.input_starvation_threshold = tonumber(config.input_starvation_threshold())
			if self.input_starvation_threshold < 0 or 1 < self.input_starvation_threshold then
				error('input starvation threshold must be between 0 and 1')
			end
			self.resource = config.resource()
			self.state = { }
		end,
		__base = _base_0,
		__name = "Consumer"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Consumer = _class_0
end
return _module_0
