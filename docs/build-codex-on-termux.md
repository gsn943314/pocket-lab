# Build Codex on Termux

## Tested environment

- Android / Termux on AArch64
- OpenAI Codex commit `3921a30d6b`
- Rust `1.98.1`
- protobuf / `protoc` `35.1`
- clang `21.1.8`

The upstream source-build documentation currently lists desktop operating systems, not Android. This build is a community experiment and may require updates as upstream changes.

## Steps

Clone this repo and the upstream Codex source next to each other, and pin Codex to the tested commit:

```sh
mkdir -p "$HOME/src" && cd "$HOME/src"
git clone https://github.com/gsn943314/pocket-lab.git
git clone https://github.com/openai/codex.git
cd codex
git checkout 3921a30d6b
```

Install the build dependencies:

```sh
../pocket-lab/scripts/bootstrap-termux.sh
```

Apply the Android `protoc` patch:

```sh
git apply ../pocket-lab/patches/use-system-protoc.patch
```

Build. On the tested phone this took about 203 minutes, so keep Termux awake with `termux-wake-lock` and keep the phone charging:

```sh
../pocket-lab/scripts/build-codex.sh
```

Install the result:

```sh
install -m 700 codex-rs/target/release/codex "$PREFIX/bin/codex"
```

This builds `codex` only. For `codex-code-mode-host`, use the binary from the release (see [Code Mode host](#code-mode-host) below).

## Why the patch is needed

`protoc-bin-vendored` did not provide a bundled executable for the detected Android target. Termux already packages a working native `protoc`, so the patch points the build script to the executable on `PATH`.

## Why one build job is used

The initial release build reached an LLVM out-of-memory error while compiling late workspace crates. Limiting Cargo to one job and disabling release LTO allowed the build to finish:

```sh
CARGO_BUILD_JOBS=1 CARGO_PROFILE_RELEASE_LTO=false \
  cargo build --release -p codex-cli
```

## Code Mode host

Current Codex builds use a separate `codex-code-mode-host` executable. It depends on V8, and the upstream prebuilt V8 download did not contain the required Android target. The working host distributed in this project's first release was cross-built on a computer and tested in Termux.

The exact V8 cross-build environment was not preserved, so this repository does not yet claim that host build is reproducible. The release records the binary checksum and upstream commit instead of inventing missing steps.

