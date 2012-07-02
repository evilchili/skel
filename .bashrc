WHITE="\[\033[00;37;01m\]"
GREEN="\[\033[01;32;01m\]"
BLUE="\[\033[01;34;01m\]"
YELLOW="\[\033[01;33;01m\]"
DARKGRAY="\[\033[1;30;01m\]"
NOCOLOR="\[\033[00m\]"

HOSTUSER="${WHITE}\h:\u"
DATE="${BLUE}\d \$(date '+%T %Z')"
if [ "$SHLVL" -ne "1" ]; then
	PARENT="${DARKGRAY}${SHLVL}/$(ps -o comm= $PPID)"
fi
NUM="${YELLOW}!\!"
CWD="${YELLOW}\w"

export PS1="${HOSTUSER} ${DATE} ${PARENT}\n${NUM} ${CWD} ${NOCOLOR}"
export PS2="${YELLOW}    ?${NOCOLOR} "
