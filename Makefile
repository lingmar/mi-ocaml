SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
.SECONDARY:

bin_path=${HOME}/.local/bin
exec_name=mi-ml

.PHONY: build
build: build/${exec_name}

.PHONY: clean
clean:
	rm -rf build/*

# NOTE(vipa, 2023-10-29): Build the compiler

build/${exec_name}: src/compiler/syntax.mc $(shell find src/compiler -name "*.mc")
	mkdir -p build
	mi compile src/compiler/main.mc --output $@

src/compiler/syntax.mc: src/compiler/syntax.syn
	mi syn src/compiler/syntax.syn $@

.PHONY: install
install: build
	mkdir -p ${bin_path};
	cp build/${exec_name} ${bin_path}/${exec_name}
	chmod +x ${bin_path}/${exec_name}
