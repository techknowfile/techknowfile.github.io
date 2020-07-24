---
layout: post
title: "Audio choppy/stuttering on Ubuntu guest with MacOS host"
date: "2020-07-23 23:10:26 -0700"
---
**Before you begin:**
  * Shutdown virtual machine

In .vmx file, add line
```
sound.virtualdev = "hdaudio"
```
