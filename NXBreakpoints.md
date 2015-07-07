# NX Breakpoints #
We also took the opportunity to implement NX Breakpoints into OllyDbg which allows you to break
as soon a specific memory region is being executed. The difference between a memory breakpoint and
NX breakpoint is that it will not break if the memory is read and only if executed which makes
a huge difference in debugging. To make use of NX breakpoints please enable DEP and you have to
eventually enable the XD/NX flag in your BIOS.

## Remarks ##
If you are still on Windows XP you must enable the PAE in order to enable NX breakpoints.
http://msdn.microsoft.com/en-us/windows/hardware/gg487503.aspx