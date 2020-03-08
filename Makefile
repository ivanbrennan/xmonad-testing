PROJECT_ROOT ?= $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

.PHONY: build
build:
	cabal new-build

.PHONY: run
run: build
	bin/run-in-xephyr.sh

.PHONY: clean
clean:
	rm -f  $(PROJECT_ROOT)/.ghc.environment.*

.PHONY: clean-all
clean-all: clean
	rm -rf $(PROJECT_ROOT)/dist
	rm -rf $(PROJECT_ROOT)/dist-newstyle
