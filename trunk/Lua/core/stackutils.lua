--[[
@section Stack
@module
@class
]]

--[[
$Pop
@desc Pops value from stack and returns it
@param optional boolean refresh Redraws CPU, by default its true
@return number value
$$
]]
function Pop(refresh)

	if refresh == nil then
		refresh = true
	end
	
	local val = DWORD_PTR[ESP]
	ESP = ESP + 4
	if refresh == true then
		SetCPU(0, 0, 0, 0, ESP, CPU_STACKFOCUS)
	end
	return val
	
end

--[[
$Push
@desc Pushes a value onto the stack
@param number value
@param optional boolean refresh Redraws CPU, by default its true
$$
]]
function Push(val, refresh)

	if refresh == nil then
		refresh = true
	end
	
	ESP = ESP - 4
	DWORD_PTR[ESP] = val
	if refresh == true then
		SetCPU(0, 0, 0, 0, ESP, CPU_STACKFOCUS)
	end
	
end