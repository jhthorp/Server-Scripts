#!/bin/bash
################################################################################
#                           Upload Scripts To Server                           #
#                                                                              #
#              This script will export a single function that will             #
#              create a scripts bundle and upload it to a server               #
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
. "$(DIR)/../../Bundler-Scripts/create_bundle.sh"
. "$(DIR)/../../Utility-Scripts/ssh/run_command.sh"
. "$(DIR)/../../Utility-Scripts/scp/scp_to_remote.sh"

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
#   scriptDir - The absolute script directory path
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
SCRIPT_DIR () {
  # Determine the exectuable directory (DIR)
  local TMP_DIR_SRC="${1}"
  if [[ ! -d "${TMP_DIR_SRC}" ]];
  then
    TMP_DIR_SRC="${PWD}";
  fi

  echo $(REL_TO_ABS_PATH "${TMP_DIR_SRC}")
}

#===============================================================================
# This function will create a scripts bundle and upload it to a server.
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
#
# OUTPUTS:
#   N/A - N/A
#
# RETURN:
#   0 - SUCCESS
#   Non-Zero - ERROR
#===============================================================================
upload_bundle ()
{
  local srcDir=$(REL_TO_ABS_PATH ${1})
  local host="${2}"
  local port="${3}"
  local remote_user=${4-root}

  # Local Variables
  local SCRIPT_SRC="${BASH_SOURCE%/*}"
  local CUR_DIR=$(SCRIPT_DIR ${SCRIPT_SRC})
  local REMOTE_SCRIPTS_DIR="/${remote_user}/_Scripts"
  local RMDIR_SCRIPTS_CMD="rm -rf ${REMOTE_SCRIPTS_DIR}"
  local MKDIR_SCRIPTS_CMD="mkdir ${REMOTE_SCRIPTS_DIR}"
  local CD_SCRIPTS_CMD="cd ${REMOTE_SCRIPTS_DIR}"
  local RM_SCRIPTS_CMD="${RMDIR_SCRIPTS_CMD} && ${MKDIR_SCRIPTS_CMD}"
  local CLEANUP_TMP_CMD="mv ./Scripts/* . && rm -rf ./Scripts"
  local CLEANUP_SCRIPTS_CMD="rm -f ./Scripts.zip"
  local CLEANUP_CMD="${CLEANUP_TMP_CMD} && ${CLEANUP_SCRIPTS_CMD}"
  local UNZIP_SCRIPTS_CMD="unzip -q ./Scripts.zip && ${CLEANUP_CMD}"
  local FULL_UNZIP_SCRIPTS_CMD="${CD_SCRIPTS_CMD} && ${UNZIP_SCRIPTS_CMD}"

  # Create the bundle
  echo "Creating the bundle..."
  $(create_bundle \
    "$(REL_TO_ABS_PATH "${srcDir}")" \
    "Scripts" \
  )  

  # Removing any existing Scripts
  echo "Removing any existing scripts..."
  $(run_command \
    ${host} \
    ${port} \
    "${remote_user}" \
    "${RM_SCRIPTS_CMD}" \
  )

  # Upload the bundle
  echo "Uploading the new scripts bundle..."
  $(scp_to_remote \
    ${host} \
    ${port} \
    "${remote_user}" \
    "$(REL_TO_ABS_PATH "${CUR_DIR}/../../_bundles")/Scripts.zip" \
    "${REMOTE_SCRIPTS_DIR}/Scripts.zip" \
  )

  # Unzip the bundle
  echo "Unzipping the bundle..."
  $(run_command \
    ${host} \
    ${port} \
    "${remote_user}" \
    "${FULL_UNZIP_SCRIPTS_CMD}" \
  )
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
    upload_bundle "${@}"
  else
    # Start the script
    upload_bundle "${@}"
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