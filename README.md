<a id="readme-top"></a>
# bash-helpers
[![GitHub license][License img]][License src] [![GitHub release][Release img]][Release src] [![Github main status][Github main status badge]][Github main status src] [![Conventional Commits][Conventional commits badge]][Conventional commits src] [![Semantic Versioning][Versioning img]][Versioning src]

**Collection of useful functions for usage in Bash scripts**

See [CONTRIBUTING.md](CONTRIBUTING.md) for development setup and PR guidelines.

## Features:
* **Color and formatting functions:** `black` `red` `green` `yellow` `blue` `magenta` `cyan` `white` `gray` `bold` `clr`

  Examples:
  ```bash
  printf '%s\n' "$(bold)$(red)ATTENTION$(clr) Save $(cyan)failure$(clr)"
  ```
  ![Colors definition][Colors definition img]
> [!TIP]
> For logging purpose colors may be disabled by global `NO_COLOR` or `INTERACTIVE` variable:
> `NO_COLOR=1`
> `INTERACTIVE=`
* **Functions for nicely formatted messages `error`, `inform`, `warning`, `debug`**

  Examples:
  ```bash
  inform 'Script start'
  warning 'Make backup!'
  error 'File not found'
  debug 'Fall back to 0'
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

## Installation

1. Put bash-helpers.sh into `/usr/local/lib/bash/includes` dir.
2. Source `bash-helpers.sh` in executable script:
   ```bash
   . /usr/local/lib/bash/includes/bash-helpers.sh
   ```

<details>
  <summary>Example</summary>

```bash
sudo mkdir -p /usr/local/lib/bash/includes
sudo curl -o /usr/local/lib/bash/includes/bash-helpers.sh https://github.com/nafigator/bash-helpers/releases/download/1.1.7/bash-helpers.sh
```
</details>

<details>
  <summary>Via functions (simple)</summary>

```bash
#!/usr/bin/env bash

readonly HELPERS_URL="https://github.com/nafigator/bash-helpers/releases/download/1.1.7/bash-helpers.sh"
readonly HELPERS_DIR="$HOME/.local/lib/bash/includes"
readonly HELPERS_LIB="$HELPERS_DIR/bash-helpers.sh"

download_bash_helpers() {
	echo 'Installing bash-helpers'

	mkdir -p "$HELPERS_DIR" || return 1
	curl -fsSL -o "$HELPERS_LIB" "$HELPERS_URL" || return 1

	return 0
}

init_bash_helpers() {
	[[ -r "$HELPERS_LIB" ]] || download_bash_helpers || return 1

	. "$HELPERS_LIB" || return 1

	return 0
}

init_bash_helpers || exit 1
```
</details>

<details>
  <summary>Via functions (safe)</summary>

```bash
#!/usr/bin/env bash

readonly HELPERS_URL="https://github.com/nafigator/bash-helpers/releases/download/1.1.7/bash-helpers.sh"
readonly HELPERS_SUM_URL="https://github.com/nafigator/bash-helpers/releases/download/1.1.7/sha256sum.txt"
readonly HELPERS_DIR="$HOME/.local/lib/bash/includes"
readonly HELPERS_LIB="$HELPERS_DIR/bash-helpers.sh"

download_bash_helpers() {
	echo 'Installing bash-helpers'

	local tmp tmpdir sum
	tmpdir=$(mktemp -d) || {
		echo 'mktemp fail' >&2
		return 1
	}
	tmp="$tmpdir/bash-helpers.sh"

	sum=$(curl -fsSL --retry 3 -m 30 "$HELPERS_SUM_URL") || {
		echo 'Get bash-helpers sum failed' >&2
		rm -rf "$tmpdir"; return 1
	}

	[[ -n $sum ]] || {
		echo 'Empty bash-helpers checksum' >&2
		rm -rf "$tmpdir"; return 1
	}

	curl -fsSL --retry 3 -m 30 -o "$tmp" "$HELPERS_URL" || {
		echo 'Download bash-helpers failed' >&2
		rm -rf "$tmpdir"; return 1
	}

	# For Linux sha256sum
	( cd "$tmpdir" || exit 1; printf '%s\n' "$sum" | sha256sum -c --status ) || {
		echo 'Check bash-helpers sum failed' >&2
		rm -rf "$tmpdir"; return 1
	}

	mkdir -p "$HELPERS_DIR" || {
		echo 'Create destination dir for bash-helpers failed' >&2
		rm -rf "$tmpdir"; return 1
	}

	install -m 0644 "$tmp" "$HELPERS_LIB" || {
		echo 'Install bash-helpers failed' >&2
		rm -rf "$tmpdir"; return 1
	}

	rm -rf "$tmpdir"

	return 0
}

init_bash_helpers() {
	[[ -r "$HELPERS_LIB" ]] || download_bash_helpers || return 1

	. "$HELPERS_LIB" || {
		echo 'Source bash-helpers failed' >&2
		return 1
	}

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

## Usage

<details>
  <summary>Without installation</summary>

```bash
#!/usr/bin/env bash

source <(curl -fsSL https://raw.githubusercontent.com/nafigator/bash-helpers/1.1.7/src/bash-helpers.sh)

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

> [!IMPORTANT]
> Source before any `cd`. The script path is resolved at source time via `realpath`.
>
> Re-sourcing is safe; overrides between sources are preserved.
>
> Works under `set -eu`. Call `check_dependencies ... || exit 1` so it reports missing tools before exiting.

## Configuration

The library is configured via environment variables and by overriding a few functions.

### Environment variables

| Variable          | Default                                 | Description                                                                                            |
|-------------------|-----------------------------------------|--------------------------------------------------------------------------------------------------------|
| `NO_COLOR`        | unset                                   | Disables ANSI color output. Has priority over `INTERACTIVE`. See [no-color](https://no-color.org).     |
| `INTERACTIVE`     | `1` if stdout is a TTY, otherwise empty | Enables ANSI color output. Set to empty (`INTERACTIVE=`) to disable colors (e.g. for logs).            |
| `DEBUG`           | unset                                   | Enables `debug()` and `status_dbg()` output. Set to any non-empty value (e.g. `DEBUG=1`).              |
| `VERSION`         | unset                                   | Your script version. Used by `print_version()`. Define it in your main script.                         |
| `DATETIME_FORMAT` | '+%Y-%m-%d %H:%M:%S'                    | Datetime format. Applied inside `format_date()`. Can be redefined in your main script. See `man date`. |

<details>
  <summary>Examples:</summary>

```bash
# Redefine to disable colors
INTERACTIVE=

# Redefine to enable debug output
DEBUG=1

# Redefine version in your script for print_version
VERSION=1.2.3

# Redefine datetime format for RFC3339 structured logs
DATETIME_FORMAT='+%Y-%m-%dT%H:%M:%S%z'
```
</details>

> [!NOTE]
> - `INTERACTIVE`, `DEBUG`, and `DATETIME_FORMAT` are read at call time. You can change them during execution.
> - `VERSION` falls back to `undefined` if not set before `print_version()`.
> - `DATETIME_FORMAT` falls back to `'+%Y-%m-%d %H:%M:%S'` if unset or empty.
> - `DATETIME_FORMAT` is a generic name that may conflict with other tools; redefine `format_date()` if it does.

### Overriding functions

The following functions can be redefined:

- `usage_help()` - prints help text. Redefine to show your own options.
- `print_version()` - prints version. Redefine if you need custom output (it uses `$VERSION` and `$BASH_HELPERS_VERSION` by default).
- `parse_options()` - parses options. Redefine if you have extended set of options.

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

By default `include()` loads files from a fixed path:

```bash
/usr/local/lib/bash/includes
```

If you need a different location, use `BASH_HELPERS_INCLUDES` or redefine `include()` in your script.

## Dependencies

### Required

| Dependency        | Version | Purpose                                                                                                                                |
|-------------------|---------|----------------------------------------------------------------------------------------------------------------------------------------|
| `bash`            | >= 3.2  | local -r, printf, [[ ]], getopts and other 3.x features used across helpers                                                            |
| `POSIX utilities` | -       | `printf`, `date`, `realpath`, `basename` - used by `format_date`, `inform`, `warning`, `error`, `debug`, `usage_help`, `print_version` |

> [!NOTE]
> Works on Linux, macOS, BSD (WSL/MSYS2 on Windows).

### Optional

Required only when you call the corresponding function.

| Dependency | Used by                              | Purpose                                               |
|------------|--------------------------------------|-------------------------------------------------------|
| `bc`       | `float()`                            | Arbitrary precision arithmetic for decimal conversion |
| `sed`      | `float()`                            | Normalizes decimal separator (`,` -> `.`)             |
| `git`      | `git_config_bool()`                  | Reads boolean values from git config                  |
| `curl`     | Installation snippets in this README | Downloads `bash-helpers.sh`                           |

### Function -> dependency map

| Function                              | Depends on                     |
|---------------------------------------|--------------------------------|
| `black` ... `clr`                     | `printf` (builtin)             |
| `format_date`                         | `date`, `printf` (builtin)     |
| `error`, `inform`, `warning`, `debug` | `date`, `printf` (builtin)     |
| `status`, `status_dbg`                | `date`, `printf` (builtin)     |
| `check_dependencies`                  | `date`, `command -v` (builtin) |
| `float`                               | `sed`, `bc`                    |
| `include`                             | - (pure bash)                  |
| `usage_help`, `print_version`         | `basename`, `realpath`         |
| `git_config_bool`                     | `git`                          |
| `parse_options`                       | `getopts` (builtin)            |

### Checking at runtime

Use the bundled helper to verify dependencies before running your script:

```bash
check_dependencies curl jq || exit 1
```

## Message statuses

	[ OK ] - success status
	[FAIL] - fail status
	[ ?? ] - debug message
	[ ++ ] - success debug status
	[ -- ] - fail debug status

## Versioning
[Semantic Versioning](https://semver.org). Function signatures are part of the public API.

[Conventional commits src]: https://conventionalcommits.org
[Conventional commits badge]: https://img.shields.io/badge/Conventional%20Commits-1.0.0-teal.svg
[Github main status src]: https://github.com/nafigator/bash-helpers/actions?query=branch%3Amain
[Github main status badge]: https://github.com/nafigator/bash-helpers/actions/workflows/release.yml/badge.svg?branch=main
[Release img]: https://img.shields.io/github/v/tag/nafigator/bash-helpers?logo=github&labelColor=333&color=teal
[Release src]: https://github.com/nafigator/bash-helpers
[License img]: https://img.shields.io/github/license/nafigator/bash-helpers?logoColor=333&color=teal
[License src]: https://tldrlegal.com/license/mit-license
[Versioning img]: https://img.shields.io/badge/Semantic%20Versioning-2.0.0-teal.svg
[Versioning src]: https://semver.org
[Colors definition img]: .images/colors-definition.jpg
[Messages formatting img]: .images/messages-formatting.jpg
[Status messages img]: .images/status-messages.jpg
[Check dependencies img]: .images/check-dependencies.jpg
[Debug messages img]: .images/debug-messages.jpg
