# d0pamine anti-cheat
A really old project that I've stopped working on, get ready for new paid anti-cheats lmao.

## information
The anti-cheat is mainly server-sided, it will generate the `client.lua` & `server.lua` on resource start and main parts of the code will be randomized.
It's based of my old uglifier and NSAC, should be very easy to use.
I'd recommend you to take the newest code of my uglifier(https://github.com/nertigel/lua_proj).

## detections
* Global variable
* Load function manipulation
* LoadResourceFile(attempt to grab from a different resource)
* AddExplosion
* Server IP printing
* WarMenu debug trace

## Installation/Uninstallation
Command: <kbd>d0pamine install all/resource_name</kbd> | <kbd>d0pamine uninstall all/resource_name</kbd> (only through server console).
After installing it restart the server. I wouldn't recommend to start/restart the resource while the server is running.
If you would like to have your own code in these files you could edit `d0pamine.clientCode` for `client` code or `d0pamine.serverCode` for `server` code in the config file.

I wouldn't suggest using it like so, you should make a few changes to it or just wait until a few idiots start selling a modified version of it and it gets leaked.
