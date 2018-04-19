#!/bin/bash
# This script will configure the path for a specific Xilinx version.
# It first searches the existing path to find all references to Xilinx programs, and removes them.
# Then it re-adds the appropriate path for the desired version.
#
# This script requires the environment variable XILBASE be set to the path that contains the base path
# e.g. /opt/Xilinx

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
  disp "Error: Must supply the desired version of Xilinx tools.\n"
  return 1 2> /dev/null || exit 1
else
  # The input is the Xilinx version
  XILVER=$1
fi

# The base directory containing the MATLAB installation
if [ -z "$XILBASE" ];
then
	disp "Error: The variable XILBASE must be set to the base Xilinx installation path\n"
	return 1 2> /dev/null || exit 1
fi

# Get all existing MATLAB installations to remove them from the path
EXIST_INSTALL=$(dir "$XILBASE/Vivado")
disp "Detected Xilinx versions:"

MATCH=0
for d in $EXIST_INSTALL; do
	disp " $d"

  if [ "$d" == $XILVER ];
  then
    MATCH=1
  fi

	path_remove "$XILBASE/Vivado/$d/bin"
	path_remove "$XILBASE/Vivado_HLS/$d/bin"
	path_remove "$XILBASE/SDK/$d/bin"
done

disp "\n"

# Make sure that the Xilinx version is installed
if [ $MATCH == 0 ];
then
  disp "Error: The requested version $XILVER is not installed.\n"
  return 1 2> /dev/null || exit 1
fi

# Do the configuration
disp "\tConfiguring for Xilinx $XILVER\n"

# Configure the path
export PATH="$PATH:$XILBASE/Vivado/$XILVER/bin"
export PATH="$PATH:$XILBASE/Vivado_HLS/$XILVER/bin"
export PATH="$PATH:$XILBASE/SDK/$XILVER/bin"
