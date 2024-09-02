FROM rust:bullseye

RUN apt update && apt upgrade -y
RUN apt install strace -y

RUN curl https://wasmtime.dev/install.sh -sSf | bash

RUN cargo install cargo-component

WORKDIR /shenanigans

COPY . .

RUN cat Cargo.toml

RUN cargo component build

CMD ["/root/.wasmtime/bin/wasmtime", "run", "--dir=/shenanigans", "./target/wasm32-wasip1/debug/fscheck.wasm"]