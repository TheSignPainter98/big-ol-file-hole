local _module_0 = { }
local type, Vector, X2, Z2
do
	local old_type = _G.type
	type = function(obj)
		return ((function()
			local _obj_0 = getmetatable(obj)
			if _obj_0 ~= nil then
				local _obj_1 = _obj_0.__class
				if _obj_1 ~= nil then
					return _obj_1.__name
				end
				return nil
			end
			return nil
		end)()) or old_type(obj)
	end
end
local Matrix
do
	local _class_0
	local _base_0 = {
		to_vector_content = function(self)
			if not self:is_vector() then
				error("matrix rows must be tables or vectors")
			end
			local _accum_0 = { }
			local _len_0 = 1
			local _list_0 = self._rows
			for _index_0 = 1, #_list_0 do
				local row = _list_0[_index_0]
				_accum_0[_len_0] = row[1]
				_len_0 = _len_0 + 1
			end
			return _accum_0
		end,
		is_vector = function(self)
			return self.num_rows == 1
		end,
		x = function(self)
			if not self:is_vector() then
				error("can only get the X coordinate of 1xN matrices")
			end
			return self.to_vector_content[1]
		end,
		y = function(self)
			if not self:is_vector() then
				error("can only get the Y coordinate of 1xN matrices")
			end
			return self.to_vector_content[2]
		end,
		z = function(self)
			if not self:is_vector() then
				error("can only get the Z coordinate of 1xN matrices")
			end
			return self.to_vector_content[3]
		end,
		dot = function(self, other)
			if self.__class.__name ~= type(other) then
				error("cannot dot-product " .. tostring(type(self)) .. " with " .. tostring(type(other)))
			end
			if self.num_rows ~= 1 or other.num_rows ~= 1 then
				error("cannot dot-product matricies larger than 1xN")
			end
			if self.num_columns ~= other.num_columns then
				error("cannot dot-product different-dimension vectors")
			end
			local sum = 0
			for i = 1, self._dimension do
				sum = sum + (self._entries[i] * other._entries[i])
			end
			return sum
		end,
		vector_dim = function(self)
			if self.num_columns ~= 1 then
				error("cannot get length of matricies larger than 1xN")
			end
			return self.num_rows
		end,
		_dim_repr = function(self)
			return tostring(self.num_rows) .. "x" .. tostring(self.num_columns)
		end,
		__tostring = function(self)
			local vec_tostring
			vec_tostring = function(vec)
				return "[" .. tostring(table.concat((function()
					local _accum_0 = { }
					local _len_0 = 1
					for _index_0 = 1, #vec do
						local elem = vec[_index_0]
						_accum_0[_len_0] = tostring(elem)
						_len_0 = _len_0 + 1
					end
					return _accum_0
				end)(), ', ')) .. "]"
			end
			return "[\n\t" .. tostring(table.concat((function()
				local _accum_0 = { }
				local _len_0 = 1
				local _list_0 = self._rows
				for _index_0 = 1, #_list_0 do
					local entry = _list_0[_index_0]
					_accum_0[_len_0] = vec_tostring(entry)
					_len_0 = _len_0 + 1
				end
				return _accum_0
			end)(), ',\n\t')) .. ",\n]"
		end,
		__index = function(self, index)
			local mv = getmetatable(self)[index]
			if (mv ~= nil) then
				return mv
			end
			if 'number' ~= type(index) then
				error("cannot index " .. tostring(type(self)) .. " with " .. tostring(type(index)) .. " (got " .. tostring(index) .. ")")
			end
			return self._rows[index]
		end,
		__eq = function(self, other)
			if (type(self)) ~= type(other) then
				return false
			end
			if self.num_rows ~= other.num_rows or self.num_columns ~= other.num_columns then
				return false
			end
			for i = 1, self.num_rows do
				for j = 1, self.num_columns do
					if self[i][j] ~= other[i][j] then
						return false
					end
				end
			end
			return true
		end,
		__unm = function(self)
			return self * -1
		end,
		__add = function(self, other)
			if self.__class.__name ~= type(other) then
				error("cannot add " .. tostring(self.__class.__name) .. " and " .. tostring(type(other)))
			end
			if self.num_rows ~= other.num_rows or self.num_columns ~= other.num_columns then
				error("cannot add matricies with mismatched dimensions got " .. tostring(self:_dim_repr()) .. " and " .. tostring(other:_dim_repr()))
			end
			return Matrix((function()
				local _accum_0 = { }
				local _len_0 = 1
				for i = 1, self.num_rows do
					do
						local _accum_1 = { }
						local _len_1 = 1
						for j = 1, self.num_columns do
							_accum_1[_len_1] = self[i][j] + other[i][j]
							_len_1 = _len_1 + 1
						end
						_accum_0[_len_0] = _accum_1
					end
					_len_0 = _len_0 + 1
				end
				return _accum_0
			end)())
		end,
		__sub = function(self, other)
			if self.__class.__name ~= type(other) then
				error("cannot subtract " .. tostring(self.__class.__name) .. " and " .. tostring(type(other)))
			end
			if self.num_rows ~= other.num_rows or self.num_columns ~= other.num_columns then
				error("cannot subtract matricies with mismatched dimensions")
			end
			return Matrix((function()
				local _accum_0 = { }
				local _len_0 = 1
				for i = 1, self.num_rows do
					do
						local _accum_1 = { }
						local _len_1 = 1
						for j = 1, self.num_columns do
							_accum_1[_len_1] = self[i][j] - other[i][j]
							_len_1 = _len_1 + 1
						end
						_accum_0[_len_0] = _accum_1
					end
					_len_0 = _len_0 + 1
				end
				return _accum_0
			end)())
		end,
		__mul = function(self, other)
			local self_type = type(self)
			local other_type = type(other)
			if self_type == 'number' or other_type == 'number' then
				if self_type == 'number' then
					self, other = other, self
				end
				return Matrix((function()
					local _accum_0 = { }
					local _len_0 = 1
					local _list_0 = self._rows
					for _index_0 = 1, #_list_0 do
						local row = _list_0[_index_0]
						do
							local _accum_1 = { }
							local _len_1 = 1
							for _index_1 = 1, #row do
								local column_value = row[_index_1]
								_accum_1[_len_1] = column_value * other
								_len_1 = _len_1 + 1
							end
							_accum_0[_len_0] = _accum_1
						end
						_len_0 = _len_0 + 1
					end
					return _accum_0
				end)())
			end
			if self_type == 'Vector' then
				self = Matrix({
					self
				})
			else
				if other_type == 'Vector' then
					other = Matrix({
						other
					})
				end
			end
			if (type(self)) ~= self.__class.__name or (type(other)) ~= self.__class.__name then
				error("cannot multiply a " .. tostring(self_type) .. " by a " .. tostring(other_type))
			end
			local other_t = other:transpose()
			local dot
			dot = function(v1, v2)
				local sum = 0
				for i = 1, #v1 do
					sum = sum + (v1[i] * v2[i])
				end
				return sum
			end
			return Matrix((function()
				local _accum_0 = { }
				local _len_0 = 1
				for i = 1, self.num_columns do
					do
						local _accum_1 = { }
						local _len_1 = 1
						for j = 1, other_t.num_rows do
							_accum_1[_len_1] = dot(self[i], other_t[j])
							_len_1 = _len_1 + 1
						end
						_accum_0[_len_0] = _accum_1
					end
					_len_0 = _len_0 + 1
				end
				return _accum_0
			end)())
		end,
		transpose = function(self)
			return Matrix((function()
				local _accum_0 = { }
				local _len_0 = 1
				for j = 1, self.num_columns do
					do
						local _accum_1 = { }
						local _len_1 = 1
						for i = 1, self.num_rows do
							_accum_1[_len_1] = self._rows[i][j]
							_len_1 = _len_1 + 1
						end
						_accum_0[_len_0] = _accum_1
					end
					_len_0 = _len_0 + 1
				end
				return _accum_0
			end)())
		end,
		__div = function(self, other)
			if self.__class.__name ~= type(self) then
				error("cannot divide by " .. tostring(type(self)))
			end
			if 'number' ~= type(other) then
				error("cannot divide " .. tostring(type(self)) .. " by " .. tostring(type(other)))
			end
			return Matrix((function()
				local _accum_0 = { }
				local _len_0 = 1
				local _list_0 = self._rows
				for _index_0 = 1, #_list_0 do
					local row = _list_0[_index_0]
					do
						local _accum_1 = { }
						local _len_1 = 1
						for _index_1 = 1, #row do
							local column_value = row[_index_1]
							_accum_1[_len_1] = column_value / other
							_len_1 = _len_1 + 1
						end
						_accum_0[_len_0] = _accum_1
					end
					_len_0 = _len_0 + 1
				end
				return _accum_0
			end)())
		end,
		magnitude = function(self)
			if self.num_rows ~= 1 then
				error("can only get the magnitude of 1xN matricies, got " .. tostring(self:_dim_repr()))
			end
			local sum_of_squares = 0
			local _list_0 = self._rows[1]
			for _index_0 = 1, #_list_0 do
				local dim = _list_0[_index_0]
				sum_of_squares = sum_of_squares + (dim * dim)
			end
			return math.sqrt(sum_of_squares)
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, rows)
			if 'table' ~= type(rows) then
				error("expected table, got " .. tostring(type(rows)))
			end
			if #rows == 0 then
				error("cannot create matrix with no rows")
			end
			local num_columns
			local sanitised_rows
			do
				local _with_0 = { }
				for _index_0 = 1, #rows do
					local row = rows[_index_0]
					do
						local _exp_0 = type(row)
						if 'table' == _exp_0 then
							row = row
						elseif self.__class.__name == _exp_0 then
							row = row:to_vector_content()
						else
							row = error("expected table, got " .. tostring(type(row)))
						end
					end
					if not (num_columns ~= nil) then
						num_columns = #row
					else
						if #row ~= num_columns then
							error("expected row with " .. tostring(num_columns) .. " columns, but got " .. tostring(#row) .. " columns")
						end
					end
					_with_0[#_with_0 + 1] = row
				end
				sanitised_rows = _with_0
			end
			self._rows = sanitised_rows
			self.num_rows = #sanitised_rows
			self.num_columns = num_columns
		end,
		__base = _base_0,
		__name = "Matrix"
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
	self.Rotate2d = function(self, radians)
		return Matrix({
			{
				(math.cos(radians)),
				-math.sin(radians)
			},
			{
				(math.sin(radians)),
				math.cos(radians)
			}
		})
	end
	self.Diagonal = function(self, vector)
		vector = vector:to_vector_content()
		return Matrix((function()
			local _accum_0 = { }
			local _len_0 = 1
			for j = 1, #vector do
				do
					local _accum_1 = { }
					local _len_1 = 1
					for i = 1, #vector do
						_accum_1[_len_1] = ((function()
							if i == j then
								return vector[i]
							else
								return 0
							end
						end)())
						_len_1 = _len_1 + 1
					end
					_accum_0[_len_0] = _accum_1
				end
				_len_0 = _len_0 + 1
			end
			return _accum_0
		end)())
	end
	self.Identity = function(self, dim)
		return self:Diagonal(Vector((function()
			local _accum_0 = { }
			local _len_0 = 1
			for _ = 1, dim do
				_accum_0[_len_0] = 1
				_len_0 = _len_0 + 1
			end
			return _accum_0
		end)()))
	end
	Matrix = _class_0
end
_module_0["Matrix"] = Matrix
Vector = function(entries)
	return Matrix((function()
		local _accum_0 = { }
		local _len_0 = 1
		for _index_0 = 1, #entries do
			local entry = entries[_index_0]
			_accum_0[_len_0] = {
				entry
			}
			_len_0 = _len_0 + 1
		end
		return _accum_0
	end)())
end
_module_0["Vector"] = Vector
X2 = Vector({
	1,
	0
})
_module_0["X2"] = X2
Z2 = Vector({
	0,
	1
})
_module_0["Z2"] = Z2
return _module_0
