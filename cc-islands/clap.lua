local _module_0 = { }
local EXIT, HELP, USAGE, VERSION
local Flag
local Param
EXIT = setmetatable({ }, {
	__tostring = function(self)
		return "exit"
	end
})
HELP = setmetatable({ }, {
	__tostring = function(self)
		return "show help"
	end
})
USAGE = setmetatable({ }, {
	__tostring = function(self)
		return "show usage"
	end
})
VERSION = setmetatable({ }, {
	__tostring = function(self)
		return "show version"
	end
})
local ArgParser
do
	local _class_0
	local _base_0 = {
		version = function(self, _version)
			self._version = _version
			return self
		end,
		add_arg = function(self, arg)
			local arg_type
			do
				local _obj_0 = getmetatable(arg)
				if _obj_0 ~= nil then
					do
						local _obj_1 = _obj_0.__class
						if _obj_1 ~= nil then
							arg_type = _obj_1.__name
						end
					end
				end
			end
			if 'Flag' == arg_type then
				do
					local _obj_0 = self._flags
					_obj_0[#_obj_0 + 1] = arg
				end
			elseif 'Param' == arg_type then
				do
					local _obj_0 = self._params
					_obj_0[#_obj_0 + 1] = arg
				end
			else
				error("cannot use a " .. tostring(type(arg)) .. " as an arg")
			end
			return self
		end,
		add_param = function(self, param)
			local param_type = getmetatable(param).__class.__name
			if param_type ~= 'Param' then
				error("expected Param, got a " .. tostring((function()
					if param_type ~= nil then
						return param_type
					else
						return type(param)
					end
				end)()))
			end
			do
				local _obj_0 = self._params
				_obj_0[#_obj_0 + 1] = param
			end
			return self
		end,
		no_help = function(self)
			self._add_help = false
			return self
		end,
		description = function(self, _description)
			self._description = _description
			return self
		end,
		parse = function(self, args)
			local ret, err = self:_parse(args)
			if (err ~= nil) then
				if USAGE == err then
					print(self:_usage_message())
				elseif HELP == err then
					print(self:_help_message())
				elseif VERSION == err then
					print(self:_version_message())
				else
					print(err)
					print(self:_usage_message())
				end
				return nil, false
			end
			return ret, true
		end,
		_parse = function(self, args)
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
			local i = 0
			while i < #args do
				i = i + 1
				local arg = args[i]
				if '-' == arg:sub(1, 1) then
					local flag = flag_map[arg]
					if not (flag ~= nil) then
						return nil, "unknown flag " .. tostring(arg)
					end
					if not flag._takes_param then
						ret[flag._name] = true
					else
						i = i + 1
						local flag_arg = args[i]
						if not (flag_arg ~= nil) then
							return nil, "flag " .. tostring(arg) .. " expected an argument"
						end
						ret[flag._name] = flag_arg
					end
				else
					local param = self._params[curr_param]
					if not param then
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
			if ret._usage then
				return nil, USAGE
			end
			if ret._help then
				return nil, HELP
			end
			if ret._version then
				return nil, VERSION
			end
			return ret, nil
		end,
		_add_auto_args = function(self)
			if self._add_help then
				self:add_arg((function()
					local _with_0 = Flag('help')
					_with_0:dest('_usage')
					_with_0:description('print short help')
					_with_0:long(nil)
					return _with_0
				end)())
				self:add_arg((function()
					local _with_0 = Flag('help')
					_with_0:dest('_help')
					_with_0:description('print long help')
					_with_0:short(nil)
					return _with_0
				end)())
			end
			if (self._version ~= nil) then
				return self:add_arg((function()
					local _with_0 = Flag('version')
					_with_0:dest('_version')
					_with_0:description('print version')
					_with_0:short(nil)
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
		_usage_message = function(self)
			return table.concat((function()
				local _with_0 = {
					'Usage: ',
					self._name,
					' '
				}
				local flags
				do
					local _accum_0 = { }
					local _len_0 = 1
					local _list_0 = self._flags
					for _index_0 = 1, #_list_0 do
						local flag = _list_0[_index_0]
						_accum_0[_len_0] = flag
						_len_0 = _len_0 + 1
					end
					flags = _accum_0
				end
				table.sort(flags, function(flag_1, flag_2)
					return flag_1._name <= flag_2._name
				end)
				local first_arg = true
				for _index_0 = 1, #flags do
					local flag = flags[_index_0]
					if not first_arg then
						_with_0[#_with_0 + 1] = ' '
					end
					first_arg = false
					if not flag._required then
						_with_0[#_with_0 + 1] = '['
					end
					_with_0[#_with_0 + 1] = flag:_repr()
					if flag._takes_param then
						_with_0[#_with_0 + 1] = ' '
						_with_0[#_with_0 + 1] = flag._value_name
					end
					if not flag._required then
						_with_0[#_with_0 + 1] = ']'
					end
				end
				local _list_0 = self._params
				for _index_0 = 1, #_list_0 do
					local param = _list_0[_index_0]
					if not first_arg then
						_with_0[#_with_0 + 1] = ' '
					end
					first_arg = false
					if not param._required then
						_with_0[#_with_0 + 1] = '['
					end
					_with_0[#_with_0 + 1] = param:_repr()
					if not param._required then
						_with_0[#_with_0 + 1] = ']'
					end
				end
				return _with_0
			end)())
		end,
		_help_message = function(self)
			local usage_message = self:_usage_message()
			local lines
			do
				local _with_0 = { }
				if (self._description ~= nil) then
					_with_0[#_with_0 + 1] = tostring(self._name) .. " - " .. tostring(self._description)
				end
				_with_0[#_with_0 + 1] = ''
				_with_0[#_with_0 + 1] = self:_usage_message()
				if #self._params > 0 then
					_with_0[#_with_0 + 1] = ''
					_with_0[#_with_0 + 1] = 'Parameters'
					local longest_param_repr_len = math.max(unpack((function()
						local _accum_0 = { }
						local _len_0 = 1
						local _list_0 = self._params
						for _index_0 = 1, #_list_0 do
							local p = _list_0[_index_0]
							_accum_0[_len_0] = #p:_repr()
							_len_0 = _len_0 + 1
						end
						return _accum_0
					end)()))
					local _list_0 = self._params
					for _index_0 = 1, #_list_0 do
						local param = _list_0[_index_0]
						do
							local description = param._description
							if description then
								local repr = param:_repr()
								local padding = (' '):rep(longest_param_repr_len - #repr)
								_with_0[#_with_0 + 1] = tostring(repr) .. tostring(padding) .. " " .. tostring(description)
							else
								_with_0[#_with_0 + 1] = param:_repr()
							end
						end
					end
				end
				if #self._flags > 0 then
					_with_0[#_with_0 + 1] = ''
					_with_0[#_with_0 + 1] = 'Flags'
					local longest_flag_repr_len = math.max(unpack((function()
						local _accum_0 = { }
						local _len_0 = 1
						local _list_0 = self._flags
						for _index_0 = 1, #_list_0 do
							local p = _list_0[_index_0]
							_accum_0[_len_0] = #p:_long_repr()
							_len_0 = _len_0 + 1
						end
						return _accum_0
					end)()))
					local _list_0 = self._flags
					for _index_0 = 1, #_list_0 do
						local flag = _list_0[_index_0]
						do
							local description = flag._description
							if description then
								local repr = flag:_long_repr()
								local padding = (' '):rep(longest_flag_repr_len - #repr)
								_with_0[#_with_0 + 1] = tostring(repr) .. tostring(padding) .. " " .. tostring(description)
							else
								_with_0[#_with_0 + 1] = flag:_long_repr()
							end
						end
					end
				end
				lines = _with_0
			end
			return table.concat(lines, '\n')
		end,
		_version_message = function(self)
			local parts = {
				self._name
			}
			if (self._version ~= nil) then
				parts[#parts + 1] = self._version
			end
			return table.concat(parts, ' ')
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, _name)
			self._name = _name
			self._version = nil
			self._flags = { }
			self._params = { }
			self._add_help = true
			self._description = nil
			self._auto_args_added = false
		end,
		__base = _base_0,
		__name = "ArgParser"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	ArgParser = _class_0
end
_module_0["ArgParser"] = ArgParser
do
	local _class_0
	local _base_0 = {
		dest = function(self, _name)
			self._name = _name
			return self
		end,
		short = function(self, _short)
			self._short = _short
			return self
		end,
		long = function(self, _long)
			self._long = _long
			return self
		end,
		required = function(self)
			self._required = true
			return self
		end,
		description = function(self, _description)
			self._description = _description
			return self
		end,
		takes_param = function(self, _default)
			if _default == nil then
				_default = nil
			end
			self._default = _default
			self._takes_param = true
			return self
		end,
		value_name = function(self, _value_name)
			self._value_name = _value_name
			return self
		end,
		_repr = function(self)
			return self._short or self._long
		end,
		_long_repr = function(self)
			if (self._short ~= nil) and (self._long ~= nil) then
				return tostring(self._short) .. ", " .. tostring(self._long)
			else
				return self:_repr()
			end
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
			self._description = nil
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
			return self
		end,
		default = function(self, _default)
			self._default = _default
			self._required = false
			return self
		end,
		description = function(self, _description)
			self._description = _description
			return self
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
			self._description = nil
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
