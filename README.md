# d0pamine anti-cheat
a really old project that I've stopped working on, get ready for new paid anti-cheats lmao.

## information
the anti-cheat is mainly server-sided, it will generate the `client.lua` & `server.lua` on resource start and main parts of the code will be randomized.
it's based of my old uglifier and NSAC, should be very easy to use.

## detections
global variable
load function manipulation
LoadResourceFile(attempt to grab from a different resource)
AddExplosion
server ip printing
warmenu debug trace

## Installation/Uninstallation
command: <kbd>d0pamine install all/resource_name</kbd> | <kbd>d0pamine uninstall all/resource_name</kbd> (only through server console).
after installing it restart the server or the resource.
if you would like to have your own code in these files you could edit `d0pamine.clientCode` for `client` code or `d0pamine.serverCode` for `server` code in the config file.
