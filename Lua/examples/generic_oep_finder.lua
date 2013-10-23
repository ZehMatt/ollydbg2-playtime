-- Sections where the real OEP is.
local OEPSections = {"text", "upx0"}

-- Lookup function.
local function FindOEPSection()
	local mod = FindMainModule()
	if( mod == nil ) then
		return nil
	end
	for k,v in pairs(OEPSections) do
		local sect = mod:FindSection(v)
		if( sect ) then
			return sect
		end
	end
	return nil
end

-- Find one of the known sections.
local sect = FindOEPSection()

if( sect ) then
	print("Found section '" .. sect.Name .. "', setting NX Breakpoint.")
	
	-- Set BP
	SetNXBreakpoint(sect.Base)
	
	-- Run
	Continue()
	
	-- We should have reached the OEP.
	MsgBox("Found possible OEP.")
else
	MsgBox("Found no section where the OEP could be at.")
end