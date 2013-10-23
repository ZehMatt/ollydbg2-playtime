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

-- Evil support for Unicode, it does the trick however.
function unichr(ord)
    if ord == nil then return nil end
    if ord < 32 then return string.format('\\x%02x', ord) end
    if ord < 126 then return string.char(ord) end
    if ord < 65539 then return string.format("\\u%04x", ord) end
    if ord < 1114111 then return string.format("\\u%08x", ord) end
end

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

-- TODO: Add support for Unicode, however keep in mind Lua has only 1 byte per character.
function WriteMemoryString(addr, str)
	WriteMemory(addr, str .. "\0")
end