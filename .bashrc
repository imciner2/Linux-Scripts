## Snippets of this .bashrc file have been taken from http://tldp.org/LDP/abs/html/sample-bashrc.html

# Read in the machine's master .bashrc file
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Read in the machine specific .bashrc information if it exists
if [ -e ~/.bashrc_custom ]; then
    . ~/.bashrc_custom
fi

# Create an alias for valgrind with some options
alias val='valgrind --track-origins=yes'

# Create an alias for either ls or exa
# Exa is a replacement for ls with git status integration
# https://the.exa.website/
if [ -x "$(command -v exa)" ];
then
	alias ll="pwd; exa -lah --git --color=always"
else
	alias ll="pwd; ls -lah --color=always"
fi

alias grep="/bin/grep --color=always"
alias vr="vi -R"


function cmd_prompt_func() {

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
    TOOLBOX=${BGreen}${On_Blue} # Bold green on blue background


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
    if [ -n "${SSH_CONNECTION}" ];
    then
        CNX=${BYellow}        # Connected on remote machine, via ssh (good).
    elif [[ "${DISPLAY%%:*}" != "" ]];
    then
        CNX=${ALERT}        # Connected on remote machine, not via ssh (bad).
    elif [ -n "${TOOLBOX_CONTAINER}" ];
    then
        CNX=${TOOLBOX}      # Using a toolbox container
    else
        CNX=${BCyan}        # Connected on local machine.
    fi

    # Read the login user, Needed to hack around a stupid Ubuntu bug
    LOGIN_USR=${SUDO_USER:-${USER}}

    # Test user type
    if [[ ${USER} == "root" ]];
    then
        SU=${Red}           # User is root.
    elif [[ ${USER} != ${LOGIN_USR} ]];
    then
        SU=${BRed}          # User is not login user.
    else
        SU=${BCyan}         # User is normal (well ... most of us are).
    fi

    # Check for write privilege in current directory
    if [ ! -w "${PWD}" ];
    then
        WP=${Red}
    else
        WP=${BCyan}
    fi

    # Add git information to the prompt
    branch="$(git symbolic-ref HEAD 2>/dev/null)" || branch=""
    branch=${branch##refs/heads/}
    remote="$(git rev-parse --verify $branch@{upstream} --symbolic-full-name 2>/dev/null)"
    remote=${remote##refs/remotes/}
    gitstatus=""

    if [[ -n $remote ]];
    then
        ahead=$(git rev-list $branch@{upstream}..HEAD 2>/dev/null | wc -l)
        behind=$(git rev-list HEAD..$branch@{upstream} 2>/dev/null | wc -l)
        (( $ahead ))  && gitstatus="$gitstatus+$ahead"
        (( $behind )) && gitstatus="$gitstatus-$behind"
    fi

    git_status=$(git status 2> /dev/null)
    if [[ $git_status =~ 'Your branch is behind' ]];
    then
        GIT_COLOR=${BWhite}${On_Red}
    elif [[ $git_status =~ 'Your branch'.+diverged ]];
    then
        GIT_COLOR=${BWhite}${On_Red}
    elif [[ $git_status =~ 'Your branch is ahead' ]];
    then
        GIT_COLOR=${BWhite}${On_Yellow}
    else
        GIT_COLOR=${BCyan}
    fi

    if [[ -n $branch ]];
    then
        GIT_BASH_PROMPT=" \[$GIT_COLOR\]($branch)\[$NC\]"
    else
        GIT_BASH_PROMPT=""
    fi

    # Tailor the prompt to contain the username, hostname, and current directory
    export PS1="[\[$SU\]\u\[$NC\]@\[$CNX\]\H\[$NC\] \[$WP\]\w$GIT_BASH_PROMPT]$\[$NC\] "
}

# Define the prompt command from above as the terminal's command.
# This will let it be run in the terminal before the next line is printed,
# so that the prompt updates for the new folder.
export PROMPT_COMMAND="cmd_prompt_func"

# A function to assist in path manipulation
# This function comes from: https://unix.stackexchange.com/questions/108873/removing-a-directory-from-path
function path_remove {
  # Delete path by parts so we can never accidentally remove sub paths
  PATH=${PATH//":$1:"/":"} # delete any instances in the middle
  PATH=${PATH/#"$1:"/} # delete any instance at the beginning
  PATH=${PATH/%":$1"/} # delete any instance in the at the end
}

if [ -x "$(command -v direnv)" ];
then
    eval "$(direnv hook bash)"
fi
