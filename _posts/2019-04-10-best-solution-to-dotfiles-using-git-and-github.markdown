---
layout: post
title: "Best solution to dotfiles using git and github"
date: "2019-04-10 12:27:37 -0700"
---

## Setting up your dotfiles
1. Create an empty github repo for your dotfiles.
	```
	https://github.com/YOURUSERNAME/dotfiles
	```
1. Clone the repo into a temporary directory.

	```sh
	git clone --separate-git-dit=$HOME/.dotfiles https://github.com/YOURUSERNAME/dotfiles $HOME/dotfiles-tmp
	```
2. Copy the contents of that directory into your home folder.
	```sh
	cp ~/dotfiles-tmp/. ~ -r
	```

3. Delete the temporary directory.
	```sh
	rm ~/dotfiles-tmp -r
	```

4. The first time you setup these dotfiles, add the following `dotfiles` alias to your shell dotfile (.bashrc, .zshrc, etc), or wherever you put your aliases.
	```sh
	alias dotfiles='`which git` --git-dir=$HOME/.dotfiles --work-tree=$HOME'
	```

5. Source your shell dotfile (.bashrc, .zshrc, etc) to make sure the `dotfiles` alias is now available to you.
	```sh
	source ~/.zshrc
	```

6. To prevent every directory in your home directory from being detected as part of a git repo (and so that powerline doesn't show a branch name in every directory), run the following:
	```sh
	mkdir ~/.dotfiles/.dotfiles
	```
	And then edit ~/.git to point to that new, empty directory. For example:
	```
	gitdir: .dotfiles/.dotfiles
	```
	<p class="notice--danger">
	<b>Warning!</b> If you don't make this edit, zgen and other applications may cause your terminal to lag terribly.
 	<br />
	This file cannot be added to your dotfiles repo. Haven't found a better solution than creating it every time. 
	<b>Update:</b> Just kidding, better off just deleting the ~/.git file that is being copied over from dotfiles-tmp
	</p>	

7. To prevent `$ dotfiles status` from displaying every file in your home directory as being untracked, run:
	```sh
	dotfiles config status.showUntrackedFiles no
	```

## Adding dotfiles
* Use `dotfiles` command the same way you would use the `git` command.
	```sh
	dotfiles add ~/.zshrc ~/.tmux.conf
	dotfiles commit -m "Added .zshrc and .tmux.conf"
	dotfiles push
	```

## Get dotfiles on new computer
* Simply do steps 2, 3, 4, and 6 from the initial setup instructions.
* Or... you could make a [script](scripts/dotfiles.sh) on another gitrepo or on your github pages that runs those steps for you.
	```sh
	#!/bin/sh
	git clone "--separate-git-dir=$HOME/.dotfiles" https://github.com/$1/dotfiles $HOME/dotfiles-tmp
	cp ~/dotfiles-tmp/. ~ -r
	echo 'gitdir: .dotfiles/.dotfiles' > ~/.git
	rm ~/dotfiles-tmp -r
	```
	To use my script:
	```sh
	curl -lO https://techknowfile.dev/scripts/dotfiles.sh
	sudo chmod +x ./dotfiles.sh
	./dotfiles.sh YOURGITHUBUSERNAME
	```


