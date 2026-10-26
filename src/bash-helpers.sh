# Library. Intended to be sourced.

#Copyright (c) 2017-2026 Yancharuk Alexander
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

# Guard against double source
[[ -n ${_BASH_HELPERS_LOADED:-} ]] && return 0
readonly _BASH_HELPERS_LOADED=1

# shellcheck disable=SC2034
readonly BASH_HELPERS_VERSION=1.1.8

readonly BASH_HELPERS_SCRIPT_PATH=$(realpath -e "$0" 2>/dev/null || printf '%s' "$0")

# Handle NO_COLOR. See https://no-color.org
if [[ -n ${NO_COLOR:-} ]]; then
	INTERACTIVE=
elif [[ -z ${INTERACTIVE+x} ]]; then
	if [[ -t 1 ]]; then
		INTERACTIVE=1
	else
		INTERACTIVE=
	fi
fi

[[ -z ${DEBUG+x} ]] && DEBUG=

# Escape sequence variables
readonly _E_BLACK=$'\e[30m'
readonly _E_RED=$'\e[31m'
readonly _E_GREEN=$'\e[32m'
readonly _E_YELLOW=$'\e[33m'
readonly _E_BLUE=$'\e[34m'
readonly _E_MAGENTA=$'\e[35m'
readonly _E_CYAN=$'\e[36m'
readonly _E_WHITE=$'\e[37m'
readonly _E_GRAY=$'\e[38;5;242m'
readonly _E_BOLD=$'\e[1m'
readonly _E_CLR=$'\e[0m'

# https://en.wikipedia.org/wiki/ANSI_escape_code
function black() {
	[[ -z ${INTERACTIVE:-} ]] || printf '%s' "$_E_BLACK"
}

function red() {
	[[ -z ${INTERACTIVE:-} ]] || printf '%s' "$_E_RED"
}

function green() {
	[[ -z ${INTERACTIVE:-} ]] || printf '%s' "$_E_GREEN"
}

function yellow() {
	[[ -z ${INTERACTIVE:-} ]] || printf '%s' "$_E_YELLOW"
}

function blue() {
	[[ -z ${INTERACTIVE:-} ]] || printf '%s' "$_E_BLUE"
}

function magenta() {
	[[ -z ${INTERACTIVE:-} ]] || printf '%s' "$_E_MAGENTA"
}

function cyan() {
	[[ -z ${INTERACTIVE:-} ]] || printf '%s' "$_E_CYAN"
}

function white() {
	[[ -z ${INTERACTIVE:-} ]] || printf '%s' "$_E_WHITE"
}

function gray() {
	[[ -z ${INTERACTIVE:-} ]] || printf '%s' "$_E_GRAY"
}

function bold() {
	[[ -z ${INTERACTIVE:-} ]] || printf '%s' "$_E_BOLD"
}

function clr() {
	[[ -z ${INTERACTIVE:-} ]] || printf '%s' "$_E_CLR"
}

# Function for handling help flags.
# If needed redefine and modify for your needs.
function usage_help() {
  printf '%sUsage:%s
  %s [OPTIONS...]

%sOptions:%s
  -v, --version              Show script version
  -h, --help                 Show this help message
  -d, --debug                Run program in debug mode

' "$(bold)" "$(clr)" "$(basename "$BASH_HELPERS_SCRIPT_PATH")" "$(bold)" "$(clr)"

	return 0
}

# Function for handling version flags.
# If needed redefine and modify for your needs.
# VERSION variable should be defined in your main script:
#   VERSION=1.0.0
function print_version() {
	printf '%s %s\n' "$(basename "$BASH_HELPERS_SCRIPT_PATH")" "$(bold)${VERSION:-undefined}$(clr)"
	printf 'bash-helpers.sh %s\n\n' "$(bold)${BASH_HELPERS_VERSION}$(clr)"
}

# Function for datetime output
#
# DATETIME_FORMAT can be set in your script:
#   DATETIME_FORMAT='+%Y-%m-%dT%H:%M:%S%z'   # RFC3339
# See `man date` for format specifiers.
function format_date() {
	printf '%s%s%s' \
		"${INTERACTIVE:+$_E_GRAY}" \
		"$(date "${DATETIME_FORMAT:-+%Y-%m-%d %H:%M:%S}")" \
		"${INTERACTIVE:+$_E_CLR}"
}

# Function for error messages
function error() {
	printf '[%s]:[%sERROR%s] %s\n' \
		"$(format_date)" \
		"${INTERACTIVE:+$_E_RED}" \
		"${INTERACTIVE:+$_E_CLR}" \
		"${1:-}" >&2
}

# Function for informational messages
function inform() {
	printf '[%s]:[%sINFO%s] %s\n' \
		"$(format_date)" \
		"${INTERACTIVE:+$_E_GREEN}" \
		"${INTERACTIVE:+$_E_CLR}" \
		"${1:-}"
}

# Function for warning messages
function warning() {
	printf '[%s]:[%sWARN%s] %s\n' \
		"$(format_date)" \
		"${INTERACTIVE:+$_E_YELLOW}" \
		"${INTERACTIVE:+$_E_CLR}" \
		"${1:-}" >&2
}

# Function for debug messages
function debug() {
	[[ -z ${DEBUG:-} ]] || printf '[%s]:[%sDEBUG%s] %s\n' \
		"$(format_date)" \
		"${INTERACTIVE:+$_E_GRAY}" \
		"${INTERACTIVE:+$_E_CLR}" \
		"${1:-}"
}

# Function for operation status
#
# Usage: status MESSAGE STATUS
# Examples:
#     status 'Upload scripts' $?
#     status 'Run operation' OK
#     status 'Run operation' FAIL
function status() {
	if [[ -z ${1:-} ]]; then
		error 'status(): message parameter required!'
		return 1
	fi

	if [[ -z ${2:-} ]]; then
		error 'status(): status parameter required!'
		return 1
	fi

	local result=0
	local -r ok_label="${INTERACTIVE:+$_E_GREEN} OK ${INTERACTIVE:+$_E_CLR}"
	local -r err_label="${INTERACTIVE:+$_E_RED}FAIL${INTERACTIVE:+$_E_CLR}"

	if [[ ${2:-} = OK || ${2:-} = 0 ]]; then
		printf '[%s]:[%s] %s\n' "$(format_date)" "$ok_label" "${1:-}"
	elif [[ ${2:-} = FAIL ]] || [[ ${2:-} =~ ^[0-9]+$ && ${2:-} -gt 0 ]]; then
		printf '[%s]:[%s] %s\n' "$(format_date)" "$err_label" "${1:-}"
		result=1
	else
		warning "Unknown status: '${2:-}'"
		result=2
	fi

	return $result
}

# Function for status on some command in debug mode only
# Examples:
#     status_dbg 'Debug operation status' $?
#     status_dbg 'Debug operation status' OK
#     status_dbg 'Debug operation status' FAIL
function status_dbg() {
	[[ -z ${DEBUG:-} ]] && return 0

	if [[ -z ${1:-} ]]; then
		error 'status_dbg(): message parameter required!'
		return 1
	fi

	if [[ -z ${2:-} ]]; then
		error 'status_dbg(): status parameter required!'
		return 1
	fi

	local result=0
	local -r ok_label="${INTERACTIVE:+$_E_GREEN} ++ ${INTERACTIVE:+$_E_CLR}"
	local -r err_label="${INTERACTIVE:+$_E_RED} -- ${INTERACTIVE:+$_E_CLR}"

	if [[ ${2:-} = OK || ${2:-} = 0 ]]; then
		printf '[%s]:[%s] %s\n' "$(format_date)" "$ok_label" "${1:-}"
	elif [[ ${2:-} = FAIL ]] || [[ ${2:-} =~ ^[0-9]+$ && ${2:-} -gt 0 ]]; then
		printf '[%s]:[%s] %s\n' "$(format_date)" "$err_label" "${1:-}"
		result=1
	else
		warning "Unknown status: '${2:-}'"
		result=2
	fi

	return $result
}

# Function for checking script dependencies
# Examples:
#     check_dependencies go || exit 1
#     check_dependencies python date curl || exit 1
function check_dependencies() {
	local result=0
	local code cmd

	for cmd in "${@}"; do
		command -v "$cmd" >/dev/null 2>&1
		code=$?

		status_dbg "DEPENDENCY: $cmd" "$code"

		if [[ $code -ne 0 ]]; then
			warning "${INTERACTIVE:+$_E_BOLD}${INTERACTIVE:+$_E_BLUE}${cmd}${INTERACTIVE:+$_E_CLR} command not available"
			result=1
		fi
	done

	debug "check_dependencies() result: $result"

	return $result
}

# Convert string value to float
function float() {
	if [[ ${1:-} = '""' || -z ${1:-} ]]; then
		printf '0\n'
		return 0
	fi

	printf '%s\n' "${1:-}" | sed 's/,/\./' | bc -l || return 1

	return 0
}

# Include function
#
# Example:
#     include reload # load /usr/local/lib/bash/includes/reload.sh
#     include google/client # load /usr/local/lib/bash/includes/google/client.sh
#
#     BASH_HELPERS_INCLUDES=$HOME/lib
#     include http/parser # load $HOME/lib/http/parser.sh
#
# For security reasons paths with '..' not allowed. No dots-anywhere, otherwise returns 1.
function include() {
	if [[ -z ${1:-} ]]; then
		error "include(): empty path"
		return 1
	fi

	local -r includes_dir="${BASH_HELPERS_INCLUDES:-/usr/local/lib/bash/includes}"
	local -r file="$includes_dir/$1.sh"

	printf '%s' "$file" | grep -q '\.\.' && {
		debug "include(): traversal path in: $file"
		return 1
	}

	if [[ -r $file ]]; then
		debug "include(): found file: $file"
		# shellcheck source=stub.sh
		. "$file"
		local rc=$?

		status_dbg "File included" "$rc"

		[[ $rc -ne 0 ]] && return 1
	else
		return 1
	fi

	return 0
}

# Redefine it in your main script and modify for your needs.
# Usage:
#	parse_options "$@"
#	PARSE_RESULT=$?
#	[[ $PARSE_RESULT = 2 ]] && usage_help && exit 2
#
# Long arguments (--target=value) example:
#	local param found long value
#	while getopts :vhdt:-: param; do
#		if [[ $param = '?' ]]; then
#			found="-$OPTARG"
#		elif [[ $param = '-' ]]; then
#			found="--${OPTARG%%=*}"
#		else
#			found="-$param"
#		fi
#
#		debug "Found option '$found'"
#
#		case $param in
#			v ) print_version; exit 0;;
#			h ) usage_help; exit 0;;
#			d ) DEBUG=1;;
#			t ) TARGET=${OPTARG};;
#			- ) long="${OPTARG%%=*}"
#				value="${OPTARG#*=}"
#				case $long in
#					version ) print_version; exit 0;;
#					help    ) usage_help; exit 0;;
#					debug   ) DEBUG=1;;
#					target  ) TARGET=${value};;
#					*       ) warning "Illegal option --$long"; result=2;;
#				esac;;
#			* ) warning "Illegal option -$OPTARG"; result=2;;
#		esac
#	done
#
# After `parse_options "$@"` returns, `OPTIND` points to the first
# non-option argument. To process your own positional arguments:
#
#    parse_options "$@"
#    shift $((OPTIND-1))
#
# Now "$@" contains only positional arguments of your script.
# It's safe to use $1 and $2 and so on as arguments.
function parse_options() {
	local result=0
	local param found long value
	OPTIND=1

	while getopts :vhd-: param; do
		if [[ $param = '?' ]]; then
			found="-$OPTARG"
		elif [[ $param = '-' ]]; then
			found="--${OPTARG%%=*}"
		else
			found="-$param"
		fi

		debug "Found option '$found'"

		case $param in
			v ) print_version; exit 0;;
			h ) usage_help; exit 0;;
			d ) DEBUG=1;;
			- ) long="${OPTARG%%=*}"
				value="${OPTARG#*=}"
				case $long in
					version ) print_version; exit 0;;
					help    ) usage_help; exit 0;;
					debug   ) DEBUG=1;;
					*       ) warning "Illegal option --$long"; result=2;;
				esac;;
			* ) warning "Illegal option -$OPTARG"; result=2;;
		esac
	done

	debug "Variable DEBUG: '${DEBUG:-}'"
	debug "parse_options() result: $result"

	return $result
}

# Function for getting bool values from git config
# Echoes 1 on ok_msg
# Usage:
#	git_config_bool "$PARAM" "$PROJECT_PATH"
function git_config_bool() {
	local -a git_args=()
	local value

	[[ -n ${2:-} ]] && git_args=(-C "${2:-}")

	value=$(git ${git_args[@]+"${git_args[@]}"} config --bool "${1:-}") || return $?

	[[ $value = true ]] && printf '1\n'

	return 0
}
