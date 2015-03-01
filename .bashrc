## Snippets of this .bashrc file have been taken from http://tldp.org/LDP/abs/html/sample-bashrc.html

# Read in the machine's master .bashrc file
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Read in the machine specific .bashrc information if it exists
if [ -e ~/.bashrc_custom ]; then
    . ~/.bashrc_custom
fi

# Add an environment variable to add the GitHub KiCad templates
export KICAD_PTEMPLATES=$HOME'/Documents/Github/KiCad-Libraries/Templates'

#########################################################
# Color definitions (taken from Color Bash Prompt HowTo).
# Some colors might look different on some terminals.
#########################################################

# Normal Colors
Black='\e[0;30m'        # Black
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White

# Bold
BBlack='\e[1;30m'       # Black
BRed='\e[1;31m'         # Red
BGreen='\e[1;32m'       # Green
BYellow='\e[1;33m'      # Yellow
BBlue='\e[1;34m'        # Blue
BPurple='\e[1;35m'      # Purple
BCyan='\e[1;36m'        # Cyan
BWhite='\e[1;37m'       # White

# Background
On_Black='\e[40m'       # Black
On_Red='\e[41m'         # Red
On_Green='\e[42m'       # Green
On_Yellow='\e[43m'      # Yellow
On_Blue='\e[44m'        # Blue
On_Purple='\e[45m'      # Purple
On_Cyan='\e[46m'        # Cyan
On_White='\e[47m'       # White

NC="\e[m"               # Color Reset

ALERT=${BWhite}${On_Red} # Bold White on red background

#########################################################
# Format the user string
#########################################################

# Current Format: [TIME USER@HOST PWD] >
# USER:
#    Cyan      == normal user
#    Orange    == SU to user
#    Red       == root
# HOST:
#    Cyan      == local session
#    Blue      == secured remote connection (via ssh)
#    Red       == unsecured remote connection
# PWD:
#    Red       == current user does not have write privileges
# >:
#    White     == no background or suspended jobs in this shell
#    Cyan      == at least one background job in this shell
#    Orange    == at least one suspended job in this shell
#
#    Command is added to the history file each time you hit enter,
#    so it's available to all shells (using 'history -a').

# Test remote connection type
if [ -n "${SSH_CONNECTION}" ]; then
    CNX=${BYellow}        # Connected on remote machine, via ssh (good).
elif [[ "${DISPLAY%%:*}" != "" ]]; then
    CNX=${ALERT}        # Connected on remote machine, not via ssh (bad).
else
    CNX=${BCyan}        # Connected on local machine.
fi

# Test user type
if [[ ${USER} == "root" ]]; then
    SU=${Red}           # User is root.
elif [[ ${USER} != $(logname) ]]; then
    SU=${BRed}          # User is not login user.
else
    SU=${BCyan}         # User is normal (well ... most of us are).
fi

# Check for write privilege in current directory
if [ ! -w "${PWD}" ] ; then
    WP=${Red}
fi

# Tailor the prompt to contain the username, hostname, and current directory
export PS1="[\[$SU\]\u\[$NC\]@\[$CNX\]\H\[$NC\] \[$WP\]\w]$\[$NC\] "
