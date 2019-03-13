# MCE Controller For Control4

I made this controller so I could send keystrokes to a Windows PC over the network using a Control4 remote.

# How To Use

* Install MCE on your PC. (https://github.com/tig/mcec)
* Install this driver (the .c4z file) using Composer
* Set the IP/Port on the driver
* Refresh Navigators
* Select the driver as a source in a room
* Press buttons (you should see them in the MCE console)

# Misc

This was my first attempt at writing a driver, so I can't guarentee that it'll work perfectly.. but it works for me. I wanted to control a PC running some NVR software so I could view it on any TV and switch between cameras.

I only translated the buttons that I needed so you'll need to edit the Lua file and recompile if you need more. I'd like to make it more configurable in the future so you don't have to.