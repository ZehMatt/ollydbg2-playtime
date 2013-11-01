-- Where we will hold the variable.
local pCounter = RemoteAlloc(4)
local pSetLastError = GPA("kernel32.dll", "SetLastError")

-- Sleep
--
local pSleep = GPA("kernel32.dll", "Sleep")

Option.Register("Sleep", "Detours Sleep to interact with GetTickCount", true, OPT_PERMANENT, function(key, val)

	if val == true then
		Detours.Add(pSleep, function(ip, trampoline)
			return Assembler.Make(ip, string.format(
			[[
				mov eax, dword ptr[esp+4]    ; Get Param1
				add dword ptr[%08X], eax     ; Add to our memory.
				ret 4
			]], pCounter))
		end)
	else
		Detours.Remove(pSleep)
	end
	
end)

-- GetTickCount
--
local pGetTickCount = GPA("kernel32.dll", "GetTickCount")

Option.Register("GetTickCount", "Detours GetTickCount to return fake time", true, OPT_PERMANENT, function(key, val)

	if val == true then
		Detours.Add(pGetTickCount, function(ip, trampoline)
			return Assembler.Make(ip, string.format(
			[[
				inc dword ptr[%08X]           ; First we increment
				mov eax, dword ptr[%08X]      ; Move to eax 
				ret
			]], pCounter, pCounter))
		end)
	else
		Detours.Remove(pGetTickCount)
	end
	
end)

-- NtQueryInformationProcess
--
local pNtQueryInformationProcess = GPA("ntdll.dll", "NtQueryInformationProcess")

Option.Register("NtQueryInformationProcess", "Detours NtQueryInformationProcess", true, OPT_PERMANENT, function(key, val)

	if val == true then
		Detours.Add(pNtQueryInformationProcess, function(ip, trampoline)
			return Assembler.Make(ip, string.format(
			[[
				cmp dword ptr[esp+8], 7
				je $no_debug
				jmp %08X	; trampoline
				@no_debug:
				mov eax, dword ptr[esp+C]
				mov dword ptr[eax], 0
				xor eax, eax
				push eax
				call %08X	; pSetLastError
				xor eax, eax
				retn 0x14
			]], trampoline, pSetLastError))
		end)
		print("Detoured NtQueryInformationProcess")
	else
		Detours.Remove(pNtQueryInformationProcess)
	end

end)

-- NtSetInformationThread
--
local pNtSetInformationThread = GPA("ntdll.dll", "NtSetInformationThread")

Option.Register("NtSetInformationThread", "Detours NtSetInformationThread", true, OPT_PERMANENT, function(key, val)

	if val == true then
		Detours.Add(pNtSetInformationThread, function(ip, trampoline)
			return Assembler.Make(ip, string.format(
			[[
				cmp dword ptr[esp+8], 0x11
				je $hidethread
				jmp %08X	; trampoline
				@hidethread:
				xor eax, eax
				push eax
				call %08X	; pSetLastError
				xor eax, eax
				retn 0x10
			]], trampoline, pSetLastError))
		end)
		print("Detoured NtSetInformationThread")
	else
		Detours.Remove(pNtSetInformationThread)
	end
	
end)

-- ZwClose
--
local pZwQueryObject = GPA("ntdll.dll", "ZwQueryObject")
local pZwClose = GPA("ntdll.dll", "ZwClose")

Option.Register("ZwClose", "Detours ZwClose, avoid raising exceptions", true, OPT_PERMANENT, function(key, val)

	if val == true then
		Detours.Add(pZwClose, function(ip, trampoline)
			return Assembler.Make(ip, string.format(
			[[
				push dword ptr[esp+4]
				call $IsValidHandle
				cmp eax, 0
				je $Ret
				jmp %08X		; trampoline
			@Ret:
				mov eax, 0xC0000008      ; Dont raise an exception, return the result.
				ret 4
				
			@IsValidHandle:
				push ebp
				mov ebp, esp
				add esp, -38
				pushad
				push 0
				push 38
				lea eax, dword ptr[ebp-38]
				push eax
				push 0
				push dword ptr[ebp+8]
				call %08X		; pZwQueryObject
				or eax, eax
				jnz $InvalidHandle
				popad
				mov eax, 1
				leave
				ret 4
			@InvalidHandle:
				popad
				xor eax, eax
				leave
				ret 4
			]], trampoline, pZwQueryObject))
		end)
		print("Detoured ZwClose")
	else
		Detours.Remove(pZwClose)
	end
	
end)

local pPEB = DWORD_PTR[FS + 0x30]
local pProcessHeap = DWORD_PTR[pPEB + 0x18]

-- PEB.BeingDebugged
--
Option.Register("PEB.BeingDebugged", "Sets the value to 0", true, OPT_PERMANENT, function(key, val)

	if val == true then
		BYTE_PTR[pPEB + 0x02] = 0
		print("Patched PEB.BeingDebugged")
	else
		-- Is it worth restoring?
	end
	
end)

-- PEB.ProcessHeap.HeapFlags
--
Option.Register("PEB.ProcessHeap.HeapFlags", "Sets the value to 0x02", true, OPT_PERMANENT, function(key, val)

	if val == true then
		BYTE_PTR[pProcessHeap + 0x0C] = 0x02
		print("Patched PEB.ProcessHeap.HeapFlags")
	else
		-- Is it worth restoring?
	end
	
end)

-- PEB.ProcessHeap.ForceFlags
--
Option.Register("PEB.ProcessHeap.ForceFlags", "Sets the value to 0", true, OPT_PERMANENT, function(key, val)

	if val == true then
		BYTE_PTR[pProcessHeap + 0x10] = 0
		print("Patched PEB.ProcessHeap.ForceFlags")
	else
		-- Is it worth restoring?
	end
	
end)

-- PEB.NtGlobalFlag
--
Option.Register("PEB.NtGlobalFlag", "Sets the value to 0", true, OPT_PERMANENT, function(key, val)

	if val == true then
		BYTE_PTR[pPEB + 0x68] = 0
		print("Patched PEB.NtGlobalFlag")
	else
		-- Is it worth restoring?
	end
	
end)