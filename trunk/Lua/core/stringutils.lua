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

function string.ltrim(str)
	while( str["1"] == ' ' ) do
		str = string.sub(str, 2)
	end
	return str
end

function string.rtrim(str)
	while( str[#str] == ' ' ) do
		str = string.sub(str, 1, #str-1)
	end
	return str
end

function string.trim(s)
	return s:match'^%s*(.*%S)' or ''
end

function string.hexdump(str, spacer)
	return (
		string.gsub(str,"(.)", function (c)
			return string.format("%02X%s",string.byte(c), spacer or "")
		end)
	)
end

function string.hex(n)
	return string.format("%08X", n)
end

function string.strpos(str, data, offset)
	local pattern = string.format("(%s)", data)
	local i = string.find (str, pattern, (offset or 0))
	return (i ~= nil and i or false)
end