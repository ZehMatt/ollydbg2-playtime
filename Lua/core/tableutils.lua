--[[
$table.copy
@desc Returns a copy of another table.
@param table thetable Table to copy
@return table copy
$$
]]
function table.copy(t)
	local t2 = {}
	for k,v in pairs(t) do
		t2[k] = v
	end
	return t2
end


--[[
$table.print
@desc Prints all contents of a table.
@param table thetable Table to print
@return table copy
$$
]]
function table.print(t, usehex, indent, done, nonentry)

	nonentry = nonentry or false
	usehex = usehex or false
	indent = indent or ""
	done = done or  {}
	if( done[t] ) then
		return
	end
	
	local prev = indent
	local key = ""
	print(indent .. "{")
	indent = indent .. "    "
	
	for k,v in pairs(t) do
		if( type(k) == "string" ) then
			key = "[\"" .. k .. "\"]"
		elseif( type(k) == "number" ) then
			key = tostring(k)
		end
		if( type(v) == "table" ) then
			print(indent .. key .. " = ")
			table.print(v, usehex, indent, done, true)
			done[v] = true
		else
			if( type(v) == "string" ) then
				print(indent .. key .. " = \"" .. v .. "\",")
			elseif( type(v) == "number" ) then
				if usehex == true then
					print(indent .. key .. " = " .. string.format("%08X",v) .. ",")
				else
					print(indent .. key .. " = " .. tostring(v) .. ",")
				end
			elseif( type(v) == "boolean" ) then
				print(indent .. key .. " = " .. tostring(v) .. ",")
			end
		end
	end
	
	print(prev .. "}" .. (nonentry and "," or ""))
	
end

--[[
$table.hasvalue
@desc Checks if the table has the given value.
@param table thetable The table to search
@param any value The value to search.
@return boolean hasvalue
$$
]]
function table.hasvalue(t, val)
	for _,v in pairs(t) do
		if v == val then
			return true
		end
	end
	return false
end