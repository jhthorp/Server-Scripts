#!/bin/bash
################################################################################
#                 Upload Scripts To TrueNAS And Start Burn-In                  #
#                                                                              #
#              This script will export a single function that will             #
#           create a scripts bundle and upload it to a server before           #
#                             starting the script                              #
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
. "$(DIR)/upload_and_run_command.sh"

################################################################################
#                                  FUNCTIONS                                   #
################################################################################
#===============================================================================
# This function will convert a relative path into an absolute path.
#
# GLOBALS / SIDE EFFECTS:
#   N_A - N/A
#
# OPTIONS:
#   [-na] N/A
#
# ARGUMENTS:
#   [1 - relPath] A relative path
#
# OUTPUTS:
#   absPath - The absolute path
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
REL_TO_ABS_PATH () {
  local relPath="${1}"

  # Convert any relative paths into absolute paths
  local TMP_ABS_PATH=$(cd ${relPath}; printf %s. "$PWD")
  TMP_ABS_PATH=${TMP_ABS_PATH%?}

  # Return the absolute path
  echo "${TMP_ABS_PATH}"
}

#===============================================================================
# This function will create a scripts bundle and upload it to a server 
# before starting the script.
#
# GLOBALS / SIDE EFFECTS:
#   N_A - N/A
#
# OPTIONS:
#   [-na] N/A
#
# ARGUMENTS:
#   [1 - srcDir] The source directory
#   [2 - host] The host address to connect to
#   [3 - port] The port to connect on
#   [4 - remote_user] The user to connect with
#   [5 - script_to_run] The script to execute
#
# OUTPUTS:
#   N/A - N/A
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
upload_and_run_script ()
{
  local srcDir=$(REL_TO_ABS_PATH ${1})
  local host="${2}"
  local port="${3}"
  local remote_user=${4-root}
  local script_to_run=${5-""}

  # Local Variables
  local REMOTE_SCRIPTS_DIR="/${remote_user}/_Scripts"
  local SCRIPT_CMD="cd ${REMOTE_SCRIPTS_DIR} && bash ./${script_to_run}"

  # Remotely run a command from the bundle
  upload_and_run_command \
    "$(REL_TO_ABS_PATH ${srcDir})" \
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

  # If not prompting the user
  if [ "${1}" = "auto_skip" ]
  then
    # Remove the auto_skip parameter
    shift

    # Start the script
    upload_and_run_script "${@}"
  else
    # Start the script
    upload_and_run_script "${@}"
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