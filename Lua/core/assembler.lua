module("assembler", package.seeall)

local function isJumpCommand(cmd)
	return cmd == "jo" or cmd == "jno" or cmd == "jb" or cmd == "jnae"
		or cmd == "jc" or cmd == "jnb" or cmd == "jae" or cmd == "jnc"
		or cmd == "jz" or cmd == "je" or cmd == "jnz" or cmd == "jne"
		or cmd == "jbe" or cmd == "jna" or cmd == "jnbe" or cmd == "ja"
		or cmd == "js" or cmd == "jns" or cmd == "jp" or cmd == "jpe"
		or cmd == "jnp" or cmd == "jpo" or cmd == "jl" or cmd == "jnge"
		or cmd == "jnl" or cmd == "jge" or cmd == "jle" or cmd == "jng"
		or cmd == "jnle" or cmd == "jg" or cmd == "jmp"
end

local function fixLeftOperands(left)

	local str = string.trim(string.lower(left))	
	
	local pos = string.strpos(str, " ")
	if( pos ) then
		local cmd = string.sub(str, 1, pos - 1)
		local right = string.sub(str, pos)
		if( isJumpCommand(cmd) ) then
			return cmd .. " long "
		end
	else
		local cmd = str
		if( isJumpCommand(cmd) ) then
			return cmd .. " long "
		end
	end
	
	return left
	
end

local function fixShortJump(instruction)

	local p = string.strpos(instruction:lower(), " short")
	if( p ) then
		local left = string.sub(instruction, 1, p)
		local right = string.sub(instruction, p + 6)
		return left .. " long" .. right
	end
	
	return instruction
end

local function processInstruction(ip, labels, str)

	str = fixShortJump(str)
	
	local reloc = false
	local pos = string.strpos(str, "$")
	
	if pos then		
	
		local left = string.sub(str, 1, pos - 1)		
		local lbl = string.sub(str, pos + 1)
		local a = string.strpos(lbl, ']')
		local b = string.strpos(lbl, ',')
		local c = string.strpos(lbl, ' ')
		local pos = a;
		
		if( pos and b and b < pos ) then
			pos = b
		end
		if( pos and c and c < pos ) then
			pos = c
		end
		
		local right = ""
		
		if( pos and pos > 0 ) then
			right = string.sub(lbl, pos)
			lbl = string.trim(string.sub(lbl, 1, pos - 1))
		end
		
		-- Ensure everything is using long addresses.
		left = fixLeftOperands(left)
				
		local label = labels[lbl]
		if( label and label.offset ~= -1 ) then
			-- Bound label.
			str = left .. string.hex(label.ip) .. right
		elseif( label and label.offset == -1 ) then
			-- Unbound label.
			str = left .. string.hex(0) .. right
			reloc = true
		end
		
	end
	
	return str, reloc
end

--[[
$assembler.Make
@desc This is a little wrapper for the Assemble function, it supports multiple commands, labels and comments.
@param number ip Where to relocate the code
@param string code The code to assemble, to define a label you must use '@labelname:', to use a label use '$labelname'
@return string bytecode
@return string error
@remarks Do not forget that OllyDbg accepts only hex, so if you want to pass numbers in code make use of string.hex in utils.lua, consider defining _DEBUG for extended error reporting.
$$
]]
function Make(ip, code)

	local labels = {}
	local relocs = {}
	local instructions = {}
	
	-- We attach a newline making sure that when a single instruction is given it will still split it.
	local parsed = string.split(code .. "\n", "\n")
	local offset = 0;
	
	-- We have to scan the label names first.
	for k,v in pairs(parsed) do
		v = string.trim(v)

		local n = string.strpos(v, ";")
		if( n ) then
			v = string.sub(v, 1, n - 1)
			parsed[k] = string.trim(v)
		end

		if( string.sub(v, 1, 1) == '@' ) then
			local labelname = string.sub(v, 2)
			local label = {offset = -1, index = -1, ip = -1}
			local labelend = string.strpos(labelname, ":")
			if( labelend ) then
				labelname = string.sub(labelname, 1, labelend - 1)
			end
			labels[labelname] = label
		end
		
	end
	
	-- Now we can compute instructions.	
	for k, v in pairs(parsed) do
	
		v = string.trim(v)
		local curip = ip + offset
		
		if( string.sub(v, 1, 1) == '@' ) then
		
			-- Bind label to current offset.
			local labelname = string.trim(string.sub(v, 2))
			local labelend = string.strpos(labelname, ":")
			if( labelend ) then
				labelname = string.sub(labelname, 1, labelend - 1)
			end
			
			local label = labels[labelname]
			label.offset = offset
			label.index = #instructions
			label.ip = ip + offset
			labels[labelname] = label
			
		elseif( #v > 0 ) then
		
			-- Emit instruction.
			local fixed, reloc = processInstruction(ip, labels, v)
			local code, err = Assemble(fixed, curip)
			local index = #instructions + 1
			if( code ) then
				offset = offset + #code
			else
				-- Failed to assemble.
				if( _DEBUG ) then
					print("Assembler Error '" .. fixed .. "': " .. err)
					print("Dump:")
					for k,v in pairs(parsed) do
						print("\t" .. v)
					end
					local func = debug.getinfo(2)
					print(func.source..":"..func.currentline)
				end
				return nil, err
			end
			
			if( reloc ) then
				table.insert(relocs, index)
			end
			table.insert(instructions, {src = v, data = code, ip = curip, reloc = reloc, real = fixed})
			
		end
	end
	
	-- All labels should be bound by now.
	for k,v in pairs(relocs) do
		local instruction = instructions[v]
		local fixed, reloc = processInstruction(instruction.ip, labels, instruction.src)
		local code, err = Assemble(fixed, instruction.ip)
		if( code == nil ) then
			-- Failed to assemble.
			if( _DEBUG ) then
				print("Assembler Error '" .. fixed .. "': " .. err)
				print("Dump:")
				for k,v in pairs(parsed) do
					print("\t" .. v)
				end
				local func = debug.getinfo(2)
				print(func.source..":"..func.currentline)
			end
			return nil, err
		else
			instruction.data = code
			instruction.reloc = false
			instruction.real = fixed
			
			instructions[v] = instruction
		end
	end
	
	local code = ""
	
	for k,v in pairs(instructions) do
		code = code .. v.data
	end
	
	return code;
end

return