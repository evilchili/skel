# A two-line bash prompt that looks like this:
#
# grognak:greg Mon Jul 02 11:54:01 EDT 2/vi
# !540 /tmp 

WHITE="\[\033[00;37;01m\]"
GREEN="\[\033[01;32;01m\]"
BLUE="\[\033[01;34;01m\]"
YELLOW="\[\033[01;33;01m\]"
RED="\[\033[01;31;01m\]"
DARKGRAY="\[\033[1;30;01m\]"
LIGHTGRAY="\[\033[00;37;01m\]"
NOCOLOR="\[\033[00m\]"

# set the display hostname to include the subodmain, if any  
# subdomain of the host we're on is 'staging'
HOSTNAME=`hostname -f | grep staging |cut -d . -f1,2`
if [ "$HOSTNAME" == "" ]; then
	HOSTNAME="\h"
fi
	
function nameTerminal() {
	# adapted from http://fvue.nl/wiki/NameTerminal
    [ "${TERM:0:5}" = "xterm" ]   && local ansiNrTab=0
    [ "$TERM"       = "rxvt" ]    && local ansiNrTab=61
    [ $ansiNrTab ] && echo -n $'\e'"]$ansiNrTab;\u@${HOSTNAME} $1"$'\a'
    [ $ansiNrWindow -a "$2" ] && echo -n $'\e'"]$ansiNrWindow;\u@${HOSTNAME} $2"$'\a'
} 


function set_prompt {

	if [ `whoami` == "root" ]; then
		NUM="${RED}!\!"
		CWD="${RED}\w${NOCOLOR}"
		HOSTUSER="${WHITE}${HOSTNAME}:${RED}\u"
	else
		NUM="${YELLOW}!\!"
		CWD="${YELLOW}\w${NOCOLOR}"
		HOSTUSER="${WHITE}${HOSTNAME}:\u"
	fi
	DATE="${BLUE}\d \$(date '+%T %Z')"
	if [ "$SHLVL" -ne "1" ]; then
		PARENT="${DARKGRAY}${SHLVL}/$(ps -o comm= $PPID)"
	fi
	
	if [ "$STY" == "" ]; then
		SCREENLABEL=""
	else
		SCREENLABEL="$(echo $STY|cut -d. -f2) "
	fi

	export PS1="$(nameTerminal)${SCREENLABEL}${HOSTUSER} ${DATE} ${PARENT}\n${NUM} ${CWD} ${LIGHTRAY}"
	export PS2="${YELLOW}    ?${NOCOLOR} "
	
}

if [ "$TERM_PROGRAM" == "Apple_Terminal" ]; then

	# fix for white backgrounds
	WHITE=${DARKGRAY}

	# if we're in terminal.app, we only mess with the prompt if we're running 
	# the default black-on-white theme.
	if [ `defaults read com.apple.terminal "Default Window Settings"` == "Basic" ]; then
		set_prompt
	fi

else 
	set_prompt
fi


