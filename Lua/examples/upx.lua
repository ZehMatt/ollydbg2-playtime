-- OllyDbg UPX Unpacking Script
-- Achieved with Lua
-- Manual steps.

-- Step over pushad
StepIn()

local Slot = FindFreeHardBreakSlot()

-- Hardware BP on ESP
if( SetHardBreakpoint(Slot, ESP, 4, BP_MANUAL + BP_READ + BP_WRITE + BP_BREAK) ) then
	print("Set hardware breakpoint")
end

-- Run for ESP read
Continue()

-- Remove HW BP
RemoveHardBreakpoint(Slot)

-- Find Jump
local pos = FindMemory(EIP, "83EC??E9")
print("Jump Location", pos)

if( pos ~= 0 ) then
	
	-- Breakpoint at JMP
	SetInt3Breakpoint(pos + 3, BP_ONESHOT + BP_SET + BP_BREAK)
	
	-- Reach breakpoint
	Continue()
	
	-- Get into JMP
	StepIn()
	
	-- Determine if the current instruction is a call
	if( BYTE_PTR[EIP] ~= 0xE8 ) then
		MsgBox("Script probably failed", "Error")
	else
		MsgBox("You should be now at the OEP, dump the process", "Done")
	end
	
end

