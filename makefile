BINARY="./target/wasm32-wasi/debug/fs_check.wasm"
DIRSPEC="--dir=/Users/g.javorszky/Projects/webassembly/fs_check::/usr"

.PHONY: build
build:
	cargo component build

.PHONY: run
run:
	wasmtime run ${BINARY} ${DIRSPEC}

.PHONY: trace
trace:
	WASMTIME_BACKTRACE_DETAILS=1 sudo dtruss wasmtime run ${BINARY} ${DIRSPEC}

.PHONY: bd
bd:
	docker build -f Dockerfile . -t local:wasm-fs

.PHONY: dr
dr:
	docker run local:wasm-fs

.PHONY: shell
shell:
	docker run -it local:wasm-fs /bin/bash