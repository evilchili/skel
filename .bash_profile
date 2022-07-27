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

export EDITOR=/usr/local/bin/vim
export PATH=~/bin:/usr/local/bin:~/dnd/telisar/bin:$PATH:/usr/local/mysql/bin:/usr/local/git/bin:/opt/local/bin:/opt/bin

if [ "$ITERM_PROFILE" == "Writing" ]; then
    cd ~/dnd/telisar-website
    source ./env/bin/activate
fi

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

function ghfile() {
    if [[ $1 ]]; then
        SUBJECT=$1
        if [[ $2 ]]; then
            LABELS=$2
        else
            LABELS='bug'
        fi
        if [[ $GHI_MILESTONE ]]; then
            M_ARG="-M $GHI_MILESTONE"
        else
            M_ARG=""
        fi
        ghi open --label $LABELS --claim $M_ARG -m "$SUBJECT"
    fi
}

function ghmilestone() {
    if [[ $1 ]]; then
        export GHI_MILESTONE=$1
    else
        ghi milestone -l
    fi
}

function ghstart() {
    if [[ $1 ]]; then
        export GHI_TARGET=$1
        ghi label $GHI_TARGET -a 'in progress'  
    else
        ghi
    fi
}

#~/dnd/telisar/bin/campaign -- --completion > /tmp/campaign_completion.sh
#source /tmp/campaign_completion.sh

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
#PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
#export PATH

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

