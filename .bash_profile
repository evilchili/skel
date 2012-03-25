# .bashrc

. ~/.profile

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

. ~/.bashrc

export EDITOR=/usr/bin/vim

export PATH=$PATH:/usr/local/mysql/bin:~/bin

export LSCOLORS=Hxfxcxdxbxegedabagacad 

PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/$HOME/~}\007"'

if [ $TERM_PROGRAM='iTerm.app' ]; then
	growl() { if [ $@ ]; then echo -ne "\033]9;\n$@\007"; fi; }
fi

alias ls='ls --color=auto --group-directories-first'
alias wget="wget --content-disposition"
alias git-export="git archive master | tar -x -C"

# use syntax-highlighting with less
export LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
export LESS=' -R '
