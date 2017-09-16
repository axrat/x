#!/usr/bin/make -f
define README
# README
endef
export README
RUN := /bin/bash
all:readme
readme:
	@echo "==>README"
	@cat README.md
install:
	@./tool/install.sh
uninstall:
	@./tool/uninstall.sh
