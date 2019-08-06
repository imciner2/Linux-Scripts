#!/bin/bash
# This contains several helper functions for running setup scripts


###############################################################
# A function to remove a specific directory from the path
# https://unix.stackexchange.com/questions/108873/removing-a-directory-from-path
#
# @param $1 path to remove
###############################################################
function path_remove {
  # Delete path by parts so we can never accidentally remove sub paths
  PATH=${PATH//":$1:"/":"} # delete any instances in the middle
  PATH=${PATH/#"$1:"/} # delete any instance at the beginning
  PATH=${PATH/%":$1"/} # delete any instance in the at the end
}


###############################################################
# A function to only print stuff out when requested
#
# This function requires that the variable $PRINT is set to 1 to
# print, or 0 to not print.
#
# @param $1 information to print
###############################################################
function disp_setup {
  if [ -z $1 ];
  then
    PRINT=1
  else
    PRINT=0
  fi
}

###############################################################
# A function to only print stuff out when requested
#
# This function requires that the variable $PRINT is set to 1 to
# print, or 0 to not print.
#
# @param $1 information to print
###############################################################
function disp {
  if [ $PRINT == 1 ];
  then
    printf "$1"
  fi
}


###############################################################
# A function to print an error to stderr
# This will automatically prepend "Error:" and append a new line
#
# @param $1 the error to print to stderr
# @param $2 whether to exit the script
###############################################################
function disp_err {
  printf "Error: $1\n" >&2
  ECODE=1
}


###############################################################
# Function to print out the installed versions
#
# @param $1 array containing the installed versions
###############################################################
function print_cur_ver {
  disp "Current version: "

  for d in $1;
  do
    if [[ "$PATH" =~ $d ]]
    then
      disp "$d"
      break
    fi
  done

  disp "\n"
}


###############################################################
# Function to print out the installed versions
#
# @param $1 the name of the program
# @param $2 array containing the installed versions
###############################################################
function print_all_vers {
  disp "Detected $1 versions:"

  for d in $2; do
    disp " $d"
  done

  disp "\n"
}
