# Contributing

Thanks for considering a contribution to `bash-helpers`.

## Before you start

- Check [open issues](https://github.com/nafigator/bash-helpers/issues) and [pull requests](https://github.com/nafigator/bash-helpers/pulls) — maybe the topic is already discussed.
- For significant changes, open an issue first to agree on the approach.
- For security issues, do **not** open a public issue. See [SECURITY.md](SECURITY.md).

## Requirements

- Bash 3.2+ (target environment — see README → Dependencies).
- [`shellcheck`](https://www.shellcheck.net/) for static analysis.
- `git` with commit signing optional.

## Development setup

```bash
git clone https://github.com/nafigator/bash-helpers.git
cd bash-helpers
```

The library is a single file: `src/bash-helpers.sh`. There is no build step.

To test your changes locally:

```bash
bash -n src/bash-helpers.sh
shellcheck src/bash-helpers.sh
```

To try the library in a sandbox script:

```bash
cat > /tmp/try.sh <<'EOF'
#!/usr/bin/env bash
. "$PWD/src/bash-helpers.sh"
inform 'works'
EOF
bash /tmp/try.sh
```

## Coding guidelines

- Target **Bash 3.2+**. Do not use bash 4.x-only features (associative arrays, `mapfile`, `${var,,}`, `coproc`) unless the project bumps the minimum version.
- Keep functions **small and single-purpose**.
- Use `local` for variables inside functions. Prefer `local -r` for constants.
- Quote expansions: `"$var"`, `"${arr[@]}"`.
- Prefer `[[ ]]` over `[ ]` in conditionals.
- Prefer `printf` over `echo` for anything non-trivial.
- Return meaningful exit codes: `0` — success, non-zero — failure.
- Do not break existing public function signatures. README declares all function signatures as public API (see Versioning).
- Keep user-facing messages in English.
- Avoid new external dependencies. If a new dependency is unavoidable, document it in README → Dependencies.

## Style

- Indentation: **tabs** (matches the current file).
- Function naming: `lower_snake_case`, public helpers without a prefix.
- Comments: explain *why*, not *what*. Keep them short.
- No trailing whitespace, file ends with a single newline.

## Commits

This project follows [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <short summary>

[optional body]

[optional footer(s)]
```

Common types:

| Type | When |
|------|------|
| `feat` | New function or new capability of an existing function |
| `fix`  | Bug fix |
| `docs` | README, comments, examples |
| `refactor` | Internal change without behavior change |
| `test` | Tests and CI |
| `chore` | Tooling, configs, version bumps |

Examples:

```
feat(status): accept OK/FAIL aliases in addition to codes
fix(float): handle empty and '""' input
docs(readme): document BASH_HELPERS_VERSION
```

Rules:

- One logical change per commit.
- Summary in imperative mood, lowercase, no trailing period.
- Keep the subject under ~72 characters.
- Reference issues in the footer: `Closes #42`.

## Pull requests

1. Fork the repo and create a topic branch from `main`:
   ```bash
   git checkout -b feat/my-change
   ```
2. Make your change. Keep the diff focused.
3. Run `bash -n` and `shellcheck` on the file — CI will run them too.
4. Update README if you add/change/remove a public function, dependency, or configuration variable.
5. Commit using Conventional Commits.
6. Push and open a PR against `main`. Fill in the description: what, why, how to test.
7. Link related issues.

PR checklist:

- [ ] `bash -n src/bash-helpers.sh` passes
- [ ] `shellcheck src/bash-helpers.sh` passes
- [ ] New/changed functions documented in README
- [ ] No new external dependencies (or documented)
- [ ] Public signatures unchanged, or breaking change explicitly noted
- [ ] Commit messages follow Conventional Commits

## Review process

- Maintainers review within a few days.
- Address review comments with new commits (do not force-push during review unless asked).
- Once approved, the PR is squash-merged or merged with a merge commit — maintainer's choice.

## License

By contributing, you agree that your contributions are licensed under the [MIT License](LICENSE).
