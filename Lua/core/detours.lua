--[[
@section Detours
@module Detours
@class
]]

module("Detours", package.seeall)

-- Table of detours.
local Detoured = {}

--[[
$Detours.Add
@desc Attempts to detour a function, it will call the second parameter which is supposed to return the bytecode for the detour.
@param number address The function to detour
@param function callback Called as soon the trampoline is ready, this should return the bytecode for the detour.
@param optional number detoursize The default size is 1024, if your function is bigger you should set this.
@return boolean success
$$
]]
function Add(address, fn, size)

	local detoursize = size or 1024
	
	-- First we allocate some memory.
	local ip = RemoteAlloc(detoursize, 0, PAGE_EXECUTE_READWRITE)
	if ip == NULL then
		error("Unable to allocate memory")
	end
	
	local trampoline = ip
	
	-- Now we prepare the trampoline
	local requiredsize = 5
	local trampolinesize = 0
	local backup = ""
	
	-- We have to move all instructions to the new allocated block.
	while( trampolinesize < requiredsize ) do
	
		local dip = address + trampolinesize
		local disasm = Disasm(dip, 16, dip)
		if( disasm ~= nil ) then
			trampolinesize = trampolinesize + disasm.Size
			backup = backup .. disasm.Result .. "\n"
		end
		
	end
	-- And finally the jump.
	backup = backup .. ";\njmp " .. string.hex(address + trampolinesize) .. "\n;"
	
	-- Generate code and copy.
	local trampolinecode = Assembler.Make(ip, backup)
	local backupcode = ReadMemory(address, trampolinesize)
	
	WriteMemory(ip, trampolinecode)
	
	-- Trampoline is before detour.
	local newip = ip + #trampolinecode
	
	-- Now we patch the addr
	local patch = Assembler.Make(address, "jmp " .. string.hex(newip))
	WriteMemory(address, patch)
	
	local detourcode, err = fn(newip, trampoline)
	if( not detourcode ) then
		if( _DEBUG ) then
			print("WARNING: Unable to detour, invalid code given")
		end
		return false, err
	end
	
	WriteMemory(newip, detourcode)
	
	Detoured[address] = {
		Address = address,
		Backup = backupcode,
		DetourBlock = ip,
		Size = detoursize,
	}
	
	return true
end

--[[
$Detours.Remove
@desc Removes a existing detoured function, restores the original data and deletes the trampoline.
@param number address Detoured function to restore.
@return boolean success
$$
]]
function Remove(address)
	
	local detour = Detoured[address]
	
	if( detour ) then
		-- Restore bytes.
		WriteMemory(detour.Address, detour.Backup)
		-- Remove detour memory.
		RemoteFreeEx(detour.DetourBlock, detour.Size, MEM_DECOMMIT)
		-- Remove from list
		Detoured[address] = nil
		
		return true
	end
	
	return false
end

return