--[[
@section Memory
@module
@class
]]

-- Evil support for Unicode, it does the trick however.
local function unichr(ord)
    if ord == nil then return nil end
    if ord < 32 then return string.format('\\x%02x', ord) end
    if ord < 126 then return string.char(ord) end
    if ord < 65539 then return string.format("\\u%04x", ord) end
    if ord < 1114111 then return string.format("\\u%08x", ord) end
end

--[[
$ReadMemoryString
@desc Attempts to read a multibyte string from given memory address.
@param number address Address where to read the string.
@param optional boolean removeint3breakpoints Removes temporarily breakpoints at the address reading.
@return string str
$$
]]
function ReadMemoryString(addr, removeint3breakpoints)	
	local res = ""
	local c = 0
	local i = 0
	
	repeat
		c = ReadMemoryUChar(addr + i, removeint3breakpoints or true)
		if c == nil then return nil end
		if c ~= 0 then
			res = res .. string.char(c)
		end
		i = i + 1
	until c == 0
	
	return res
end

--[[
$ReadMemoryUnicodeString
@desc Attempts to read a unicode string from given memory address.
@param number address Address where to read the string.
@param optional boolean removeint3breakpoints Removes temporarily breakpoints at the address reading.
@return string str
@remarks This function reads UTF16 which means each character is 2 bytes big.
$$
]]
function ReadMemoryUnicodeString(addr, removeint3breakpoints)	
	local res = ""
	local c = 0
	local i = 0
	
	repeat
		c = ReadMemoryUShort(addr + i, removeint3breakpoints or true)
		if c == nil then return nil end
		if c ~= 0 then
			res = res .. unichr(c)
		end
		i = i + 2
	until c == 0
	
	return res
end

--[[
$WriteMemoryString
@desc Writes a multibyte string to the given memory address including the null terminator.
@param number address Address where to read the string.
@param string str String to write
@return number written
$$
]]
function WriteMemoryString(addr, str)
	return WriteMemory(addr, str .. "\0")
end