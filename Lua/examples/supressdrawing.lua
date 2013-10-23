-- Enhances critical performance 
SuppressCPUDrawing(true)

for i = 0, 10000 do 
	StepOver()
end

-- Disable.
SupressCPUDrawing(false)