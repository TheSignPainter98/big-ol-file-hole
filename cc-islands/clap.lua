local _module_0 = { }
local unpack, EXIT, SELF
local Flag
local Param
local Subcommand
if unpack ~= nil then
	unpack = unpack
else
	unpack = table.unpack
end
EXIT = setmetatable({ }, {
	__tostring = function(self)
		return "<exit>"
	end
})
SELF = setmetatable({ }, {
	__tostring = function(self)
		return '<self>'
	end
})
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
		options = function(self, _options)
			self._options = _options
			return self
		end,
		transform = function(self, _transform)
			self._transform = _transform
			return self
		end,
		takes_param = function(self)
			self._takes_param = true
			return self
		end,
		default = function(self, _default)
			self._default = _default
			if 'boolean' == type(self._default) then
				error('boolean default flag arguments not currently supported')
			end
			self:takes_param()
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
				return " " .. tostring(self._short) .. ", " .. tostring(self._long)
			else
				if (self._short ~= nil) then
					return " " .. tostring(self._short)
				else
					return self._long
				end
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
			if #self._name > 1 then
				self._long = '--' .. self._name:gsub(' ', '-')
			else
				self._long = nil
			end
			self._required = false
			self._description = nil
			self._options = nil
			self._transform = nil
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
		options = function(self, _options)
			self._options = _options
			return self
		end,
		transform = function(self, _transform)
			self._transform = _transform
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
			self._options = nil
			self._transform = nil
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
do
	local _class_0
	local _base_0 = {
		dest = function(self, _dest)
			self._dest = _dest
			return self
		end,
		version = function(self, _version)
			self._version = _version
			return self
		end,
		add = function(self, arg)
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
			elseif 'Subcommand' == arg_type then
				do
					local _obj_0 = self._subcommands
					_obj_0[#_obj_0 + 1] = arg
				end
			else
				error("cannot use a " .. tostring(type(arg)) .. " as an arg")
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
		_parse = function(self, args, parents)
			if parents == nil then
				parents = { }
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
			local subcommand_map
			do
				local _tbl_0 = { }
				local _list_0 = self._subcommands
				for _index_0 = 1, #_list_0 do
					local sc = _list_0[_index_0]
					_tbl_0[sc._name] = sc
				end
				subcommand_map = _tbl_0
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
						do
							local transform = flag._transform
							if transform then
								local transformed, err = transform(flag_arg)
								if (err ~= nil) then
									return nil, "cannot parse '" .. tostring(flag_arg) .. "': " .. tostring(err)
								end
								ret[flag._name] = transformed
							else
								ret[flag._name] = flag_arg
							end
						end
					end
				else
					do
						local param = self._params[curr_param]
						if param then
							do
								local transform = param._transform
								if transform then
									local transformed, err = transform(arg)
									if (err ~= nil) then
										return nil, "failed to parse " .. tostring(arg) .. ": " .. tostring(err)
									end
									ret[param._name] = transformed
								else
									ret[param._name] = arg
								end
							end
							curr_param = curr_param + 1
						else
							do
								local command = subcommand_map[arg]
								if command then
									parents[#parents + 1] = self._name
									local subcommand_ret, err = command:_parse((function()
										local _accum_0 = { }
										local _len_0 = 1
										for _index_0 = i + 1, #args do
											local a = args[_index_0]
											_accum_0[_len_0] = a
											_len_0 = _len_0 + 1
										end
										return _accum_0
									end)(), parents)
									if (err ~= nil) then
										return nil, err
									end
									ret[command._dest] = subcommand_ret
									break
								else
									return nil, "unexpected argument '" .. tostring(arg) .. "'"
								end
							end
						end
					end
				end
			end
			if ret._usage then
				print(self:_usage_message(parents))
				return nil, EXIT
			end
			do
				local help = ret._help
				if help then
					if help == true then
						print(self:_help_message(parents))
						return nil, EXIT
					end
					if 'table' ~= type(help) then
						error("internal error: unexpected help type " .. tostring(type(help)))
					end
					if help.command == SELF then
						print(self:_help_message(parents))
						return nil, EXIT
					end
					do
						local sc = subcommand_map[help.command]
						if sc then
							print(sc:_help_message(parents))
							return nil, EXIT
						end
					end
					return nil, "no such subcommand '" .. tostring(help) .. "'"
				end
			end
			if ret._version then
				print(self:_version_message(parents))
				return nil, EXIT
			end
			local _list_0 = self._flags
			for _index_0 = 1, #_list_0 do
				local flag = _list_0[_index_0]
				do
					local arg = flag[flag._name]
					if not arg and flag._required then
						return nil, "flag '" .. tostring(flag:_repr()) .. "' required"
					end
					if arg and flag._options then
						local ok = false
						local _list_1 = flag._options
						for _index_1 = 1, #_list_1 do
							local option = _list_1[_index_1]
							if arg == option then
								ok = true
								break
							end
						end
						if not ok then
							return nil, "flag '" .. tostring(flag:_repr()) .. "' has incorrect value, got '" .. tostring(arg) .. "' but expected one of " .. tostring(table.concat(flag._options, ', '))
						end
					end
				end
			end
			local _list_1 = self._params
			for _index_0 = 1, #_list_1 do
				local param = _list_1[_index_0]
				do
					local arg = ret[param._name]
					if not arg and param._required then
						return nil, "argument '" .. tostring(param:_repr()) .. "' required"
					end
					if arg and param._options then
						local ok = false
						local _list_2 = param._options
						for _index_1 = 1, #_list_2 do
							local option = _list_2[_index_1]
							if arg == option then
								ok = true
								break
							end
						end
						if not ok then
							return nil, "argument '" .. tostring(param:_repr()) .. "' has incorrect value, got '" .. tostring(arg) .. " but expected one of " .. tostring(table.concat(param._options, ', '))
						end
					end
				end
			end
			if #self._subcommands > 0 then
				local command_specified = false
				local _list_2 = self._subcommands
				for _index_0 = 1, #_list_2 do
					local command = _list_2[_index_0]
					if (ret[command._dest] ~= nil) then
						command_specified = true
						break
					end
				end
				if not command_specified then
					return nil, "command required"
				end
			end
			return ret, nil
		end,
		_add_auto_args = function(self)
			if self._add_help then
				if #self._subcommands > 0 then
					self:add((function()
						local _with_0 = Subcommand('help')
						_with_0:dest('_help')
						_with_0:description('print help and exit')
						_with_0:add((function()
							local _with_1 = Param('command')
							_with_1:description('print help for the given command and exit')
							_with_1:default(SELF)
							return _with_1
						end)())
						return _with_0
					end)())
				else
					self:add((function()
						local _with_0 = Flag('help')
						_with_0:dest('_usage')
						_with_0:description('print usage and exit')
						_with_0:long(nil)
						return _with_0
					end)())
					self:add((function()
						local _with_0 = Flag('help')
						_with_0:dest('_help')
						_with_0:description('print help and exit')
						_with_0:short(nil)
						return _with_0
					end)())
				end
			end
			if (self._version ~= nil) then
				return self:add((function()
					local _with_0 = Flag('version')
					_with_0:dest('_version')
					_with_0:description('print version')
					_with_0:short(nil)
					return _with_0
				end)())
			end
		end,
		_validate_spec = function(self)
			if #self._params > 0 and #self._subcommands > 0 then
				return "cannot have both parameters and subcommands in command " .. tostring(self._name)
			end
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
				if arg_names[name] then
					return "duplicate parameter name: " .. tostring(name)
				end
				arg_names[name] = true
			end
			local _list_1 = self._subcommands
			for _index_0 = 1, #_list_1 do
				local subcommand = _list_1[_index_0]
				local name = subcommand._name
				if (arg_names[name] ~= nil) then
					return "duplicate subcommand name: " .. tostring(name)
				end
				arg_names[name] = true
				do
					local err = subcommand:_validate_spec()
					if err then
						return err
					end
				end
			end
			return nil
		end,
		_usage_message = function(self, parents)
			if parents == nil then
				parents = { }
			end
			local parents_repr
			if #parents > 0 then
				parents_repr = (table.concat(parents, ' ')) .. ' '
			else
				parents_repr = ''
			end
			return table.concat((function()
				local _with_0 = {
					'Usage: ',
					parents_repr,
					self._name,
					' '
				}
				local first_arg = true
				local _list_0 = self:_sorted_flags()
				for _index_0 = 1, #_list_0 do
					local flag = _list_0[_index_0]
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
				local _list_1 = self._params
				for _index_0 = 1, #_list_1 do
					local param = _list_1[_index_0]
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
				if #self._subcommands > 0 then
					if not first_arg then
						_with_0[#_with_0 + 1] = ' '
					end
					_with_0[#_with_0 + 1] = '<command>'
				end
				return _with_0
			end)())
		end,
		_help_message = function(self, parents)
			if parents == nil then
				parents = { }
			end
			local lines
			do
				local _with_0 = { }
				if (self._description ~= nil) then
					_with_0[#_with_0 + 1] = table.concat((function()
						local _with_1 = { }
						_with_1[#_with_1 + 1] = table.concat(parents, ' ')
						if #parents > 0 then
							_with_1[#_with_1 + 1] = ' '
						end
						_with_1[#_with_1 + 1] = tostring(self._name) .. " - " .. tostring(self._description)
						return _with_1
					end)())
				end
				_with_0[#_with_0 + 1] = ''
				_with_0[#_with_0 + 1] = self:_usage_message(parents)
				if #self._subcommands > 0 then
					_with_0[#_with_0 + 1] = ''
					_with_0[#_with_0 + 1] = 'Commands:'
					local longest_subommand_repr_len = math.max(unpack((function()
						local _accum_0 = { }
						local _len_0 = 1
						local _list_0 = self._subcommands
						for _index_0 = 1, #_list_0 do
							local sc = _list_0[_index_0]
							_accum_0[_len_0] = #sc:_repr()
							_len_0 = _len_0 + 1
						end
						return _accum_0
					end)()))
					local sorted_subcommands
					do
						local _accum_0 = { }
						local _len_0 = 1
						local _list_0 = self._subcommands
						for _index_0 = 1, #_list_0 do
							local sc = _list_0[_index_0]
							_accum_0[_len_0] = sc
							_len_0 = _len_0 + 1
						end
						sorted_subcommands = _accum_0
					end
					for _index_0 = 1, #sorted_subcommands do
						local subcommand = sorted_subcommands[_index_0]
						local repr = subcommand:_repr()
						do
							local description = subcommand._description
							if description then
								local padding = (' '):rep(longest_subommand_repr_len - #repr)
								_with_0[#_with_0 + 1] = "  " .. tostring(repr) .. tostring(padding) .. "  " .. tostring(description)
							else
								_with_0[#_with_0 + 1] = "  " .. tostring(repr)
							end
						end
					end
				end
				if #self._params > 0 then
					_with_0[#_with_0 + 1] = ''
					_with_0[#_with_0 + 1] = 'Arguments:'
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
						local repr = param:_repr()
						do
							local description = param._description
							if description then
								local padding = (' '):rep(longest_param_repr_len - #repr)
								_with_0[#_with_0 + 1] = " " .. tostring(repr) .. tostring(padding) .. "  " .. tostring(description)
							else
								_with_0[#_with_0 + 1] = " " .. tostring(repr)
							end
						end
					end
				end
				if #self._flags > 0 then
					_with_0[#_with_0 + 1] = ''
					_with_0[#_with_0 + 1] = 'Flags:'
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
					local _list_0 = self:_sorted_flags()
					for _index_0 = 1, #_list_0 do
						local flag = _list_0[_index_0]
						local repr = flag:_long_repr()
						do
							local description = flag._description
							if description then
								local padding = (' '):rep(longest_flag_repr_len - #repr)
								_with_0[#_with_0 + 1] = " " .. tostring(repr) .. tostring(padding) .. "  " .. tostring(description)
							else
								_with_0[#_with_0 + 1] = " " .. tostring(repr)
							end
						end
					end
				end
				lines = _with_0
			end
			return table.concat(lines, '\n')
		end,
		_sorted_flags = function(self)
			local ret
			do
				local _accum_0 = { }
				local _len_0 = 1
				local _list_0 = self._flags
				for _index_0 = 1, #_list_0 do
					local flag = _list_0[_index_0]
					_accum_0[_len_0] = flag
					_len_0 = _len_0 + 1
				end
				ret = _accum_0
			end
			table.sort(ret, function(flag1, flag2)
				local name1 = (flag1._short or flag1._long):match('[^-]+$')
				local name2 = (flag2._short or flag2._long):match('[^-]+$')
				return name1 < name2
			end)
			return ret
		end,
		_version_message = function(self, parents)
			if parents == nil then
				parents = { }
			end
			local parts
			do
				local _tab_0 = { }
				local _idx_0 = 1
				for _key_0, _value_0 in pairs(parents) do
					if _idx_0 == _key_0 then
						_tab_0[#_tab_0 + 1] = _value_0
						_idx_0 = _idx_0 + 1
					else
						_tab_0[_key_0] = _value_0
					end
				end
				_tab_0[#_tab_0 + 1] = self._name
				parts = _tab_0
			end
			if (self._version ~= nil) then
				parts[#parts + 1] = self._version
			end
			return table.concat(parts, ' ')
		end,
		_repr = function(self)
			return self._name
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, _name)
			self._name = _name
			self._dest = self._name
			self._version = nil
			self._flags = { }
			self._params = { }
			self._subcommands = { }
			self._add_help = true
			self._description = nil
			self._auto_args_added = false
		end,
		__base = _base_0,
		__name = "Subcommand"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Subcommand = _class_0
end
_module_0["Subcommand"] = Subcommand
local ArgParser
do
	local _class_0
	local _parent_0 = Subcommand
	local _base_0 = {
		parse = function(self, args)
			if not self._auto_args_added then
				self:_add_auto_args()
				local _list_0 = self._subcommands
				for _index_0 = 1, #_list_0 do
					local subcommand = _list_0[_index_0]
					subcommand:_add_auto_args()
				end
			end
			self._auto_args_added = true
			do
				local err = self:_validate_spec()
				if err then
					print(err)
					return nil, false
				end
			end
			local ret, err = self:_parse(args)
			if (err ~= nil) then
				if err == EXIT then
					return nil, false
				end
				print(err)
				print(self:_usage_message())
				return nil, false
			end
			return ret, true
		end
	}
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
		__init = function(self, _name)
			self._name = _name
			return _class_0.__parent.__init(self, self._name)
		end,
		__base = _base_0,
		__name = "ArgParser",
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
	ArgParser = _class_0
end
_module_0["ArgParser"] = ArgParser
return _module_0
