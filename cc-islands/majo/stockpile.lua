local _module_0 = { }
local Stockpile
do
	local _class_0
	local _base_0 = {
		level = function(self)
			local total_stored = 0
			local total_capacity = 0
			local size = self.inventory.size()
			for i, slot in pairs(self.inventory.list()) do
				total_stored = total_stored + slot.count
				total_capacity = total_capacity + self.inventory.getItemLimit(i)
			end
			if total_capacity == 0 then
				return 0
			end
			return total_stored / total_capacity
		end
	}
	if _base_0.__index == nil then
		_base_0.__index = _base_0
	end
	_class_0 = setmetatable({
		__init = function(self, inventory)
			self.inventory = inventory
		end,
		__base = _base_0,
		__name = "Stockpile"
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
		local inventories = {
			peripheral.find('inventory')
		}
		if #inventories == 0 then
			local error = 'could not find inventory'
		end
		if #inventories > 1 then
			print('too many inventories, taking first')
		end
		return Stockpile(inventories[1])
	end
	Stockpile = _class_0
end
_module_0["Stockpile"] = Stockpile
return _module_0
