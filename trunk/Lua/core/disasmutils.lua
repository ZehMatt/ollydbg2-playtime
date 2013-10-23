function IsCommandType(addr, cmdtype)
	local data = Disasm(addr)
	return bit.bor(data.CmdType, cmdtype)
end

-- Unconditional near jump
function IsJmp(addr)
	return IsCommandType(addr, D_JMP)
end

-- Unconditional far jump
function IsFarJmp(addr)
	return IsCommandType(addr, D_JMPFAR)
end

-- Conditional jump on flags
function IsJmc(addr)
	return IsCommandType(addr, D_JMC)
end

function IsPush(addr)
	return IsCommandType(addr, D_PUSH)
end

function IsPop(addr)
	return IsCommandType(addr, D_POP)
end

function IsRet(addr)
	return IsCommandType(addr, D_RET)
end

function IsCall(addr)
	return IsCommandType(addr, D_CALL)
end

function IsCallFar(addr)
	return IsCommandType(addr, D_CALLFAR)
end

function IsMov(addr)
	return IsCommandType(addr, D_CALLFAR)
end

function IsSystemCall(addr)

	local data = Disasm(addr)
	local dest = data.JmpAddress
	
	if (data.CmdType == D_CALL or data.CmdType == bit.bor(D_CALL, D_CHGESP)) and data.JmpAddress ~= NULL then
	
		local data2 = Disasm(dest)
		
		if data2.CmdType == D_JMP then
			dest = data2.JmpAddress
			if data2.MemConstant ~= 0 then
				dest = DWORD_PTR[data2.MemConstant]
			end
			
		else
			return IsSystemAddress(dest)
		end
		
		return IsSystemAddress(dest)
		
	end
	
	return false
	
end