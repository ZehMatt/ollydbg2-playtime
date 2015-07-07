# Using Lua #

## Variants ##
  1. Anything in Lua\autorun will be executed as soon the process is ready, we did this to give the scripts a chance to detour functions before starting to debug, you are not restricted at this point.
  1. Executing a script over the menu is probably your right choice to create individual scripts and execute them on-demand.

> NOTE: There is also one file which is autoloaded internally, it resides in "Lua\core\core.lua". It is not recommended to modify the core files.

## Documentation ##
We also managed to automate the documentation of all available functions from OllyDbg in Documentation.html, please refer to this file to learn more about functions and constants.

One big advantage of this Plugin is the usage of LuaJIT. If you are not aware of what LuaJIT is or what its capable of then you missed something big, LuaJIT allows to use C declarations inside your Lua script to use native C code, you can get more information about LuaJIT's FFI library on the authors website: http://luajit.org/ext_ffi.html

Please keep in mind that our documentation generator is not reading the Lua files at the moment, please check some examples shipped within this package to get some insight of whats possible with Lua.