local _module_0 = { }
local time_units, CARGO_INACTIVE_CONDITION, CARGO_INACTIVE_TIMEOUT, OVERALL_TIMEOUT
local Berth
do
	local _class_0
	local _base_0 = {
		name = function(self)
			return self.station.getStationName()
		end,
		train_present = function(self)
			return self.station:isTrainPresent()
		end,
		schedule = function(self, from_id, to_id, resource)
			local schedule = {
				cyclic = false,
				entries = {
					{
						instruction = {
							id = "create:rename",
							data = {
								text = ""
							}
						}
					},
					{
						instruction = {
							id = "create:destination",
							data = {
								text = from_id
							}
						},
						conditions = {
							{
								CARGO_INACTIVE_CONDITION,
								CARGO_INACTIVE_TIMEOUT
							},
							{
								OVERALL_TIMEOUT
							}
						}
					},
					{
						instruction = {
							id = "create:destination",
							data = {
								text = to_id
							}
						},
						conditions = {
							{
								CARGO_INACTIVE_CONDITION,
								CARGO_INACTIVE_TIMEOUT
							},
							{
								OVERALL_TIMEOUT
							}
						}
					},
					{
						instruction = {
							id = "create:rename",
							data = {
								text = "available train"
							}
						}
					}
				}
			}
xpcall(function()
				return self.station:setSchedule(schedule)
			end, function(err)
				return err
			end)
			return nil
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, station)
			self.station = station
		end,
		__base = _base_0,
		__name = "Berth"
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
	self.find_sole = function(self)
		local stations = {
			peripheral.find('Create_Station')
		}
		if #stations == 0 then
			error('could not find station')
		end
		if #stations > 1 then
			print('too many stations attached, taking first')
		end
		return Berth(stations[1])
	end
	Berth = _class_0
end
_module_0["Berth"] = Berth
time_units = {
	TICKS = 0,
	SECONDS = 1,
	MINUTES = 2
}
CARGO_INACTIVE_CONDITION = {
	id = "create:idle",
	data = {
		value = 5,
		time_unit = time_units.SECONDS
	}
}
CARGO_INACTIVE_TIMEOUT = {
	id = "create:delay",
	data = {
		value = 15,
		time_unit = time_units.SECONDS
	}
}
OVERALL_TIMEOUT = {
	id = "create:delay",
	data = {
		value = 30,
		time_unit = time_units.SECONDS
	}
}
return _module_0
