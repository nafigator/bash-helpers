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
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
GRAY="\e[38;5;242m"
BOLD="\e[1m"
CLR="\e[0m"
DEBUG=
# this variable should be initialized in main() function
#status_length=60

BASH_HELPERS_VERSION=0.6.0

# This is example of usage_help() function.
# Define it in your main script and modify for your needs.
#
#usage_help() {
#  printf "${BOLD}Usage:${CLR}
#  example.sh [OPTIONS...]
#
#${BOLD}Options:${CLR}
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
#print_version() {
#	printf "example.sh ${BOLD}${VERSION}${CLR} by Yancharuk Alexander\n\n"
#}

# Function for datetime output
format_date() {
	printf "$GRAY$(date +%Y-%m-%d\ %H:%M:%S)$CLR"
}

# Function for error messages
error() {
	printf "[$(format_date)]: ${RED}ERROR:$CLR $@\n" >&2
}

# Function for informational messages
inform() {
	printf "[$(format_date)]: ${GREEN}INFO:$CLR $@\n"
}

# Function for warning messages
warning() {
	printf "[$(format_date)]: ${YELLOW}WARNING:$CLR $@\n" >&2
}

# Function for debug messages
debug() {
	[ ! -z ${DEBUG} ] && printf "[$(format_date)]: ${GREEN}DEBUG:$CLR $@\n"
}

# Function for operation status
#
# Usage: status MESSAGE STATUS
# Examples:
#     status 'Upload scripts' $?
#     status 'Run operation' OK
status() {
	if [ -z "$1" ] || [ -z "$2" ]; then
		error 'status(): not found required parameters!'
		return 1
	fi

	local result=0

	if [ $2 = 'OK' ]; then
		printf "[$(format_date)]: %-${status_length}b[$GREEN%s$CLR]\n" "$1" 'OK'
	elif [ $2 = 'FAIL' ]; then
		printf "[$(format_date)]: %-${status_length}b[$RED%s$CLR]\n" "$1" 'FAIL'
		result=1
	elif [ $2 = 0 ]; then
		printf "[$(format_date)]: %-${status_length}b[$GREEN%s$CLR]\n" "$1" 'OK'
	elif [ $2 -gt 0 ]; then
		printf "[$(format_date)]: %-${status_length}b[$RED%s$CLR]\n" "$1" 'FAIL'
		result=1
	fi

	return ${result}
}

# Function for status on some command in debug mode only
status_dbg() {
	[ -z ${DEBUG} ] && return 0

	if [ -z "$1" ] || [ -z "$2" ]; then
		error 'status_dbg(): not found required parameters!'
		return 1
	fi

	local length=$(( ${status_length} - 7 ))
	local result=0

	#debug "status_dbg length: $length"

	if [ $2 = 'OK' ]; then
		printf "[$(format_date)]: ${GREEN}DEBUG:$CLR %-${length}b[$GREEN%s$CLR]\n" "$1" 'OK'
	elif [ $2 = 'FAIL' ]; then
		printf "[$(format_date)]: ${GREEN}DEBUG:$CLR %-${length}b[$RED%s$CLR]\n" "$1" 'FAIL'
	elif [ $2 = 0 ]; then
		printf "[$(format_date)]: ${GREEN}DEBUG:$CLR %-${length}b[$GREEN%s$CLR]\n" "$1" 'OK'
	elif [ $2 -gt 0 ]; then
		printf "[$(format_date)]: ${GREEN}DEBUG:$CLR %-${length}b[$RED%s$CLR]\n" "$1" 'FAIL'
		result=1
	fi

	return ${result}
}

# Function for update status formatting length for longest string in array
# Example:
#     update_status_length ${strings_array}
update_status_length() {
	for i in ${@}; do
		debug "Element length: ${#i}"
		debug "STATUS_LENGTH before check: ${status_length}"
		if [ ${#i} -gt $(( ${status_length} - 11 )) ]; then
			status_length=$(( ${status_length} + $(( ${#i} - ${status_length} + 12 ))  ))
			debug "NEW STATUS_LENGTH: $status_length"
		fi

	done
}

# Function for checking script dependencies
check_dependencies() {
	local result=0
	local cmd_status

	for i in ${@}; do
		command -v ${i} >/dev/null 2>&1
		cmd_status=$?

		#status_dbg "DEPENDENCY: $i" ${cmd_status}

		if [ ${cmd_status} -ne 0 ]; then
			warning "$i command not available"
			result=1
		fi
	done

	#debug "check_dependencies() result: $result"

	return ${result}
}

# Convert string value to float
float() {
	if [ ${1} = '""' ] || [ -z ${1} ]; then
		echo 0
		return 0
	fi

	echo $(echo ${1} | sed 's/,/\./' | bc -l)

	return 0
}

# Include script
#
# Example:
#     include reload # load /usr/local/share/bash/includes/reload.sh
#     include google/client # load /usr/local/share/bash/includes/google/client.sh
function include() {
	local result=0
	local readonly includes_dir=/usr/local/share/bash/includes
	local readonly file="$includes_dir/$1.sh"

	if [ -f "$file" ]; then
		debug "Found file: $file"
		. "$file"
		status_dbg "File included" $?
	else
		result=1
	fi

	return ${result}
}

# Bash-helpers variables cleanup
helpers_cleanup() {
	unset RED
	unset GREEN
	unset YELLOW
	unset GRAY
	unset BOLD
	unset CLR

	unset BASH_HELPERS_VERSION
	unset DEBUG
	unset status_length
}

# Example for parse_options() with short arguments only
# Define it in your main script and modify for your needs.
#
#parse_options() {
#	local result=0
#
#	while getopts :vhd-: param; do
#		[ ${param} = '?' ] && found=${OPTARG} || found=${param}
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

# Example for parse_options() with long arguments
# Define it in your main script and modify for your needs.
#
#parse_options() {
#	local result=0
#	local long_optarg=''
#
#	while getopts :vhd-:b: param; do
#		[ ${param} = '?' ] && found=${OPTARG} || found=${param}
#
#		debug "Found option '$found'"
#
#		case ${param} in
#			v ) print_version; exit 0;;
#			h ) usage_help; exit 0;;
#			d ) DEBUG=1;;
#			b ) BRANCH=$OPTARG;;
#			- ) long_optarg="${OPTARG#*=}"
#				case $OPTARG in
#					version   ) print_version; exit 0;;
#					help      ) usage_help; exit 0;;
#					debug     ) DEBUG=1;;
#					long_opt=?* ) BRANCH=${long_optarg};;
#					*         ) warning "Illegal option --$OPTARG"; result=2;;
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
get_config_bool() {
	local value=$(git config --bool $1)
	local result=0

	if [ "$value" == 'true' ]; then
		echo 1
	fi

	return ${result}
}
