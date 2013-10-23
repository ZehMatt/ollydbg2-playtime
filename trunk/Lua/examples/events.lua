
Event.Listen("LoadDll", function(info)
	print("LoadDll Event")
	table.print(info, true)
end)

Event.Listen("UnloadDll", function(info)
	print("UnloadDll Event")
	table.print(info, true)
end)

Event.Listen("CreateThread", function(info)
	print("CreateThread Event")
	table.print(info, true)
end)

Event.Listen("ExitThread", function(info)
	print("ExitThread Event")
	table.print(info, true)
end)

Event.Listen("Exception", function(info)
	print("Exception Event")
	table.print(info, true)
end)

Event.Listen("Int3Breakpoint", function(info)
	print("User Int3 Breakpoint")
	table.print(info, true)
end)