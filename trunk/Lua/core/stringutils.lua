--[[
@section String
@module
@class
]]

--[[
$string.split
@desc Splits a string into pieces.
@param string str Input string
@param string pattern Pattern to split
@return table pieces
$$
]]
function string.split(str, pat)
	local t = {} 
	local fpat = "(.-)" .. pat
	local last_end = 1
	local s, e, cap = str:find(fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(t,cap)
		end
		last_end = e+1
		s, e, cap = str:find(fpat, last_end)
	end
	if last_end <= #str then
		cap = str:sub(last_end)
		table.insert(t, cap)
	end
	return t
end

--[[
$string.ltrim
@desc Removes all whitespaces on the left side from the input string
@param string str Input string
@return string str
$$
]]
function string.ltrim(str)
	return string.match(str, "^%s*(.-)$")
end

--[[
$string.rtrim
@desc Removes all whitespaces on the right side from the input string
@param string str Input string
@return string str
$$
]]
function string.rtrim(str)
	return string.match(str, "^(.-)%s*$")
end

--[[
$string.trim
@desc Removes all whitespaces on the left and right side from the input string
@param string str Input string
@return string str
$$
]]
function string.trim(str)
	return string.match(str, "^%s*(.-)%s*$")
end

--[[
$string.hexdump
@desc Turns the input string into a binary string in the format of %02X
@param string str Input string
@param optional string spacer Space string for each byte, default is empty
@return string binary
$$
]]
function string.hexdump(str, spacer)
	return (
		string.gsub(str,"(.)", function (c)
			return string.format("%02X%s",string.byte(c), spacer or "")
		end)
	)
end

--[[
$string.hex
@desc Turns a value into a hex string, format is %08X
@param number input The input number
@return string hexval
$$
]]
function string.hex(n)
	return string.format("%08X", n)
end

--[[
$string.strpos
@desc Find the numeric position of the first occurrence of needle in the haystack string.
@param string haystack Input string
@param string needle Search string
@param optional number offset Starting offset
@return number pos
@remarks Returns false if nothing is found
$$
]]
function string.strpos(haystack, needle, offset)
	local pattern = string.format("(%s)", needle)
	local i = string.find (haystack, pattern, (offset or 0))
	return (i ~= nil and i or false)
end