local _module_0 = { }
local IGNORE, run, Producer
local Param, Subcommand
do
	local _obj_0 = require('clap')
	Param, Subcommand = _obj_0.Param, _obj_0.Subcommand
end
local Berth
do
	local _obj_0 = require('majo.berth')
	Berth = _obj_0.Berth
end
local ResourceSupplierRequest, ResourceSupplierResponse, ResourceDeliveryRequest, ResourceDeliveryResponse
do
	local _obj_0 = require('majo.messages')
	ResourceSupplierRequest, ResourceSupplierResponse, ResourceDeliveryRequest, ResourceDeliveryResponse = _obj_0.ResourceSupplierRequest, _obj_0.ResourceSupplierResponse, _obj_0.ResourceDeliveryRequest, _obj_0.ResourceDeliveryResponse
end
local Stockpile
do
	local _obj_0 = require('majo.stockpile')
	Stockpile = _obj_0.Stockpile
end
local Uplink, TIMEOUT
do
	local _obj_0 = require('majo.uplink')
	Uplink, TIMEOUT = _obj_0.Uplink, _obj_0.TIMEOUT
end
local config = require('majo.config')
IGNORE = setmetatable({ }, {
	__tostring = function(self)
		return '<ignore>'
	end
})
run = function(_args)
	local _with_0 = Producer()
	_with_0:listen()
	return _with_0
end
_module_0["run"] = run
do
	local _class_0
	local _base_0 = {
		listen = function(self)
			local backoff = false
			while true do
				if backed_off then
					sleep(1)
				else
					backoff = true
				end
				local err = self:listen_for_supplier_request()
				if (err ~= nil) and err ~= IGNORE then
					print(err)
				end
				err = self:listen_for_delivery_request()
				if (err ~= nil) and err ~= IGNORE then
					print(err)
				end
				err = self:listen_for_train_request()
				if (err ~= nil) and err ~= IGNORE then
					print(err)
				end
			end
		end,
		listen_for_supplier_request = function(self)
			local message, err = self.uplink:receive_from_any(ResourceSupplierRequest, {
				timeout = 5
			})
			if (err ~= nil) then
				print(err)
				return IGNORE
			end
			local requester_id, data = message.from_id, message.data
			if not self:is_available_here(data.resource) then
				return IGNORE
			end
			local resp = ResourceSupplierResponse(resource)
			err = self.uplink:send(requester_id, resp)
			if (err ~= nil) then
				print(err)
				return IGNORE
			end
		end,
		listen_for_delivery_request = function(self)
			local message, err = self.uplink:receive_from_any(ResourceDeliveryRequest)
			if (err ~= nil) then
				if err == TIMEOUT then
					return IGNORE
				end
				return err
			end
			local requester_id, data = message.from_id, message.data
			local requester_station_name = data.to_station_name
			if not self:is_available_here(data.resource) then
				return IGNORE
			end
			self.uplink:broadcast(AvailableTrainRequest())
			message, err = self.uplink:receive_from_any(AvailableTrainResponse)
			if (err ~= nil) then
				return err
			end
			local train_provider_id
			train_provider_id, data = message.from_id, message.data
			local train_id = data.train_id
			err = self.uplink:send(train_provider_id, TrainScheduleRequest(train_id, self.berth:name(), requester_station_name))
			if (err ~= nil) then
				return err
			end
			return nil
		end,
		listen_for_train_request = function(self)
			return error('todo')
		end,
		on_available_train_request = function(self)
			return error('todo')
		end,
		on_schedule_train_request = function(self)
			return error('todo')
		end,
		is_available_here = function(self, resource)
			return self.resource == resource
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self)
			self.uplink = Uplink()
			self.berth = Berth:find_sole()
			self.state = { }
			self.stockpile = Stockpile:find_sole()
			self.output_ready_threshold = config.output_ready_threshold()
			self.resource = config.resource()
		end,
		__base = _base_0,
		__name = "Producer"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Producer = _class_0
end
return _module_0
