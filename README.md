[![GitHub license][License img]][License src] [![GitHub release][Release img]][Release src] [![Conventional Commits][Conventional commits badge]][Conventional commits src]
# bash-helpers
Collections of useful functions for usage in Bash scripts

## Installation

	[ -d /usr/local/share/bash/includes ] || sudo mkdir -p /usr/local/share/bash/includes
	sudo curl -o /usr/local/share/bash/includes/bash-helpers.sh https://raw.githubusercontent.com/nafigator/bash-helpers/master/bash-helpers.sh

## Usage
1. Put bash libs into `/usr/local/share/bash/includes` dir.
2. Source `bash-helpers.sh` in executable script:
	```bash
	. /usr/local/share/bash/includes/bash-helpers.sh
	```
## Features:
* Defines human-readable variables for colors and formatting:
	- RED
	- GREEN
	- YELLOW
	- GRAY
	- BOLD
	- CLR
	
	Examples:
	```bash
	printf "${RED}ERROR:${CLR} Save failure"
	```
	![Colors definition][Colors definition img]
* Functions for nicely formatted messages `error`, `inform`, `warning`.

	Examples:
	```bash
	inform 'Script start'
	warning 'Make backup!'
	error 'File not found'
	```
	![Messages formatting][Messages formatting img]
* Libs including.

	Example:
	```bash
	include google/client || exit 1
	include mysql/query-builder || exit 1
	include logger || status 'Logger including' $? || exit 1
	```
* Status messages.

	Example:
	```bash
	# Define right statuses position 
	status_length=30
	test -d /usr/local/nonexistent
	status 'Check /usr/local/nonexistent dir' $?
	test -d /usr/local/bin
	status 'Check /usr/local/bin dir' $?
	```
	![Status messages][Status messages img]
* Dynamically update statuses position up on longest string in array

	Example:
	```bash
	# Define right statuses position
	status_length=6
	declare -a messages
	messages=(short long\ string string name)
	update_status_length messages
	for i in "${messages[@]}"; do status "$i" OK; done
	```
	![Status messages align update][Status messages align update img]
* Checking dependencies.

	Example:
	```bash
	check_dependencies yarn || exit 1
	```
	![Check dependencies][Check dependencies img]

[Conventional commits src]: https://conventionalcommits.org
[Conventional commits badge]: https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg
[Release img]: https://img.shields.io/badge/release-0.6.0-orange.svg
[Release src]: https://github.com/nafigator/bash-helpers
[License img]: https://img.shields.io/badge/license-MIT-brightgreen.svg
[License src]: https://tldrlegal.com/license/mit-license
[Colors definition img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/images/colors-definition.jpg
[Messages formatting img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/images/messages-formatting.jpg
[Status messages img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/images/status-messages.jpg
[Check dependencies img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/images/check-dependencies.jpg
[Status messages align update img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/images/dynamically-update-status-align.jpg
