#!/usr/bin/env bash

readonly RED=`tput setaf 1`
readonly GREEN=`tput setaf 2`
readonly YELLOW=`tput setaf 3`
readonly GRAY=`tput setaf 232`
readonly BOLD=`tput bold`
readonly CLR=`tput sgr0`

##
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

##
# This is example of print_version() function.
# Define it in your main script and modify for your needs.
#
#print_version() {
#	printf "example.sh ${BOLD}${VERSION}${CLR} by Yancharuk Alexander\n\n"
#}

format_date() {
	printf "$GRAY$(date +'%Y-%m-%d %H:%M:%S')$CLR"

	return 0
}

format_date_dbg() {
	printf "$GRAY$(date +'%Y-%m-%d %H:%M:%S.%N')$CLR"

	return 0
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
	[ ! -z ${DEBUG} ] && printf "[$(format_date_dbg)]: ${GREEN}DEBUG:$CLR $@\n"
}

# Function for operation status
#
# Usage: status MESSAGE STATUS
# Examples:
# status 'Upload scripts' $?
# status 'Run operation' OK
status() {
	if [ -z $1 ] || [ -z $2 ]; then
		error "Not found required parameters!"
		return 1
	fi

	local result=0

	if [ $2 = 'OK' ]; then
		printf "[$(format_date)]: %-60b[$GREEN%s$CLR]\n" "$1" "OK"
	elif [ $2 = 'FAIL' ]; then
		printf "[$(format_date)]: %-60b[$RED%s$CLR]\n" "$1" "FAIL"
		result=1
	elif [ $2 = 0 ]; then
		printf "[$(format_date)]: %-60b[$GREEN%s$CLR]\n" "$1" "OK"
	elif [ $2 > 0 ]; then
		printf "[$(format_date)]: %-60b[$RED%s$CLR]\n" "$1" "FAIL"
		result=1
	fi

	return ${result}
}

# Function for status on some command in debug mode only
status_dbg() {
	[ -z ${DEBUG} ] && return 0

	local result=0

	if [ $2 = 'OK' ]; then
		printf "[$(format_date_dbg)]: ${GREEN}DEBUG:$CLR %-60b[$GREEN%s$CLR]\n" "$1" "$2"
	elif [ $2 = 'FAIL' ]; then
		printf "[$(format_date_dbg)]: ${GREEN}DEBUG:$CLR %-60b[$RED%s$CLR]\n" "$1" "$2"
	elif [ $2 = 0 ]; then
		printf "[$(format_date_dbg)]: ${GREEN}DEBUG:$CLR %-60b[$GREEN%s$CLR]\n" "$1" "$2"
	elif [ $2 > 0 ]; then
		printf "[$(format_date_dbg)]: ${GREEN}DEBUG:$CLR %-60b[$RED%s$CLR]\n" "$1" "$2"
		result=1
	fi

	return ${result}
}

# Function for checking script dependencies
check_dependencies() {
	local result=0

	for i in ${@}; do
		command -v ${i} >/dev/null 2>&1
		if [ $? -eq 0 ]; then
			status_dbg "DEPENDENCY: $i" OK
		else
			warning "$i command not available"
			result=1
		fi
	done

	debug "check_dependencies() result: $result"

	return ${result}
}

parse_options() {
	local result=0

	while getopts :vhd-: param; do
		[ ${param} == '?' ] && found=${OPTARG} || found=${param}

		debug "Found option '$found'"

		case ${param} in
			v ) print_version; exit 0;;
			h ) usage_help; exit 0;;
			d ) DEBUG=1;;
			- ) case $OPTARG in
					version ) print_version; exit 0;;
					help    ) usage_help; exit 0;;
					debug   ) DEBUG=1;;
					*       ) warning "Illegal option --$OPTARG"; result=2;;
				esac;;
			* ) warning "Illegal option -$OPTARG"; result=2;;
		esac
	done
	shift $((OPTIND-1))

	debug "Variable DEBUG: '$DEBUG'"
	debug "parse_options() result: $result"

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

##
# Example for parse_options() with long arguments
#
#parse_options() {
#	local result=0
#	local long_optarg=''
#
#	while getopts :vhd-:b: param; do
#		[ ${param} == '?' ] && found=${OPTARG} || found=${param}
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
