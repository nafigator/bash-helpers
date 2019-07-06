[![GitHub license][License img]][License src] [![GitHub release][Release img]][Release src] [![Conventional Commits][Conventional commits badge]][Conventional commits src]
# bash-helpers
Collections of useful functions for usage in Bash scripts

### Installation

	[ -d /usr/local/share/bash/includes ] || sudo mkdir -p /usr/local/share/bash/includes
	sudo curl -o /usr/local/share/bash/includes/bash-helpers.sh https://raw.githubusercontent.com/nafigator/bash-helpers/master/bash-helpers.sh

### Usage
1. Put bash libs into `/usr/local/share/bash/includes` dir.
2. Source in executable script `bash-helpers.sh`:
	```bash
	. /usr/local/share/bash/includes/bash-helpers.sh
	```
3. Include libs:
	```bash
	include google/client || exit 1
	include mysql/query || exit 1
	include logger || status 'Logger including' $? || exit 1
	```

[Conventional commits src]: https://conventionalcommits.org
[Conventional commits badge]: https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg
[Release img]: https://img.shields.io/badge/release-0.5.1-orange.svg
[Release src]: https://github.com/nafigator/bash-helpers
[License img]: https://img.shields.io/badge/license-MIT-brightgreen.svg
[License src]: https://tldrlegal.com/license/mit-license
