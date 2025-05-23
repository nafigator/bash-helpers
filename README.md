<a id="readme-top"></a>
# bash-helpers
[![GitHub license][License img]][License src] [![GitHub release][Release img]][Release src] [![Github main status][Github main status badge]][Github main status src] [![Conventional Commits][Conventional commits badge]][Conventional commits src] [![Semantic Versioning][Versioning img]][Versioning src]

**Collection of useful functions for usage in Bash scripts**

## Usage

<details>
  <summary>Without installation</summary>

```bash
#!/usr/bin/env bash

source <(curl -s https://raw.githubusercontent.com/nafigator/bash-helpers/1.1.4/src/bash-helpers.sh)

inform 'Bash helpers ready!'
```
</details>

<details>
  <summary>Preinstalled</summary>

```bash
#!/usr/bin/env bash

. /usr/local/lib/bash/includes/bash-helpers.sh

inform 'Bash helpers ready!'
```
</details>

## Installation

1. Put bash libs into `/usr/local/lib/bash/includes` dir.
2. Source `bash-helpers.sh` in executable script:
   ```bash
   . /usr/local/lib/bash/includes/bash-helpers.sh
   ```

<details>
  <summary>Example</summary>

```bash
[ -d /usr/local/lib/bash/includes ] || sudo mkdir -p /usr/local/lib/bash/includes
sudo curl -o /usr/local/lib/bash/includes/bash-helpers.sh https://raw.githubusercontent.com/nafigator/bash-helpers/master/src/bash-helpers.sh
sudo chmod +x /usr/local/lib/bash/includes/bash-helpers.sh
```
</details>

<details>
  <summary>Via functions</summary>

```bash
#!/usr/bin/env bash

download_bash_helpers() {
	printf "Installing bash-helpers\n"
	[[ ! -d /usr/local/lib/bash/includes ]] || sudo mkdir -p /usr/local/lib/bash/includes

	sudo curl -so /usr/local/lib/bash/includes/bash-helpers.sh https://raw.githubusercontent.com/nafigator/bash-helpers/master/src/bash-helpers.sh
	sudo chmod +x /usr/local/lib/bash/includes/bash-helpers.sh

	return 0
}

init_bash_helpers() {
	[[ -e /usr/local/lib/bash/includes/bash-helpers.sh ]] || download_bash_helpers

	if [[ ! -x /usr/local/lib/bash/includes/bash-helpers.sh ]]; then
		printf "Insufficient permissions for bash-helpers execute\n"; return 1
	fi

	. /usr/local/lib/bash/includes/bash-helpers.sh

	return 0
}

init_bash_helpers || exit 1
```
</details>

<details>
  <summary>Via composer</summary>

```bash
composer require nafigator/bash-helpers
```
</details>

## Features:
* **Defines human-readable functions for colors and formatting:**
	- black()
	- red()
	- green()
	- yellow()
	- blue()
	- magenta()
	- cyan()
	- white()
	- gray()
	- bold()
	- clr()

	Examples:
	```bash
	printf "$(bold)$(red)ATTENTION$(clr) Save $(cyan)failure$(clr)"
	```
	![Colors definition][Colors definition img]
	> **NOTE**: For logging purpose colors may be disabled by global `INTERACTIVE` variable:
	>
	>INTERACTIVE=
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
	test -d /usr/local/nonexistent
	status 'Check /usr/local/nonexistent dir' $?
	test -d /usr/local/bin
	status 'Check /usr/local/bin dir' $?
	```
	![Status messages][Status messages img]
* **Checking dependencies.**

	Example:
	```bash
	check_dependencies yarn rust || exit 1
	```
	![Check dependencies][Check dependencies img]
* **Debug messages and statuses.**

	Example:
	```bash
	debug 'This message is hidden'
	status_dbg 'This status is hidden' $?
	DEBUG=1
	debug 'Visible because of DEBUG variable'
	test -d /nonexists
	status_dbg 'Visible because of DEBUG variable' $?
	test -d /var/log
	status_dbg 'Visible because of DEBUG variable' $?
	```
	![Debug messages][Debug messages img]

## Message statuses

	[ OK ] - success status
	[FAIL] - fail status
	[ ?? ] - debug message
	[ ++ ] - success debug status
	[ -- ] - fail debug status

## Versioning
This software follows *"Semantic Versioning"* specifications. All function signatures declared as public API.

Read more on [SemVer.org](http://semver.org).

[Conventional commits src]: https://conventionalcommits.org
[Conventional commits badge]: https://img.shields.io/badge/Conventional%20Commits-1.0.0-teal.svg
[Github main status src]: https://github.com/nafigator/bash-helpers/actions?query=branch%3Amain
[Github main status badge]: https://github.com/nafigator/bash-helpers/actions/workflows/daily.yml/badge.svg?branch=main
[Release img]: https://img.shields.io/github/v/tag/nafigator/bash-helpers?logo=github&labelColor=333&color=teal
[Release src]: https://github.com/nafigator/bash-helpers
[License img]: https://img.shields.io/github/license/nafigator/bash-helpers?logoColor=333&color=teal
[License src]: https://tldrlegal.com/license/mit-license
[Versioning img]: https://img.shields.io/badge/Semantic%20Versioning-2.0.0-teal.svg
[Versioning src]: https://semver.org
[Colors definition img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/.images/colors-definition.jpg
[Messages formatting img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/.images/messages-formatting.jpg
[Status messages img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/.images/status-messages.jpg
[Check dependencies img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/.images/check-dependencies.jpg
[Debug messages img]: https://raw.githubusercontent.com/nafigator/bash-helpers/master/.images/debug-messages.jpg
