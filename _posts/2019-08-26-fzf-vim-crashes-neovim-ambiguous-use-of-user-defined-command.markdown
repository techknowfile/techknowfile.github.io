---
layout: post
title: "fzf.vim crashes neovim - Ambiguous use of user-defined command"
date: "2019-08-26 10:25:45 -0700"
---

Issue: Ctrl+p (<C-p>), :History, :FZF crashes neovim with error "Ambiguous use of user-defined command" in 16_SynSet. Back in terminal, whitespace (newlines) are broken. Can't hit enter. 

Solution: Uninstalled the apt-installed neovim, built neovim from source
