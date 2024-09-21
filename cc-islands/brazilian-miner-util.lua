local _module_0 = { }
local move_towards
move_towards = function(target, opts)
	if opts == nil then
		opts = { }
	end
	local resolution_order = opts[1]
	if resolution_order == nil then
		resolution_order = 'nearest'
	end
	if 'xyz' == resolution_order or 'xzy' == resolution_order or 'yxz' == resolution_order or 'yzx' == resolution_order or 'zxy' == resolution_order or 'zyx' == resolution_order then
		return move_towards_orthogonal(target, opts)
	elseif 'nearest' == resolution_order then
		return move_towards_direct(target, opts)
	else
		return error('unrecognised resolution order')
	end
end
_module_0["move_towards"] = move_towards
local move_towards_orthogonal
move_towards_orthogonal = function(target, opts)
	local height = opts[1]
	if height == nil then
		height = 2
	end
	return print('ortho', target, height, resolution_order)
end
move_towards_orthogonal = function(target, opts)
	local height = opts[1]
	if height == nil then
		height = 2
	end
	return print('direct', target, height, resolution_order)
end
return _module_0
