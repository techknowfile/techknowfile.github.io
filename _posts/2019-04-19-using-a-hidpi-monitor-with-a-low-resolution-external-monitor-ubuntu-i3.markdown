---
layout: single
title: "Using a HiDPI monitor with a low resolution external monitor (Ubuntu + i3)"
date: "2019-04-19 13:31:44 -0700"
---
Just a quick post to document how I finally got my XPS 15 3840x2160 monitor working with a 1920x1080 external monitor with different dps.

**My configuration:**
* Ubuntu 16.04
* i3-gaps (4.16.1-166-g007218a8)

## The problem
Using a HiDPI monitor with 2x scale set. Connecting an external, lower dpi monitor results in everything on that monitor also being scaled 2x, making them way too big. i3 status bar, browser address bars, etc become unusable.

I had tried [manually configuring the xrandr settings](https://blog.summercat.com/configuring-mixed-dpi-monitors-with-xrandr.html), but it wouldn't work properly. The external monitor would not allow me to change the panning, so even if I could get it to display properly, the mouse itself could only move through a limited portion of the screen before hitting an edge. Using the --panning flag with any value results in this error
<p class="notice--danger">X Error of failed request:  BadMatch (invalid parameter attributes)
  Major opcode of failed request:  140 (RANDR)
  Minor opcode of failed request:  29 (RRSetPanning)
  Serial number of failed request:  40
  Current serial number in output stream:  40
</p>

## The cause
After some research, it turns out [there is a bug in xserver-xorg version < 1.20](https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/883319) in which the cursor constraints are not modified properly when using `--scale`. Xserver 1.20  was released with Ubuntu 18.10, and is now available for Ubuntu 18.04 via the xserver-xorg-hwe-18.04 package. **Unfortunately, this package is not available for Ubuntu 16.04.** While it may technically be possible to build it yourself and replace all the dependent packages, it's probably more trouble than it's worth.

## The Solution
I upgraded from Ubuntu 16.04 to Ubuntu 18.04 using
```sh
sudo do-release-upgrade
```
The upgrade took a couple of hours. After successfully upgrading to Ubuntu 18.04, I installed the hardware acceleration package:
```sh
sudo apt install xserver-xorg-hwe-18
```
Finally, I ran the following xrandr command
```sh
xrandr --dpi 276 --output eDP-1-1 --mode 3840x2160 --output HDMI-1-1  --scale 2x2 --pos 3840x0
```
Notice that specifying --fb and --panning were not necessary (and, in fact, the --panning command still doesn't work for me).

## Other issues to note
* When trying to update to the latest LTS, my root partition didn't have enough memory to download the 8GB update. Had to clear space.
* When first logging into i3 after the update, none of my windows were appearing and the monitors starting glitching terribly. This was caused by my dual kawase blur build of compton. Had to rebuild
* After rebuilding compton, everything was very laggy (switching and resizing windows, etc). This is related to the --backend "glx" setting. I've disabled it for now. Need to find a fix, because kawase doesn't work with the "xrender" backend. It may be interfering with nvidia driver / Prime Synchronization, though they worked fine together on 16.04 before the update.
