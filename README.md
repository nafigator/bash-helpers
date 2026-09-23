<a id="readme-top"></a>
# bash-helpers
[![GitHub license][License img]][License src] [![GitHub release][Release img]][Release src] [![Github main status][Github main status badge]][Github main status src] [![Conventional Commits][Conventional commits badge]][Conventional commits src] [![Semantic Versioning][Versioning img]][Versioning src]

**Collection of useful functions for usage in Bash scripts**

See [CONTRIBUTING.md](CONTRIBUTING.md) for development setup and PR guidelines.

## Usage

<details>
  <summary>Without installation</summary>

```bash
#!/usr/bin/env bash

source <(curl -s https://raw.githubusercontent.com/nafigator/bash-helpers/1.1.5/src/bash-helpers.sh)

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

## Configuration

The library is configured via environment variables and by overriding a few functions.

### Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `INTERACTIVE` | `1` if stdin and stdout are TTY, otherwise empty | Enables ANSI color output. Set to empty (`INTERACTIVE=`) to disable colors (e.g. for logs). |
| `DEBUG` | unset | Enables `debug()` and `status_dbg()` output. Set to any non-empty value (e.g. `DEBUG=1`). |
| `VERSION` | unset | Your script version. Used by `print_version()`. Define it in your main script. |

Examples:

```bash
# Redefine to disable colors
INTERACTIVE=

# Redefine to enable debug output
DEBUG=1

# Redefine version in your script for print_version
VERSION=1.2.3
```

### Overriding functions

Two functions are meant to be redefined in your script to match your CLI:

- `usage_help()` — prints help text. Redefine to show your own options.
- `print_version()` — prints version. Redefine if you need custom output (it uses `$VERSION` and `$BASH_HELPERS_VERSION` by default).
- `parse_options()` — parses options. Redefine if you have extended set of options.

Example:

```bash
usage_help() {
  echo "Usage: my-script [OPTIONS]"
  echo "  -v, --version  Show version"
  echo "  -h, --help     Show this help"
}

print_version() {
  echo "my-script $VERSION"
}
```

### Include directory

`include()` loads files from a fixed path:

```bash
/usr/local/lib/bash/includes
```

If you need a different location, redefine `include()` in your script.

### Notes

- `INTERACTIVE` and `DEBUG` are read at call time, so you can change them during script execution.
- `VERSION` must be set before calling `print_version()`.
- Color functions (`red`, `bold`, etc.) respect `INTERACTIVE` automatically.

## Dependencies

### Required

| Dependency | Version | Purpose                                                                                                                                |
|------------|---------|----------------------------------------------------------------------------------------------------------------------------------------|
| `bash`     | ≥ 3.2   | local -r, printf, [[ ]], getopts and other 3.x features used across helpers                                                            |
| `POSIX utilities`| —       | `printf`, `date`, `readlink`, `basename` — used by `format_date`, `inform`, `warning`, `error`, `debug`, `usage_help`, `print_version` |

### Optional

Installed only if you use the corresponding function.

| Dependency | Used by | Purpose |
|------------|---------|---------|
| `bc`       | `float()` | Arbitrary precision arithmetic for decimal conversion |
| `sed`      | `float()` | Normalizes decimal separator (`,` → `.`) |
| `git`      | `git_config_bool()` | Reads boolean values from git config |
| `curl`     | Installation snippets in this README | Downloads `bash-helpers.sh` |

### Function → dependency map

| Function | Depends on                     |
|----------|--------------------------------|
| `black` … `clr` | `printf` (builtin)             |
| `format_date` | `date`, `printf` (builtin)     |
| `error`, `inform`, `warning`, `debug` | `date`, `printf` (builtin)     |
| `status`, `status_dbg` | `date`, `printf` (builtin)     |
| `check_dependencies` | `date`, `command -v` (builtin) |
| `float` | `sed`, `bc`                    |
| `include` | — (pure bash)                  |
| `usage_help`, `print_version` | `basename`, `readlink`         |
| `git_config_bool` | `git`                          |
| `parse_options` | `getopts` (builtin)            |

### Checking at runtime

Use the bundled helper to verify dependencies before running your script:

```bash
check_dependencies bash date git || exit 1
```

### Notes

- All helpers assume a POSIX-like environment (Linux, macOS, BSD). Windows is supported only via WSL or MSYS2/Cygwin.
- `bc` is not installed by default on minimal images (e.g. `alpine`, `debian:slim`). Install it with `apk add bc` / `apt-get install -y bc` if you rely on `float()`.
- `INTERACTIVE` and `DEBUG` are **not** external dependencies — they are environment variables consumed by the library. See [Configuration](#configuration)

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
