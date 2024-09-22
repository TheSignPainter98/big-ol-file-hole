local _module_0 = { }
local is_active, register_args, run, Factory, Message, Response, ResourceSupplierRequest, ResourceSupplierResponse, ResourceDeliveryRequest, ResourceDeliveryResponse, run_factory
local Param, Subcommand
do
	local _obj_0 = require('clap')
	Param, Subcommand = _obj_0.Param, _obj_0.Subcommand
end
local config = require('majo.config')
is_active = function(args)
	return (args.start ~= nil)
end
_module_0["is_active"] = is_active
register_args = function(parser)
	parser:add((function()
		local _with_0 = Subcommand('start')
		_with_0:description('start a majo node')
		_with_0:add((function()
			local _with_1 = Param('type')
			_with_1:options({
				'factory',
				'marshal'
			})
			_with_1:default('factory')
			return _with_1
		end)())
		return _with_0
	end)())
	return parser
end
_module_0["register_args"] = register_args
run = function(args)
	local _exp_0 = args.start.type
	if 'factory' == _exp_0 then
		return run_factory(args)
	elseif 'marshal' == _exp_0 then
		return error('todo')
	else
		return error("internal error: unrecognised node type " .. tostring(args.start.type))
	end
end
_module_0["run"] = run
do
	local _class_0
	local _base_0 = {
		run = function(self)
			local modem = peripheral.find('modem')
			if not (modem ~= nil) then
				error('cannot find modem')
			end
			rednet.open(modem)
			while true do
				sleep(1)
				local required_resources = self:required_resources()
				if #required_resources > 0 then
					for _index_0 = 1, #required_resources do
						local resource = required_resources[_index_0]
						local train, err = self:negotiate_train_of(resource)
						if (err ~= nil) then
							print(err)
							goto _continue_0
						end
						print("train " .. tostring(train) .. " en-route with " .. tostring(resource))
						::_continue_0::
					end
				end
			end
		end,
		require_resources = function(self)
			return {
				'minecraft:dirt'
			}
		end,
		negotiate_train_of = function(self, resource)
			local request = ResourceSupplierRequest(resource)
			rednet.broadcast(request, request:protocol())
			local supplier_id, message = rednet.receive(ResourceSupplierResponse:protocol(), 10)
			if not (supplier_id ~= nil) then
				return nil, "no suppliers found for " .. tostring(resource)
			end
			local resource_supplier_response, ok = ResourceSupplierResponse:from(message)
			if not ok then
				return nil, "unexpected message " .. tostring(message) .. ", expected " .. tostring(ResourceSupplierResponse:protocol())
			end
			if resource_supplier_response.resource ~= resource then
				return nil, "incorrect resource supplier response: got supplier for " .. tostring(resource_supplier_response.resource)
			end
			ok = rednet.send(supplier_id, ResourceDeliveryRequest(resource))
			if not ok then
				return nil, "failed to send " .. tostring(ResourceDeliveryRequest:protocol())
			end
			supplier_id, message = rednet.receive(ResourceDeliveryResponse:protocol(), 60)
			if not supplier_id then
				return nil, "supplier did not report schedule of delivery for " .. tostring(resource)
			end
			local resource_delivery_response
			resource_delivery_response, ok = ResourceDeliveryResponse:from(message)
			if not ok then
				return nil, "unexpected message " .. tostring(message) .. ", expected " .. tostring(ResourceDeliveryResponse:protocol())
			end
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self)
			self.input_starvation_threshold = config.input_starvation_threshold()
			self.output_ready_threshold = config.output_ready_threshold()
		end,
		__base = _base_0,
		__name = "Factory"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Factory = _class_0
end
do
	local _class_0
	local _base_0 = { }
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function() end,
		__base = _base_0,
		__name = "Message"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	local self = _class_0;
	self.protocol = function(self)
		return getmetatable(self).__class.__name
	end
	Message = _class_0
end
do
	local _class_0
	local _parent_0 = Message
	local _base_0 = { }
	for _key_0, _val_0 in pairs(_parent_0.__base) do
		if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
			_base_0[_key_0] = _val_0
		end
	end
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	setmetatable(_base_0, _parent_0.__base)
	_class_0 = setmetatable({
		__init = function(self, ...)
			return _class_0.__parent.__init(self, ...)
		end,
		__base = _base_0,
		__name = "Response",
		__parent = _parent_0
	}, {
		__index = function(cls, name)
			local val = rawget(_base_0, name)
			if val == nil then
				local parent = rawget(cls, "__parent")
				if parent then
					return parent[name]
				end
			else
				return val
			end
		end,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	local self = _class_0;
	self.from = function(self, message)
		if message:protocol() == self.__class:protocol() then
			return message, true
		else
			return nil, false
		end
	end
	if _parent_0.__inherited then
		_parent_0.__inherited(_parent_0, _class_0)
	end
	Response = _class_0
end
do
	local _class_0
	local _parent_0 = Message
	local _base_0 = { }
	for _key_0, _val_0 in pairs(_parent_0.__base) do
		if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
			_base_0[_key_0] = _val_0
		end
	end
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	setmetatable(_base_0, _parent_0.__base)
	_class_0 = setmetatable({
		__init = function(self, resource)
			self.resource = resource
		end,
		__base = _base_0,
		__name = "ResourceSupplierRequest",
		__parent = _parent_0
	}, {
		__index = function(cls, name)
			local val = rawget(_base_0, name)
			if val == nil then
				local parent = rawget(cls, "__parent")
				if parent then
					return parent[name]
				end
			else
				return val
			end
		end,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	if _parent_0.__inherited then
		_parent_0.__inherited(_parent_0, _class_0)
	end
	ResourceSupplierRequest = _class_0
end
do
	local _class_0
	local _parent_0 = Response
	local _base_0 = { }
	for _key_0, _val_0 in pairs(_parent_0.__base) do
		if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
			_base_0[_key_0] = _val_0
		end
	end
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	setmetatable(_base_0, _parent_0.__base)
	_class_0 = setmetatable({
		__init = function(self, resource)
			self.resource = resource
		end,
		__base = _base_0,
		__name = "ResourceSupplierResponse",
		__parent = _parent_0
	}, {
		__index = function(cls, name)
			local val = rawget(_base_0, name)
			if val == nil then
				local parent = rawget(cls, "__parent")
				if parent then
					return parent[name]
				end
			else
				return val
			end
		end,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	if _parent_0.__inherited then
		_parent_0.__inherited(_parent_0, _class_0)
	end
	ResourceSupplierResponse = _class_0
end
do
	local _class_0
	local _parent_0 = Message
	local _base_0 = { }
	for _key_0, _val_0 in pairs(_parent_0.__base) do
		if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
			_base_0[_key_0] = _val_0
		end
	end
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	setmetatable(_base_0, _parent_0.__base)
	_class_0 = setmetatable({
		__init = function(self, resource)
			self.resource = resource
		end,
		__base = _base_0,
		__name = "ResourceDeliveryRequest",
		__parent = _parent_0
	}, {
		__index = function(cls, name)
			local val = rawget(_base_0, name)
			if val == nil then
				local parent = rawget(cls, "__parent")
				if parent then
					return parent[name]
				end
			else
				return val
			end
		end,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	if _parent_0.__inherited then
		_parent_0.__inherited(_parent_0, _class_0)
	end
	ResourceDeliveryRequest = _class_0
end
do
	local _class_0
	local _parent_0 = Response
	local _base_0 = { }
	for _key_0, _val_0 in pairs(_parent_0.__base) do
		if _base_0[_key_0] == nil and _key_0:match("^__") and not (_key_0 == "__index" and _val_0 == _parent_0.__base) then
			_base_0[_key_0] = _val_0
		end
	end
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	setmetatable(_base_0, _parent_0.__base)
	_class_0 = setmetatable({
		__init = function(self, train_id)
			self.train_id = train_id
		end,
		__base = _base_0,
		__name = "ResourceDeliveryResponse",
		__parent = _parent_0
	}, {
		__index = function(cls, name)
			local val = rawget(_base_0, name)
			if val == nil then
				local parent = rawget(cls, "__parent")
				if parent then
					return parent[name]
				end
			else
				return val
			end
		end,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	if _parent_0.__inherited then
		_parent_0.__inherited(_parent_0, _class_0)
	end
	ResourceDeliveryResponse = _class_0
end
run_factory = function(args)
	while true do
		sleep(1)
	end
end
return _module_0
