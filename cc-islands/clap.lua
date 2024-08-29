local _module_0 = { }
local Flag
local Param
local Args
do
	local _class_0
	local _base_0 = {
		add_flag = function(self, flag)
			do
				local _obj_0 = self._flags
				_obj_0[#_obj_0 + 1] = flag
			end
		end,
		add_param = function(self, param)
			do
				local _obj_0 = self._params
				_obj_0[#_obj_0 + 1] = param
			end
		end,
		no_help = function(self)
			self._add_help = false
		end,
		parse = function(self, args)
			if not self._auto_args_added then
				self:_add_auto_args()
			end
			self._auto_args_added = true
			do
				local err = self:_validate()
				if err then
					return nil, err
				end
			end
			local ret
			do
				local _with_0 = { }
				local _list_0 = self._flags
				for _index_0 = 1, #_list_0 do
					local flag = _list_0[_index_0]
					_with_0[flag._name] = flag._default
				end
				local _list_1 = self._params
				for _index_0 = 1, #_list_1 do
					local param = _list_1[_index_0]
					_with_0[param._name] = param._default
				end
				ret = _with_0
			end
			local flag_map
			do
				local _with_0 = { }
				local _list_0 = self._flags
				for _index_0 = 1, #_list_0 do
					local flag = _list_0[_index_0]
					if flag._short then
						_with_0[flag._short] = flag
					end
					if flag._long then
						_with_0[flag._long] = flag
					end
				end
				flag_map = _with_0
			end
			local curr_param = 1
			for i = 1, #args do
				local arg = args[i]
				if arg:sub(1, 1 == '-') then
					local flag = flag_map[arg]
					if not (flag ~= nil) then
						return nil, "unknown flag " .. tostring(arg)
					end
					if not flag._takes_param then
						ret[flag._name] = true
					else
						i = i + 1
						local flag_arg = arg[i]
						if not (flag_arg ~= nil) then
							return nil, "flag " .. tostring(arg) .. " expected an argument"
						end
						ret[flag._name] = flag_arg
					end
				else
					local param = self._params[curr_param]
					if not curr_param then
						return nil, "unexpected parameter " .. tostring(arg)
					end
					ret[param._name] = arg
					curr_param = curr_param + 1
				end
			end
			local _list_0 = self._flags
			for _index_0 = 1, #_list_0 do
				local flag = _list_0[_index_0]
				if flag._required and not ret[flag._name] then
					return nil, "flag " .. tostring(flag:_repr()) .. " required"
				end
			end
			local _list_1 = self._params
			for _index_0 = 1, #_list_1 do
				local param = _list_1[_index_0]
				if param._required and not ret[param._name] then
					return nil, "flag " .. tostring(param:_repr()) .. " required"
				end
			end
			if ret._help then
				self:_print_help()
			end
			return ret, nil
		end,
		_add_auto_args = function(self)
			if self._add_help then
				return self:add_flag((function()
					local _with_0 = Flag('help')
					_with_0:dest('_help')
					return _with_0
				end)())
			end
		end,
		_validate = function(self)
			local flag_tags
			do
				local _with_0 = { }
				local _list_0 = self._flags
				for _index_0 = 1, #_list_0 do
					local flag = _list_0[_index_0]
					if _with_0[flag._short] or _with_0[flag._long] then
						return "duplicate flag: " .. tostring(flag:_repr())
					end
					if flag._short then
						_with_0[flag._short] = true
					end
					if flag._long then
						_with_0[flag._long] = true
					end
				end
				flag_tags = _with_0
			end
			local arg_names
			do
				local _tbl_0 = { }
				local _list_0 = self._flags
				for _index_0 = 1, #_list_0 do
					local flag = _list_0[_index_0]
					_tbl_0[flag._name] = true
				end
				arg_names = _tbl_0
			end
			local _list_0 = self._params
			for _index_0 = 1, #_list_0 do
				local param = _list_0[_index_0]
				local name = param._name
				if (arg_names[name] ~= nil) then
					return "duplicate parameter name: " .. tostring(name)
				end
				arg_names[name] = true
			end
			return nil
		end,
		_print_help = function(self)
			print(table.concat((function()
				local _with_0 = {
					self._name,
					' '
				}
				local first_flag = true
				local _list_0 = self._flags
				for _index_0 = 1, #_list_0 do
					local flag = _list_0[_index_0]
					if not first_flag then
						_with_0[#_with_0 + 1] = ' '
					end
					first_flag = false
					if not flag._required then
						_with_0[#_with_0 + 1] = '['
					end
					_with_0[#_with_0 + 1] = flag._repr()
					if flag._takes_param then
						_with_0[#_with_0 + 1] = ' '
						_with_0[#_with_0 + 1] = flag._value_name
					end
					if not flag._required then
						_with_0[#_with_0 + 1] = ']'
					end
				end
				local _list_1 = self._params
				for _index_0 = 1, #_list_1 do
					local param = _list_1[_index_0]
					if not first_flag then
						_with_0[#_with_0 + 1] = ' '
					end
					local first_arg = false
					if not flag._required then
						_with_0[#_with_0 + 1] = '['
					end
					_with_0[#_with_0 + 1] = param._repr()
					if not flag._required then
						_with_0[#_with_0 + 1] = ']'
					end
				end
				return _with_0
			end)()))
			return os.exit(0)
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, _name)
			self._name = _name
			self._flags = { }
			self._params = { }
			self._add_help = true
			self._auto_args_added = false
		end,
		__base = _base_0,
		__name = "Args"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Args = _class_0
end
_module_0["Args"] = Args
do
	local _class_0
	local _base_0 = {
		dest = function(self, _name)
			self._name = _name
		end,
		short = function(self, _short)
			self._short = _short
		end,
		long = function(self, _long)
			self._long = _long
		end,
		required = function(self)
			self._required = true
		end,
		takes_param = function(self, _default)
			if _default == nil then
				_default = nil
			end
			self._default = _default
			self._takes_param = true
		end,
		value_name = function(self, _value_name)
			self._value_name = _value_name
		end,
		_repr = function(self)
			return self._short or self._long
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, _name)
			self._name = _name
			self._takes_param = false
			self._default = false
			self._value_name = 'value'
			self._short = '-' .. self._name:sub(1, 1)
			self._long = '--' .. self._name:gsub(' ', '-')
			self._required = false
		end,
		__base = _base_0,
		__name = "Flag"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Flag = _class_0
end
_module_0["Flag"] = Flag
do
	local _class_0
	local _base_0 = {
		arg_name = function(self, _arg_name)
			self._arg_name = _arg_name
		end,
		default = function(self, _default)
			self._default = _default
			self._required = false
		end,
		_repr = function(self)
			return self._arg_name or self._name
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, _name)
			self._name = _name
			self._arg_name = nil
			self._required = true
		end,
		__base = _base_0,
		__name = "Param"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Param = _class_0
end
_module_0["Param"] = Param
return _module_0
