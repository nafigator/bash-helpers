[![GitHub license][License img]][License src] [![GitHub release][Release img]][Release src] [![Conventional Commits][Conventional commits badge]][Conventional commits src] [![Semantic Versioning][Versioning img]][Versioning src]
# bash-helpers
**Collections of useful functions for usage in Bash scripts**

## Installation

	[ -d /usr/local/lib/bash/includes ] || sudo mkdir -p /usr/local/lib/bash/includes
	sudo curl -o /usr/local/lib/bash/includes/bash-helpers.sh https://raw.githubusercontent.com/nafigator/bash-helpers/master/bash-helpers.sh

## Usage
1. Put bash libs into `/usr/local/lib/bash/includes` dir.
2. Source `bash-helpers.sh` in executable script:
	```bash
	. /usr/local/lib/bash/includes/bash-helpers.sh
	```
## Features:
* **Defines human-readable variables for colors and formatting:**
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
* **Functions for nicely formatted messages `error`, `inform`, `warning`.**

	Examples:
	```bash
	inform 'Script start'
	warning 'Make backup!'
	error 'File not found'
	```
	![Messages formatting][Messages formatting img]
* **Libs including.**

	Example:
	```bash
	include google/client || exit 1
	include mysql/query-builder || exit 1
	include logger; status 'Logger including' $? || exit 1
	```
* **Status messages.**

	Example:
	```bash
	# Define right statuses position 
	STATUS_ALIGN=30
	test -d /usr/local/nonexistent
	status 'Check /usr/local/nonexistent dir' $?
	test -d /usr/local/bin
	status 'Check /usr/local/bin dir' $?
	```
	![Status messages][Status messages img]
* **Dynamically update statuses alignment up on longest string in array.**

	Example:
	```bash
	# Define right statuses position
	STATUS_ALIGN=6
	declare -a messages
	messages=(short long\ string string name)
	update_status_align messages
	for i in "${messages[@]}"; do status "$i" OK; done
	```
	![Status messages alignment update][Status messages alignment update img]
* **Checking dependencies.**

	Example:
	```bash
	check_dependencies yarn || exit 1
	```
	![Check dependencies][Check dependencies img]
* **Debug messages and statuses.**

	Example:
	```bash
	debug 'This message is hidden'
    status_dbg 'This status is hidden' $?
    STATUS_ALIGN=45
    DEBUG=1
    debug 'Visible because of DEBUG variable'
    test -d /nonexists
    status_dbg 'Visible because of DEBUG variable' $?
	```
	![Debug messages][Debug messages img]

## Versioning
This software follows *"Semantic Versioning"* specifications. All function signatures declared as public API.

Read more on [SemVer.org](http://semver.org).

[Conventional commits src]: https://conventionalcommits.org
[Conventional commits badge]: https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg
[Release img]: https://img.shields.io/badge/release-0.8.1-orange.svg
[Release src]: https://github.com/nafigator/bash-helpers
[License img]: https://img.shields.io/badge/license-MIT-brightgreen.svg
[License src]: https://tldrlegal.com/license/mit-license
[Versioning img]: https://img.shields.io/badge/Semantic%20Versioning-2.0.0-brightgreen.svg
[Versioning src]: https://semver.org
[Colors definition img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/images/colors-definition.jpg
[Messages formatting img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/images/messages-formatting.jpg
[Status messages img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/images/status-messages.jpg
[Check dependencies img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/images/check-dependencies.jpg
[Status messages alignment update img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/images/dynamically-update-status-alignment.jpg
[Debug messages img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/images/debug-messages.jpg
