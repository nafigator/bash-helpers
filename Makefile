.SILENT: help
.DEFAULT_GOAL:=help

.PHONY: hook
hook: #? Setup git hooks
	$(info Git hooks setup...)
	@git config --local core.hooksPath "$(CURDIR)/.githooks"
	@chmod 0750 -R $(CURDIR)/.githooks/*
	@echo Setup complete

.PHONY: help
help: #? Show this message
	@printf "\033[34;01mApplication management:\033[0m\n"
	@awk '/^@?[a-zA-Z\-\_0-9]+:/ { \
		nb = sub( /^#\? /, "", helpMsg ); \
		if(nb == 0) { \
			helpMsg = $$0; \
			nb = sub( /^[^:]*:.* #\? /, "", helpMsg ); \
		} \
		if (nb) \
			printf "\033[1;31m%-" width "s\033[0m %s\n", $$1, helpMsg; \
		} \
		{ helpMsg = $$0 }' \
	$(MAKEFILE_LIST) | column -ts:
