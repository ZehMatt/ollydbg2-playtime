         __                  __   __                
 ______ |  | _____  ___ ____/  |_|__|_____   _____  
\_____ \|  | \__  \\   | /__   __/  |     \_/  __ \ 
 |  |_\ \  |__/ __ \\___  | |  | |  |  v v  \  ___/__ 
 |   ___/____(____  / ____| |__| |__|__|_|  /\______/
 |  /    v1.0.0   \/\/  OllyDbg 2 Plugin  \/   
 |_/ 
 
Version:
  1.0.0
    - Initial Release
  
Installation:
   1. Copy Playtime.dll into your OllyDbg Plugin directory.
   2. Copy the Lua directory to the same location where OllyDbg.exe is.
   3. Enjoy
   
Using Lua:
   There are 2 variants to execute lua scripts:

     1. Anything in Lua\autorun will be executed as soon the process is ready, we did this 
        to give the scripts a chance to detour functions before starting to debug, you are
        not restricted at this point.

     2. Executing a script over the menu is probably your right choice to create individual
        scripts and execute them on-demand.

     NOTE: There is also one file which is autoloaded internally, it resides in Lua\core\core.lua
           It is not recommended to modify the core files.
   
   We also managed to automate the documentation of all available functions from OllyDbg
   in Documentation.html, please refer to this file to learn more about functions and
   constants.

   One big advantage of this Plugin is the usage of LuaJIT. If you are not aware of what LuaJIT is
   or what its capable of then you missed something big, LuaJIT allows to use C declarations inside
   your Lua script to use native C code, you can get more information about LuaJIT's FFI library 
   on the authors website: 
   http://luajit.org/ext_ffi.html 

   Please keep in mind that our documentation generator is not reading the Lua files at the moment,
   please check some examples shipped within this package to get some insight of whats possible with
   Lua.

NX Breakpoints:
   We also took the opportunity to implement NX Breakpoints into OllyDbg which allows you to break
   as soon a specific memory region is being executed. The difference between a memory breakpoint and
   NX breakpoint is that it will not break if the memory is read and only if executed which makes
   a huge difference in debugging. To make use of NX breakpoints please enable DEP and you have to
   eventually enable the XD/NX flag in your BIOS.
   
   If you are still on Windows XP you must enable the PAE in order to enable NX breakpoints.
   http://msdn.microsoft.com/en-us/windows/hardware/gg487503.aspx
   
Dumper:
   Playtime also has its own PE Image dumper, at the moment its preliminary and will receive further
   features and updates over the time. For now its capable of simple dumping and fixing headers from
   the disk. Later versions will include import rebuilding and more advanced options.

Authors:
  - Matthias Moninger
  - Mateusz Krzywicki

Credits:
  - Oleh Yuschuk, invented one hell of incredible debugger, also thanks for all the help.
  - Mike Pall, we really envy your motivation.
  
Website / Bug Reports / Requests:
  https://code.google.com/p/ollydbg2-playtime/