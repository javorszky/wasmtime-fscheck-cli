# filesystem access check for a wasm module in cli mode

This is a cli module per [the webassembly component model: creating a command component with `cargo component`](https://component-model.bytecodealliance.org/language-support/rust.html#creating-a-command-component-with-cargo-component).

There is a [`wasmtime serve` version of this functionality here](https://github.com/javorszky/wasmtime-fscheck-serve).

## How to use this

1. Have docker installed
2. Clone the repository
3. build the docker image using `make bd` (bd is short for "build docker")
4. either run the container with `make rd` (rd is short for "run docker")
5. or shell into the container with `make shell`, and once inside you can do whatever. The image is based on rust:bullseye, it has wasmtime and strace installed into it

## Reason I know it can access the filesystem

1. first, it actually lists the files / folders in the same directory that the files have been copied into
2. Using `strace -e openat` gives us this output:

```
root@8b654ce26dc5:/shenanigans# strace -e openat wasmtime run --dir=/shenanigans target/wasm32-wasip1/debug/fscheck.wasm
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/aarch64-linux-gnu/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/aarch64-linux-gnu/libgcc_s.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/aarch64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/aarch64-linux-gnu/libm.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/aarch64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/proc/self/maps", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "target/wasm32-wasip1/debug/fscheck.wasm", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/root/.cache/wasmtime/modules/wasmtime-24.0.0/WDO5mNDjiXeo9z0OlDOUgSLcW1rhMAHbOGa9glcoyB4", O_RDONLY|O_CLOEXEC) = 4
openat(AT_FDCWD, "/shenanigans", O_RDONLY|O_CLOEXEC|O_PATH|O_DIRECTORY) = 3   <-- this is why I know the --dir=/shenanigans option worked
openat(AT_FDCWD, "/proc/self/cgroup", O_RDONLY|O_CLOEXEC) = 4
openat(AT_FDCWD, "/proc/self/mountinfo", O_RDONLY|O_CLOEXEC) = 4
openat(AT_FDCWD, "/sys/fs/cgroup/cpu.max", O_RDONLY|O_CLOEXEC) = 4
openat(11, ".", O_RDONLY|O_LARGEFILE|O_NOFOLLOW|O_CLOEXEC|O_DIRECTORY) = 12
openat(12, ".", O_RDONLY|O_LARGEFILE|O_NOFOLLOW|O_CLOEXEC|O_DIRECTORY) = 13
openat(11, ".", O_RDONLY|O_LARGEFILE|O_NOFOLLOW|O_CLOEXEC|O_DIRECTORY) = 12
openat(12, ".", O_RDONLY|O_LARGEFILE|O_NOFOLLOW|O_CLOEXEC|O_DIRECTORY) = 13
/shenanigans/Cargo.lock
/shenanigans/target
/shenanigans/.gitignore
/shenanigans/src
/shenanigans/.git
/shenanigans/Dockerfile
/shenanigans/.dockerignore
/shenanigans/Cargo.toml
/shenanigans/.idea
+++ exited with 0 +++
root@8b654ce26dc5:/shenanigans# exit
```