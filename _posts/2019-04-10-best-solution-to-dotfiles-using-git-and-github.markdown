---
layout: post
title: "Managing Dotfiles with Git and Github"
excerpt: "Never leave home without your dotfiles again! Looking for the perfect solution to managing your dotfiles without using symlinks or other application? This configuration will allow you to easily migrate your dotfiles to every unix machine you touch while maintaining version control."
date: "2019-04-10 12:27:37 -0700"
---
Looking for the perfect solution to managing your dotfiles without using symlinks or other application? This configuration will allow you to easily migrate your dotfiles to every unix machine you touch while maintaining version control. 

Never leave home without your dotfiles again!
<p class='notice--success'>Full credit for this solution goes to StreakyCobra, seliopou, and telotortium at <a href="https://news.ycombinator.com/item?id=11070797">ycombinator forums</a>. Thank you, guys!</p>
<p class='notice--danger'><b>Warning!</b> If caution isn't taken with the instructions below, you may accidently delete your dotfiles. I highly recommend backing up your dotfiles just in case.</p>
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

1. Remove the ~/.git file
   ```sh
   rm ~/.git
   ```
   <p class="notice--warning"><b>Warning!</b> If you get warnings about a directory not being a git repo, or if your shell becomes very slow / zgen starts throwing errors, you probably forgot to delete this.</p>

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
* Simply do steps 2, 3, 4, and 5 from the initial setup instructions.
* Or... you could make a [script](scripts/dotfiles.sh) on another gitrepo or on your github pages that runs those steps for you.
	```sh
	#!/bin/sh
	git clone "--separate-git-dir=$HOME/.dotfiles" https://github.com/$1/dotfiles $HOME/dotfiles-tmp
	cp ~/dotfiles-tmp/. ~ -r
	rm ~/.git
	rm ~/dotfiles-tmp -r
	```
	To use my script:
	```sh
	curl -lO https://techknowfile.dev/scripts/dotfiles.sh
	sudo chmod +x ./dotfiles.sh
	./dotfiles.sh YOURGITHUBUSERNAME
	```
