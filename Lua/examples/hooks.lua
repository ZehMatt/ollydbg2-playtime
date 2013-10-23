-- Experimental, consider using detours

module("hook", package.seeall)

function Add(addr, cb)

	-- Set breakpoint.
	SetInt3Breakpoint(addr, BP_MANUAL + BP_SET + BP_BREAK)
	
	-- Listen to event.
	return Event.Listen("Int3Breakpoint", function(data)
		if( data.Address == addr ) then
			cb()
		end
	end)
	
end

function Remove(hook)
	return Event.Remove(hook)
end