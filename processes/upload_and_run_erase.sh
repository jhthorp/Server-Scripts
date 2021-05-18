#!/bin/bash
################################################################################
#                 Upload Scripts To TrueNAS And Start Burn-In                  #
#                                                                              #
#              This script will export a single function that will             #
#       create a Utility scripts bundle and upload it to a server before       #
#                          starting the Erase process                          #
################################################################################
#       Copyright © 2020 - 2021, Jack Thorp and associated contributors.       #
#                                                                              #
#    This program is free software: you can redistribute it and/or modify      #
#    it under the terms of the GNU General Public License as published by      #
#    the Free Software Foundation, either version 3 of the License, or         #
#    any later version.                                                        #
#                                                                              #
#    This program is distributed in the hope that it will be useful,           #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of            #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             #
#    GNU General Public License for more details.                              #
#                                                                              #
#    You should have received a copy of the GNU General Public License         #
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.    #
################################################################################

################################################################################
#                                 SCRIPT SETUP                                 #
################################################################################
#===============================================================================
# This section will store some "Process Global" variables into a stack that
# fully supports nesting into the upcoming includes so that these variables
# are correctly held intact.
#
# The following variables are currently being stored:
#    0 - SOURCING_INVOCATION - Boolean - If the script was sourced not invoked
#    1 - DIR - String - The script's directory path
#===============================================================================
# Get the global stack if it exists
if [ -z ${stack_vars+x} ]; 
then 
  declare stack_vars=(); 
fi

# Determine the BASH source (SOURCING_INVOCATION)
(return 0 2>/dev/null) &&
stack_vars[${#stack_vars[@]}]=1 || 
stack_vars[${#stack_vars[@]}]=0

# Determine the exectuable directory (DIR)
DIR_SRC="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR_SRC}" ]];
then
  DIR_SRC="${PWD}";
fi

# Convert any relative paths into absolute paths
DIR_SRC=$(cd ${DIR_SRC}; printf %s. "$PWD")
DIR_SRC=${DIR_SRC%?}

# Copy over the DIR source and remove the temporary variable
stack_vars[${#stack_vars[@]}]=${DIR_SRC}
unset DIR_SRC

# Add Functional Aliases
SOURCING_INVOCATION () { echo "${stack_vars[${#stack_vars[@]}-2]}"; }
DIR () { echo "${stack_vars[${#stack_vars[@]}-1]}"; }

################################################################################
#                               SCRIPT INCLUDES                                #
################################################################################
. "$(DIR)/../general/upload_and_run_script.sh"

################################################################################
#                                  FUNCTIONS                                   #
################################################################################
#===============================================================================
# This function will grab this script's working directory as an absolute path.
#
# GLOBALS / SIDE EFFECTS:
#   N_A - N/A
#
# OPTIONS:
#   [-na] N/A
#
# ARGUMENTS:
#   [1 - N/A] N/A
#
# OUTPUTS:
#   N/A - N/A
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
SCRIPT_DIR () {
  # Determine the exectuable directory (DIR)
  declare DIR_SRC="${BASH_SOURCE%/*}"
  if [[ ! -d "${DIR_SRC}" ]];
  then
    DIR_SRC="${PWD}";
  fi

  # Convert any relative paths into absolute paths
  DIR_SRC=$(cd ${DIR_SRC}; printf %s. "$PWD")
  DIR_SRC=${DIR_SRC%?}

  # Copy over the DIR source and remove the temporary variable
  echo "${DIR_SRC}"
}

#===============================================================================
# This function will create a Utility scripts bundle and upload it to a server 
# before starting the Erase process.
#
# GLOBALS / SIDE EFFECTS:
#   N_A - N/A
#
# OPTIONS:
#   [-na] N/A
#
# ARGUMENTS:
#   [1 - host] The host address to connect to
#   [2 - port] The port to connect on
#   [3 - remote_user] The user to connect with
#   [4 - drives_override] The array of drive IDs to burn-in
#   [5 - session_suffix] The suffix to add to the session name
#   [6 - end_on_detach] The switch to end the process when the TMUX session is 
#                       detached
#
# OUTPUTS:
#   N/A - N/A
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
upload_and_run_erase ()
{
  declare -r host="${1}"
  declare -r port="${2}"
  declare -r remote_user=${3-root}
  declare -r drives_override=${4-null}
  declare -r session_suffix=${5-null}
  declare -r end_on_detach=${6-false}

  # Local Variables
  declare -r CUR_DIR=$(SCRIPT_DIR)
  declare -r AUTOMATED_SKIP="auto_skip"
  declare -r SCRIPT="Drive-Scripts/erase/erase_drives.sh"
  declare -r SCRIPT_PARAMS_TMUX="\"${session_suffix}\" ${end_on_detach}"
  declare -r SCRIPT_PARAMS="\"${drives_override}\" ${SCRIPT_PARAMS_TMUX}"
  declare -r SCRIPT_PARAMS_AUTO="${AUTOMATED_SKIP} ${SCRIPT_PARAMS}"
  declare -r SCRIPT_CMD="${SCRIPT} ${SCRIPT_PARAMS_AUTO}"

  # Upload and Remotely run a script from the bundle
  echo "Beginning the Erase process.."
  upload_and_run_script \
    "${CUR_DIR}/../Drive-Scripts" \
    ${host} \
    ${port} \
    "${remote_user}" \
    "${SCRIPT_CMD}"
}

################################################################################
#                               SCRIPT EXECUTION                               #
################################################################################
#===============================================================================
# This section will execute if the script is invoked from the terminal rather 
# than sourced into another script as a function.  If the first parameter is 
# "auto_skip" then any prompts will be bypassed.
#
# GLOBALS / SIDE EFFECTS:
#   N_A - N/A
#
# OPTIONS:
#   [-na] N/A
#
# ARGUMENTS:
#   [ALL] All arguments are passed into the script's function except the first 
#         if it is "auto_skip".
#
# OUTPUTS:
#   N/A - N/A
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
if [ $(SOURCING_INVOCATION) = 0 ];
then
  # Print a copyright/license header
  cat << EOF
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
| Copyright © 2020 - 2021, Jack Thorp and associated contributors.  |
|          This program comes with ABSOLUTELY NO WARRANTY.          |
|   This is free software, and you are welcome to redistribute it   |
|                     under certain conditions.                     |
|        See the GNU General Public License for more details.       |
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOF

  # Print a disclaimer
  cat << EOF

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!                             WARNING                             !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!       BY PROCEEDING, ALL DATA ON DISKS WILL BE DESTROYED        !!
!!       STOP AND DO NOT RUN IF DISKS CONTAIN VALUABLE DATA        !!
!!                                                                 !!
!!  DEPENDING ON DISK SIZES, THE RUNTIME CAN EXCEED SEVERAL DAYS   !!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
EOF

  if [ "${1}" = "auto_skip" ]
  then
    # Remove the auto_skip parameter
    shift

    # Start the script
    upload_and_run_erase "${@}"
  else
    CONTINUE=false
    read -p "Would you like to continue (y/n)?" choice
    case "$choice" in 
      y|Y ) CONTINUE=true;;
      n|N ) CONTINUE=false;;
      * ) echo "Invalid Entry";;
    esac

    if [ "${CONTINUE}" = true ]
    then
        # Start the script
        unset CONTINUE
        upload_and_run_erase "${@}"
    fi
    unset CONTINUE
  fi
fi

################################################################################
#                                SCRIPT TEARDOWN                               #
################################################################################
#===============================================================================
# This section will remove the "Process Global" variables from the stack
#===============================================================================
unset stack_vars[${#stack_vars[@]}-1] # DIR
unset stack_vars[${#stack_vars[@]}-1] # SOURCING_INVOCATION