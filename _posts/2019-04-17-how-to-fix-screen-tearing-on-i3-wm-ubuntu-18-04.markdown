---
layout: single
title: "How to fix screen tearing on i3-wm (Ubuntu 18.04)"
date: "2019-04-17 20:26:18 -0700"
toc: true
---

I love i3. I've loved it since the day I started using it. The only time that i3 bothered me was when trying to watch a movie... or scroll on a web page... or do basically anything else that would make prevalent just how bad the screen tearing was.

I've faced this issue on every machine running i3, and the solution has been different dependent on the hardware of the machine.  Some machines, such as my XPS 15 laptop, have two graphics cards. In my case, an NVIDIA GeForce GTX 960M and an onboard intel card. Nvidia PRIME allows you to control which monitor is using which graphics card. Any machine using Nvidia PRIME will not allow you to use the ForceFullCompositionPipeline setting that every other post on this issue recommends. Instead, at least on Ubuntu 18.04, you need to enable Prime Synchronization, which requires several modifications to system configuration files.

## Fixing i3wm screen tearing when NOT using Nvidia PRIME
If you are using an nvidia graphics card without PRIME, you can enable the ForceFullCompositionPipeline setting using either nvidia-settings or the command line.

### Enabling ForceFullCompositionPipeline from nvidia-settings
1. Open nvidia-settings as root.
```sh
sudo nvidia-settings
```
2. In X Server Display Configuration, click **Advanced...** and select ForceCompositionPipeline and ForceFullCompositionPipeline.
    <p class='notice--warning'>If you don't have these setting options, your machine is probably using Nvidia PRIME. Instructions for you are further down.</p>

3. Click **Save to X Configuration File** and enter `/etc/X11/xorg.conf`. Then click **Save**.

### Enabling ForceFullCompositionPipeline from terminal
* This is the command I use. Will need to change it based on your device names and resolutions. I'll update this post later with a better answer than 'figure it out'. Maybe.
	```sh
	sudo nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }, HDMI-1-1: nvidia-auto-select +3840+0 {ForceCompositionPipeline=On}"
	```
	This will only temporarily change the settings. You can add this command to your i3 config or another file that runs after X11 has started.

## Fixing i3wm screen tearing with Nvidia PRIME
Aka, enabling PRIME Synchronization. Unforunately, this is not as straightforward as the non-PRIME solution.
1. Open `/etc/modprobe.d/nvidia-graphics-drivers.conf`. If you see `options nvidia_DRIVERVERSIONNUMBER_drm modeset=0` in this file, create another file in the same directory named `zz-nvidia-modeset.conf` with this line:
	```sh
	options nvidia_DRIVERVERSIONNUMBER_drm modeset=1
	```
	If you *don't* see that line, create the same file as above, but with:
	```sh
	options nvidia-drm modeset=1
	```
2. Save that file, then run:
	```sh
	sudo update-initramfs -u
	```
3. Based on when I did this, I also believe that you may need to enable nvidia-drm in GRUB. So just in case this was necessary... open `/etc/default/grub` as root. Find the line that contains `GRUB_CMDLINE_LINUX_DEFAULT` and append ` nvidia-drm.modeset=1` to the end of the string. For example, my line looks like this:
	```sh
	GRUB_CMDLINE_LINUX_DEFAULT="quiet splash nvidia-drm.modeset=1"
	```
4. Update GRUB with new config file:
	```sh
	sudo grub-mkconfig -o /boot/grub/grub.cfg
	```
1. Install xserver-xorg version 1.19, which I believe is required for Prime Synchronization support.
	```sh
	sudo apt install xserver-xorg-hwe-16.04
	```
5. Reboot!
	```sh
	sudo reboot
	```
1. Confirm that the modeset worked.
	```sh
	sudo cat /sys/module/nvidia_drm/parameters/modeset
	```
	Should output `Y`. If it didn't, something didn't work.
7. Use xrandr to enable Prime Synchronization. You'll need to change the output device (in this example, eDP-1-1) to whatever your device name is. 
	```sh
	xrandr --output eDP-1-1 --set "PRIME Synchronization" 1
	```
	To make this setting persist, you can add the command to your i3 config file, or maybe .xinitrc. Maybe you can use the `Save to X Configuration File` setting within nvidia-settings instead. Dunno, haven't tested.
	<p class='notice--warning'><b>Get an error?</b> If you get an error to the effect of "X Error of failed request:  BadName (named color or font does not exist)", make sure that xserver-xorg v1.19 is installed, as mentioned above.</p>

If all went smoothly, screen tearing should now be a thing of the past!
