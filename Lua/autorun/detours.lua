include("core/detours.lua")

local pGetTickCount = GPA("kernel32.dll", "GetTickCount")
local pSleep = GPA("kernel32.dll", "Sleep")

-- Where we will hold the variable.
local pCounter = RemoteAlloc(4)

Option.Register("Sleep", "Detours Sleep to interact with GetTickCount", true, OPT_PERMANENT, function(key, val)

	if val == true then
		detours.Add(pSleep, function(ip, trampoline)
			return assembler.Make(ip, string.format(
			[[
				mov eax, dword ptr[esp+4]    ; Get Param1
				add dword ptr[%08X], eax     ; Add to our memory.
				ret 4
			]], pCounter))
		end)
	else
		detours.Remove(pSleep)
	end
	
end)

Option.Register("GetTickCount", "Detours GetTickCount to return fake time", true, OPT_PERMANENT, function(key, val)

	if val == true then
		detours.Add(pGetTickCount, function(ip, trampoline)
			return assembler.Make(ip, string.format(
			[[
				inc dword ptr[%08X]           ; First we increment
				mov eax, dword ptr[%08X]      ; Move to eax 
				ret
			]], pCounter, pCounter))
		end)
	else
		detours.Remove(pGetTickCount)
	end
	
end)