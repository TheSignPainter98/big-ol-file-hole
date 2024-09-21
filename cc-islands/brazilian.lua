local verbose, main, Miku, alert, debug, must
local ArgParser, Flag, Param
do
	local _obj_0 = require('clap')
	ArgParser, Flag, Param = _obj_0.ArgParser, _obj_0.Flag, _obj_0.Param
end
local Vector
do
	local _obj_0 = require('linalg')
	Vector = _obj_0.Vector
end
verbose = false
main = function(args)
	local arg_parser
	do
		local _with_0 = ArgParser('brazilian')
		_with_0:version('0.1')
		_with_0:description('the sequel to miku miner, always trying to escape')
		_with_0:add((function()
			local _with_1 = Flag('verbose')
			_with_1:description('output verbosely')
			return _with_1
		end)())
		_with_0:add((function()
			local _with_1 = Param('pattern')
			_with_1:arg_name('file')
			_with_1:description('Lua mining pattern script')
			return _with_1
		end)())
		arg_parser = _with_0
	end
	local ok
	args, ok = arg_parser:parse(args)
	if not ok then
		return
	end
	verbose = args.verbose
	local pattern = require(args.pattern)
	if 'table' ~= type(pattern) then
		error(tostring(args.pattern) .. " must return a table (got " .. tostring(type(pattern)) .. ")")
	end
	local waypoints
	do
		local _obj_0 = require(args.pattern)
		waypoints = _obj_0.waypoints
	end
	if not (waypoints ~= nil) then
		error(tostring(args.pattern) .. " does have waypoints field")
	end
	local _with_0 = Miku()
	_with_0:run(waypoints)
	return _with_0
end
do
	local _class_0
	local _base_0 = {
		run = function(self, waypoints)
			print('starting sequence')
			for waypoint in waypoints(self) do
				print("got waypoint " .. tostring(waypoint))
				while self:approach(waypoint) do
					debug("approaching " .. tostring(waypoint))
				end
			end
			return print('end of waypoints.')
		end,
		approach = function(self, waypoint)
			local approach_dim, approach_sign
			do
				local delta = waypoint - self.current_position
				if delta:magnitude() == 0 then
					return false
				end
				local deltas = {
					{
						'x',
						delta:x()
					},
					{
						'y',
						delta:y()
					},
					{
						'z',
						delta:z()
					}
				}
				approach_dim = nil
				local max_dim_delta = 0
				for _index_0 = 1, #deltas do
					local _des_0 = deltas[_index_0]
					local dim, dim_delta = _des_0[1], _des_0[2]
					if max_dim_delta < dim_delta then
						max_dim_delta = dim_delta
						approach_dim = dim
					end
				end
				approach_sign = max_dim_delta / math.abs(max_dim_delta)
				approach_dim, approach_sign = approach_dim, approach_sign
			end
			if approach_dim == 'y' then
				if approach_sign > 0 then
					self:move_up()
				else
					self:move_down()
				end
				return true
			end
			local approach_vec, other_vec
			if 'x' == approach_dim then
				approach_vec, other_vec = linalg.X2, linalg.Z2
			elseif 'z' == approach_dim then
				approach_vec, other_vec = linalg.Z2, linalg.X2
			else
				approach_vec, other_vec = error("invalid horizontal approach dimension " .. tostring(dim))
			end
			local approach_vec_dot = self.current_direction:dot(approach_vec)
			if approach_vec_dot < 0 then
				self:turn_left()
				self:turn_left()
			end
			if approach_vec_dot == 0 then
				local other_vec_dot = self.current_direction:dot(other_vec)
				if other_vec_dot < 0 then
					self:turn_left()
				else
					self:turn_right()
				end
			end
			self:move_ahead()
			return true
		end,
		move_up = function(self)
			must('dig up', turtle.digUp)
			must('move up', turtle.up)
			self.current_position = self.current_position + Vector({
				0,
				1,
				0
			})
		end,
		move_down = function(self)
			must('dig down', turtle.digDown)
			must('move down', turtle.down)
			self.current_position = self.current_position + Vector({
				0,
				-1,
				0
			})
		end,
		move_ahead = function(self)
			must('dig ahead', turtle.dig)
			must('move ahead', turtle.forward)
			local dx, dz
			do
				local _obj_0 = self.current_direction:to_vector_content()
				dx, dz = _obj_0[1], _obj_0[2]
			end
			self.current_position = self.current_position + Vector({
				dx,
				0,
				dz
			})
		end,
		turn_left = function(self)
			must('turn left', turtle.turnLeft)
			local rotation = Matrix({
				{
					0,
					1
				},
				{
					-1,
					0
				}
			})
			self.current_direction = rotation * self.current_direction
		end,
		turn_right = function(self)
			must('turn left', turtle.turnLeft)
			local rotation = Matrix({
				{
					0,
					-1
				},
				{
					1,
					0
				}
			})
			self.current_direction = rotation * self.current_direction
		end,
		fuel_low = function(self)
			local fuel_level = turtle.getFuelLevel()
			local fuel_limit = turtle.getFuelLimit()
			return fuel_level / fuel_limit <= 0.2
		end,
		consume_fuel = function(self)
			local prev_selected = turtle.getSelectedSlot()
			local success = false
			for i = 1, self.inv_size do
				turtle.select(i)
				if turtle.refuel() then
					success = true
					break
				end
			end
			turtle.select(prev_selected)
			return success
		end,
		store_items = function(self)
			local prev_selected = turtle.getSelectedSlot()
			local RESERVE_FUEL_SLOT = 1
			if not self:has_fuel_at(RESERVE_FUEL_SLOT) then
				for i = 2, self.inv_size do
					if self:has_fuel_at(i) then
						turtle.select(i)
						turtle.transferTo(RESERVE_FUEL_SLOT)
						break
					end
				end
			end
			if self:fuel_low() then
				if not self:consume_fuel() then
					alert("I'm so hungry...")
				end
			end
			for i = 2, self.inv_size do
				turtle.select(i)
				turtle.dropDown()
			end
			return turtle.select(prev_selected)
		end,
		has_fuel_at = function(self, slot_index)
			local details = turtle.getItemDetail(slot_index)
			error(table.concat((function()
				local _accum_0 = { }
				local _len_0 = 1
				for key, _ in pairs(details) do
					_accum_0[_len_0] = key
					_len_0 = _len_0 + 1
				end
				return _accum_0
			end)()))
			return true
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, opts)
			if opts == nil then
				opts = { }
			end
			do
				local _tmp_0, _tmp_1, _tmp_2 = opts.inv_size, opts.current_position, opts.current_direction
				if _tmp_0 == nil then
					_tmp_0 = 16
				end
				if _tmp_1 == nil then
					_tmp_1 = Vector({
						0,
						0,
						0
					})
				end
				if _tmp_2 == nil then
					_tmp_2 = Vector({
						1,
						0
					})
				end
				self.inv_size = _tmp_0
				self.current_position = _tmp_1
				self.current_direction = _tmp_2
			end
		end,
		__base = _base_0,
		__name = "Miku"
	}, {
		__index = _base_0,
		__call = function(cls, ...)
			local _self_0 = setmetatable({ }, _base_0)
			cls.__init(_self_0, ...)
			return _self_0
		end
	})
	_base_0.__class = _class_0
	Miku = _class_0
end
alert = function(...)
	local message = table.concat({
		...
	}, ' ')
	return print("ALERT: " .. tostring(message))
end
debug = function(...)
	if not verbose then
		return
	end
	return print(table.concat({
		...
	}, ' '))
end
must = function(name, action)
	if not action() then
		return error("cannot " .. tostring(name))
	end
end
return main({
	...
})
