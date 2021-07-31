#!/usr/bin/env bash

#Copyright (c) 2017-2021 Yancharuk Alexander
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

# shellcheck disable=SC2034
readonly BASH_HELPERS_VERSION=1.0.2

INTERACTIVE=$([[ -t 0 && -t 1 ]] && echo 1)
DEBUG=

# https://en.wikipedia.org/wiki/ANSI_escape_code
function black() {
	[[ -z ${INTERACTIVE} ]] || printf "\e[30m"
}

function red() {
	[[ -z ${INTERACTIVE} ]] || printf "\e[31m"
}

function green() {
	[[ -z ${INTERACTIVE} ]] || printf "\e[32m"
}

function yellow() {
	[[ -z ${INTERACTIVE} ]] || printf "\e[33m"
}

function blue() {
	[[ -z ${INTERACTIVE} ]] || printf "\e[34m"
}

function magenta() {
	[[ -z ${INTERACTIVE} ]] || printf "\e[35m"
}

function cyan() {
	[[ -z ${INTERACTIVE} ]] || printf "\e[36m"
}

function white() {
	[[ -z ${INTERACTIVE} ]] || printf "\e[37m"
}

function gray() {
	[[ -z ${INTERACTIVE} ]] || printf "\e[38;5;242m"
}

function bold() {
	[[ -z ${INTERACTIVE} ]] || printf "\e[1m"
}

function clr() {
	[[ -z ${INTERACTIVE} ]] || printf "\e[0m"
}

# This is variable should be redefined
VERSION=

# This is example of usage_help() function.
# Define it in your main script and modify for your needs.
#function usage_help() {
#  printf "$(bold)Usage:$(clr)
#  example.sh [OPTIONS...]
#
#$(bold)Options:$(clr)
#  -v, --version              Show script version
#  -h, --help                 Show this help message
#  -d, --debug                Run program in debug mode
#
#"
#
#	return 0
#}

# This is example of print_version() function.
# Define it in your main script and modify for your needs.
#function print_version() {
#	printf "example.sh $(bold)${VERSION}$(clr) by Yancharuk Alexander\n"
#	printf "bash-helpers.sh $(bold)${BASH_HELPERS_VERSION}$(clr)\n\n"
#}

# Function for datetime output
function format_date() {
	printf "%s%s%s" "$(gray)" "$(date +%Y-%m-%d\ %H:%M:%S)" "$(clr)"
}

# Function for error messages
function error() {
	printf "[%s]:[%sERROR%s] $1\n" "$(format_date)" "$(red)" "$(clr)" >&2
}

# Function for informational messages
function inform() {
	printf "[%s]:[%sINFO%s] $1\n" "$(format_date)" "$(green)" "$(clr)"
}

# Function for warning messages
function warning() {
	printf "[%s]:[%sWARN%s] $1\n" "$(format_date)" "$(yellow)" "$(clr)" >&2
}

# Function for debug messages
function debug() {
	[ -z "$DEBUG" ] || printf "[%s]:[%s ?? %s] $1\n" "$(format_date)" "$(gray)" "$(clr)"
}

# Function for operation status
#
# Usage: status MESSAGE STATUS
# Examples:
#     status 'Upload scripts' $?
#     status 'Run operation' OK
#     status 'Run operation' FAIL
function status() {
	if [[ -z $1 ]] || [[ -z $2 ]]; then
		error 'status(): not found required parameters!'
		return 1
	fi

	local result=0
	# shellcheck disable=SC2155
	local -r ok_msg="[$(format_date)]:[$(green)%s$(clr)] "
	# shellcheck disable=SC2155
	local -r err_msg="[$(format_date)]:[$(red)%s$(clr)] "

	if [[ $2 = OK ]]; then
		printf "$ok_msg%b\n" ' OK ' "$1"
	elif [[ $2 = FAIL ]]; then
		printf "$err_msg%b\n" FAIL "$1"
		result=1
	elif [[ $2 = 0 ]]; then
		printf "$ok_msg%b\n" ' OK ' "$1"
	elif [[ $2 -gt 0 ]]; then
		printf "$err_msg%b\n" FAIL "$1"
		result=1
	fi

	return ${result}
}

# Function for status on some command in debug mode only
# Examples:
#     status_dbg 'Debug operation status' $?
#     status_dbg 'Debug operation status' OK
#     status_dbg 'Debug operation status' FAIL
function status_dbg() {
	[ -z "$DEBUG" ] && return 0

	if [[ -z $1 ]] || [[ -z $2 ]]; then
		error 'status_dbg(): not found required parameters!'
		return 1
	fi

	local result=0
	# shellcheck disable=SC2155
	local -r ok_msg="[$(format_date)]:[$(green)%s$(clr)] "
	# shellcheck disable=SC2155
	local -r err_msg="[$(format_date)]:[$(red)%s$(clr)] "

	if [[ $2 = OK ]]; then
		printf "$ok_msg%b\n" ' ++ ' "$1"
	elif [[ $2 = FAIL ]]; then
		printf "$err_msg%b\n" ' -- ' "$1"
	elif [[ $2 = 0 ]]; then
		printf "$ok_msg%b\n" ' ++ ' "$1"
	elif [[ $2 -gt 0 ]]; then
		printf "$err_msg%b\n" ' -- ' "$1"
		result=1
	fi

	return ${result}
}

# Function for checking script dependencies
function check_dependencies() {
	local result=0
	local code

	for cmd in "${@}"; do
		command -v "$cmd" >/dev/null 2>&1
		code=$?

		status_dbg "DEPENDENCY: $cmd" ${code}

		if [[ ${code} -ne 0 ]]; then
			warning "$(bold)$(blue)$cmd$(clr) command not available"
			result=1
		fi
	done

	debug "check_dependencies() result: $result"

	return ${result}
}

# Convert string value to float
function float() {
	if [ "$1" = '""' ] || [ -z "$1" ]; then
		echo 0
		return 0
	fi

	echo "$1" | sed 's/,/\./' | bc -l

	return 0
}

# Include function
#
# Example:
#     include reload # load /usr/local/lib/bash/includes/reload.sh
#     include google/client # load /usr/local/lib/bash/includes/google/client.sh
function include() {
	local result=0
	local -r includes_dir=/usr/local/lib/bash/includes
	local -r file="$includes_dir/$1.sh"

	if [[ -f "$file" ]]; then
		debug "Found file: $file"
		# shellcheck source=stub.sh
		. "$file"
		status_dbg "File included" $?
	else
		result=1
	fi

	return ${result}
}

# Redefine it in your main script and modify for your needs.
# Usage:
#	parse_options ${@}
#	PARSE_RESULT=$?
#
#	[[ ${PARSE_RESULT} = 1 ]] && exit 1
#	[[ ${PARSE_RESULT} = 2 ]] && usage_help && exit 2
#
# Long arguments (--target=value) example:
#	while getopts vhdt:-: param; do
#		[[ ${param} = '?' ]] && found=${OPTARG} || found=${param}
#
#		debug "Found option '$found'"
#
#		case ${param} in
#			v ) print_version; exit 0;;
#			h ) usage_help; exit 0;;
#			d ) DEBUG=1;;
#			t ) TARGET=${OPTARG};;
#			- ) local value="${OPTARG#*=}"
#				case $OPTARG in
#					version ) print_version; exit 0;;
#					help    ) usage_help; exit 0;;
#					debug   ) DEBUG=1;;
#					target  ) TARGET=${value};;
#					*       ) warning "Illegal option --$OPTARG"; result=2;;
#				esac;;
#			* ) warning "Illegal option -$OPTARG"; result=2;;
#		esac
#	done
function parse_options() {
	local result=0
	OPTIND=1

	while getopts vhd-: param; do
		[[ ${param} = '?' ]] && found=${OPTARG} || found=${param}

		debug "Found option '$found'"

		case ${param} in
			v ) print_version; exit 0;;
			h ) usage_help; exit 0;;
			d ) DEBUG=1;;
			- ) local value="${OPTARG#*=}"
				case $OPTARG in
					version ) print_version; exit 0;;
					help    ) usage_help; exit 0;;
					debug   ) DEBUG=1;;
					*       ) warning "Illegal option --$OPTARG"; result=2;;
				esac;;
			* ) warning "Illegal option -$OPTARG"; result=2;;
		esac
	done

	shift $((OPTIND-1)) # remove parsed options and args from $@ list

	debug "Variable DEBUG: '$DEBUG'"
	debug "parse_options() result: $result"

	return ${result}
}

# Function for getting bool values from git config
# Echoes 1 on ok_msg
# Usage:
#	git_config_bool $PARAM $PROJECT_PATH
function git_config_bool() {
	local path=
	local result=0
	local value

	if [[ -n $2 ]]; then
		path="-C $2"
	fi

	value=$(git "$path" config --bool "$1")

	if [[ ${value} == true ]]; then
		echo 1
	fi

	return ${result}
}
