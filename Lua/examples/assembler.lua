local code = assembler.Make(EIP, 
	[[
		mov eax, 1                                ; Some comment
		mov edx, 2
		@testlabel:                               ; This is a label
		lea eax, dword ptr[$testlabel]            ; assign eax to the offset of testlabel
		ret
	]])
print(string.hexdump(code))
