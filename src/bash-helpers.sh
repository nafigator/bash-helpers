#!/usr/bin/env bash

#Copyright (c) 2017-2019 Yancharuk Alexander
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

# https://en.wikipedia.org/wiki/ANSI_escape_code
function red() {
    printf "\e[31m"
}

function green() {
	printf "\e[32m"
}

function yellow() {
	printf "\e[33m"
}

function gray() {
	printf "\e[38;5;242m"
}

function bold() {
	printf "\e[1m"
}

function clr() {
	printf "\e[0m"
}

function bash_helpers_version() {
	printf '0.9.0'
}

# Example of version function
#function version() {
#	printf '1.0.0'
#}

# This is example of usage_help() function.
# Define it in your main script and modify for your needs.
#
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
#
#function print_version() {
#	printf "example.sh $(bold)${version}$(clr) by Yancharuk Alexander\n"
#	printf "bash-helpers.sh $(bold)$(bash_helpers_version)$(clr)\n\n"
#}

# Function for datetime output
function format_date() {
	printf "$(gray)$(date +%Y-%m-%d\ %H:%M:%S)$(clr)"
}

# Function for error messages
function error() {
	printf "[$(format_date)]:[$(red)FAIL$(clr)] $1\n" >&2
}

# Function for informational messages
function inform() {
	printf "[$(format_date)]:[$(green)INFO$(clr)] $1\n"
}

# Function for warning messages
function warning() {
	printf "[$(format_date)]:[$(yellow)WARN$(clr)] $1\n" >&2
}

# Function for debug messages
function debug() {
	[[ -z ${DEBUG} ]] || printf "[$(format_date)]:[$(green) ?? $(clr)] $1\n"
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
	local readonly success="[$(format_date)]:[$(green)%s$(clr)] "
	local readonly error="[$(format_date)]:[$(red)%s$(clr)] "

	if [[ $2 = OK ]]; then
		printf "$success%b\n" ' OK ' "$1"
	elif [[ $2 = FAIL ]]; then
		printf "$error%b\n" FAIL "$1"
		result=1
	elif [[ $2 = 0 ]]; then
		printf "$success%b\n" ' OK ' "$1"
	elif [[ $2 -gt 0 ]]; then
		printf "$error%b\n" FAIL "$1"
		result=1
	fi

	return ${result}
}

# Function for status on some command in debug mode only
function status_dbg() {
	[[ -z ${DEBUG} ]] && return 0

	if [[ -z $1 ]] || [[ -z $2 ]]; then
		error 'status_dbg(): not found required parameters!'
		return 1
	fi

	local result=0
	local readonly success="[$(format_date)]:[$(green)%s$(clr)] "
	local readonly error="[$(format_date)]:[$(red)%s$(clr)] "

	if [[ $2 = OK ]]; then
		printf "$success%b\n" ' ++ ' "$1"
	elif [[ $2 = FAIL ]]; then
		printf "$error%b\n" ' -- ' "$1"
	elif [[ $2 = 0 ]]; then
		printf "$success%b\n" ' ++ ' "$1"
	elif [[ $2 -gt 0 ]]; then
		printf "$error%b\n" ' -- ' "$1"
		result=1
	fi

	return ${result}
}

# Function for checking script dependencies
function check_dependencies() {
	local result=0
	local cmd_status

	for i in ${@}; do
		command -v ${i} >/dev/null 2>&1
		cmd_status=$?

		status_dbg "DEPENDENCY: $i" ${cmd_status}

		if [[ ${cmd_status} -ne 0 ]]; then
			warning "$i command not available"
			result=1
		fi
	done

	debug "check_dependencies() result: $result"

	return ${result}
}

# Convert string value to float
function float() {
	if [[ $1 = '""' ]] || [[ -z $1 ]]; then
		echo 0
		return 0
	fi

	echo $(echo $1 | sed 's/,/\./' | bc -l)

	return 0
}

# Include function
#
# Example:
#     include reload # load /usr/local/lib/bash/includes/reload.sh
#     include google/client # load /usr/local/lib/bash/includes/google/client.sh
function include() {
	local result=0
	local readonly includes_dir=/usr/local/lib/bash/includes
	local readonly file="$includes_dir/$1.sh"

	if [[ -f "$file" ]]; then
		debug "Found file: $file"
		. "$file"
		status_dbg "File included" $?
	else
		result=1
	fi

	return ${result}
}

# Define it in your main script and modify for your needs.
# Usage:
#	parse_options $@
#function parse_options() {
#	local result=0
#
#	while getopts :vhd-: param; do
#		[[ ${param} = '?' ]] && found=${OPTARG} || found=${param}
#
#		debug "Found option '$found'"
#
#		case ${param} in
#			v ) print_version; exit 0;;
#			h ) usage_help; exit 0;;
#			d ) DEBUG=1;;
#			- ) case $OPTARG in
#					version ) print_version; exit 0;;
#					help    ) usage_help; exit 0;;
#					debug   ) DEBUG=1;;
#					*       ) warning "Illegal option --$OPTARG"; result=2;;
#				esac;;
#			* ) warning "Illegal option -$OPTARG"; result=2;;
#		esac
#	done
#	shift $((OPTIND-1))
#
#	debug "Variable DEBUG: '$DEBUG'"
#	debug "parse_options() result: $result"
#
#	return ${result}
#}

# Function for getting bool values from git config
# Echoes 1 on success
function get_config_bool() {
	local value=$(git config --bool $1)
	local result=0

	if [[ ${value} == true ]]; then
		echo 1
	fi

	return ${result}
}
