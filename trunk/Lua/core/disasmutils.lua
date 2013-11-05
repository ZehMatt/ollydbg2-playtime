--[[
@section Disassembly
@module
@class
]]

--[[
$IsCommandType
@desc Returns if the selected command is matching the given type.
@param number cmdaddress
@param number cmdtype See one of the #D_ flags.
@return boolean istype
$$
]]
function IsCommandType(addr, cmdtype)
	local data = Disasm(addr)
	return bit.bor(data.CmdType, cmdtype)
end

--[[
$IsJmp
@desc Returns if the command is a unconditional jump
@param number cmdaddress
@return boolean isjump
$$
]]
function IsJmp(addr)
	return IsCommandType(addr, D_JMP)
end

--[[
$IsFarJmp
@desc Returns if the command is a unconditional far jump
@param number cmdaddress
@return boolean isfarjump
$$
]]
function IsFarJmp(addr)
	return IsCommandType(addr, D_JMPFAR)
end

--[[
$IsJmc
@desc Returns if the command is a conditional jump
@param number cmdaddress
@return boolean iscondjump
$$
]]
function IsJmc(addr)
	return IsCommandType(addr, D_JMC)
end

--[[
$IsPush
@desc Returns if the command is a push
@param number cmdaddress
@return boolean ispush
$$
]]
function IsPush(addr)
	return IsCommandType(addr, D_PUSH)
end

--[[
$IsPop
@desc Returns if the command is a pop
@param number cmdaddress
@return boolean ispop
$$
]]
function IsPop(addr)
	return IsCommandType(addr, D_POP)
end

--[[
$IsRet
@desc Returns if the command is a ret
@param number cmdaddress
@return boolean isret
$$
]]
function IsRet(addr)
	return IsCommandType(addr, D_RET)
end

--[[
$IsCall
@desc Returns if the command is a call
@param number cmdaddress
@return boolean iscall
$$
]]
function IsCall(addr)
	return IsCommandType(addr, D_CALL)
end

--[[
$IsFarCall
@desc Returns if the command is a far call
@param number cmdaddress
@return boolean isfarcall
$$
]]
function IsFarCall(addr)
	return IsCommandType(addr, D_CALLFAR)
end

--[[
$IsMove
@desc Returns if the command is a mov
@param number cmdaddress
@return boolean ismov
$$
]]
function IsMov(addr)
	return IsCommandType(addr, D_CALLFAR)
end

--[[
$IsSystemCall
@desc Returns if the command is a system call, keep in mind that this logic can be slow.
@param number cmdaddress
@return boolean issystemcall
@remarks This function attempts to read the call destination and determines if it goes into a system dll.
$$
]]
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