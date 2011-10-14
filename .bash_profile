# .bashrc

. ~/.profile

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

. ~/.bashrc

#export EDITOR=/usr/bin/vim
export EDITOR='mvim -f --nomru -c "au VimLeave * !open -a Terminal"'

export PATH=$PATH:/usr/local/mysql/bin:~/bin

export LSCOLORS=Hxfxcxdxbxegedabagacad 

PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}: ${PWD/$HOME/~}\007"'

if [ $TERM_PROGRAM='iTerm.app' ]; then
	growl() { if [ $@ ]; then echo -ne "\033]9;\n$@\007"; fi; }
fi

alias ls='ls -G'

##
# Your previous /Users/greg/.bash_profile file was backed up as /Users/greg/.bash_profile.macports-saved_2010-05-12_at_13:23:27
##

# MacPorts Installer addition on 2010-05-12_at_13:23:27: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

alias pm='python manage.py'

##
# Your previous /Users/greg/.bash_profile file was backed up as /Users/greg/.bash_profile.macports-saved_2011-07-03_at_13:26:33
##

# MacPorts Installer addition on 2011-07-03_at_13:26:33: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

