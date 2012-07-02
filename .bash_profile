# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# local profile
if [ -f ~/.profile ]; then
	. ~/.profile
fi

# bash settings
. ~/.bashrc

export EDITOR=/usr/bin/vim
export PATH=~/bin:$PATH:/usr/local/mysql/bin:/usr/local/git/bin:/opt/local/bin:/opt/bin

# enable colorized ls output for Linux and BSD-like platforms
platform=`uname`
if [[ $platform == 'Linux' ]]; then
	alias ls='ls --color=auto --group-directories-first'
else 
	export CLICOLOR=1
	alias ls='ls -G'
fi

alias wget="wget --content-disposition"
alias git-export="git archive master | tar -x -C"
alias growl="/usr/local/bin/growlnotify bash -m"
