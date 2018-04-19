#!/bin/bash
# This script will configure the path for a specific MATLAB version.
# It first searches the existing path to find all references to MATLAB programs, and removes them.
# Then it re-adds the appropriate path for the desired version.
#
# This script requires the environment variable MATBASE be set to the path that contains the base path
# e.g. /usr/local/MATLAB or /opt/MATLAB


# A path removal function from: https://unix.stackexchange.com/questions/108873/removing-a-directory-from-path
function path_remove {
  # Delete path by parts so we can never accidentally remove sub paths
  PATH=${PATH//":$1:"/":"} # delete any instances in the middle
  PATH=${PATH/#"$1:"/} # delete any instance at the beginning
  PATH=${PATH/%":$1"/} # delete any instance in the at the end
}

# A function to only print stuff out when requested
function disp {
	if [ $PRINT == 1 ];
	then
		printf "$1"
	fi
}

# Check to see if printing is desired
if [ -z $2 ];
then
	PRINT=1
else
	PRINT=0
fi

# Make sure that the user supplied a version
if [ -z $1 ];
then
  disp "Error: Must supply the desired version of MATLAB. Only provide the last 3 characters (e.g. 16b).\n"
  return 1 2> /dev/null || exit 1
else
  # The input is the MATLAB version (last 3 characters)
  MATVER="R20$1"
fi

# The base directory containing the MATLAB installation
if [ -z "$MATBASE" ];
then
	disp "Error: The variable MATBASE must be set to the base MATLAB installation path\n"
	return 1 2> /dev/null || exit 1
fi

# Get all existing MATLAB installations to remove them from the path
EXIST_INSTALL=$(dir $MATBASE)
disp "Detected MATLAB versions:"

MATCH=0
for d in $EXIST_INSTALL; do
	disp " $d"
	
  if [ "$d" == $MATVER ];
  then
    MATCH=1
  fi

  path_remove "$MATBASE/$d/bin"
done

disp "\n"

# Make sure that the MATLAB version is installed
if [ $MATCH == 0 ];
then
  disp "Error: The requested version $MATVER is not installed.\n"
  return 1 2> /dev/null || exit 1
fi

# Do the configuration
disp "\tConfiguring for MATLAB $MATVER\n"

# Configure the path
export PATH="$PATH:$MATBASE/$MATVER/bin"
export MATLAB_JAVA="$MATBASE/$MATVER/sys/java/jre/glnxa64/jre"

#Configure a variable for other use
export MYMATLAB="$MATBASE/$MATVER"
