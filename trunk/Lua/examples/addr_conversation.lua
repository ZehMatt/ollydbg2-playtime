local main = FindMainModule()

-- Convert.
local va_eip = EIP
local rva_eip = main:VAToRVA(va_eip)
local offset_1 = main:VAToOffset(va_eip)
local offset_2 = main:RVAToOffset(rva_eip)
if( offset_1 ~= offset_2 ) then
	error("Address conversation failed")
end

print("VA: ", string.hex(va_eip))
print("RVA: ", string.hex(rva_eip))
print("Offset 1: ", string.hex(offset_1))
print("Offset 2: ", string.hex(offset_2))

-- Convert back.
local rva_1 = main:OffsetToRVA(offset_1)
local va_1 = main:OffsetToVA(offset_1)
local va_2 = main:RVAToVA(rva_1)

print("RVA: ", string.hex(rva_1))
print("VA 1: ", string.hex(va_1))
print("VA 2: ", string.hex(va_2))

if( va_eip ~= va_1 or va_1 ~= va_2 ) then
	error("Address conversation failed")
end