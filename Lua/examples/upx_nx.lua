-- Simplified version using a special feature from the plugin

local mod = FindMainModule()
local sect = mod:FindSection("UPX0")

if( sect ) then
	-- Set BP
	SetNXBreakpoint(sect.Base)
	
	-- Run
	Continue()
	
	-- We should have reached the OEP.
	if( BYTE_PTR[EIP] == 0xE8 ) then
		MsgBox("Found OEP, you are free to dump the process", "Done")
	else
		MsgBox("Failed to find OEP")
	end
	
end