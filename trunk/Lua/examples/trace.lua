SuppressCPUDrawing(true)

while Process.Handle() > 0 do

	if IsSystemCall(EIP) then
		print("System Call at: "..string.hex(EIP))
		StepOver()
	else
		StepIn()
	end
	
end

SuppressCPUDrawing(false)