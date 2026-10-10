# Pocket Lab

Run a practical AI-assisted React Native development loop entirely on an Android phone: Termux provides the terminal and local workspace, Expo CLI runs Metro, Expo Go previews the app, and a native Android ARM64 build of Codex CLI edits the project.

This repository documents the workflow shown in the [Pocket Lab case study](https://davidkuo.tech/projects/pocketlab) and publishes the exact binaries that were tested on the author's phone.

> [!IMPORTANT]
> This is an independent community project, not an official OpenAI or Expo Android distribution. The release binaries currently target **AArch64 Android in Termux** only.

## What is included

- A reproducible Termux-side build for the main `codex` executable
- The one-line patch needed to use Termux's system `protoc`
- A bootstrap script for the required Termux packages
- An install script that downloads and verifies the tested release binaries
- Notes for running Expo CLI and Expo Go on the same phone
- The tested `codex` and `codex-code-mode-host` binaries in GitHub Releases

## Quick install

Install [Termux](https://github.com/termux/termux-app) from F-Droid or GitHub, then run:

```sh
pkg update
pkg install -y curl zstd
curl -fsSLO https://raw.githubusercontent.com/gsn943314/pocket-lab/main/scripts/install-release.sh
chmod +x install-release.sh
./install-release.sh
codex --version
```

The installer downloads both executables from the GitHub Release, checks their SHA-256 digests, and installs them into `$PREFIX/bin`.

## Build Codex on the phone

```sh
git clone https://github.com/openai/codex.git
cd codex
git checkout 3921a30d6b

./path/to/pocket-lab/scripts/bootstrap-termux.sh
git apply ./path/to/pocket-lab/patches/use-system-protoc.patch
./path/to/pocket-lab/scripts/build-codex.sh
```

On the tested phone, the release build needed one Cargo job and LTO disabled to avoid an LLVM out-of-memory failure. It took about 203 minutes and produced a large unstripped binary.

See [Build Codex on Termux](docs/build-codex-on-termux.md) for details.

## One-phone Expo workflow

From a Termux project directory:

```sh
npx create-expo-app@latest my-app
cd my-app
npx expo start --localhost
```

Open the displayed `exp://127.0.0.1:PORT` URL with Expo Go on the same phone. See [Expo workflow](docs/expo-workflow.md) for the tested setup and its limitations.

## Reproducibility status

| Component | Status |
|---|---|
| `codex` | Built on-device from the pinned OpenAI Codex commit; patch and command documented |
| `codex-code-mode-host` | Tested Android ARM64 binary published; exact computer-side V8 cross-build recipe has not yet been reconstructed |
| Expo / Metro loop | Tested locally on the same Android phone |

The host binary is included so the working system can be shared now. Until its complete V8 build recipe is independently repeated, treat it as a verified artifact rather than a reproducible build.

## Security

Never copy or publish `~/.codex`, authentication files, API keys, shell history, or an existing Termux home directory. This repository and its releases contain executables, documentation, patches, and checksums only.

Review [SECURITY.md](SECURITY.md) before installing a binary release.

## Upstream and licensing

Codex CLI is developed by OpenAI at [openai/codex](https://github.com/openai/codex) and is licensed under Apache-2.0. The original scripts and documentation in this repository are MIT licensed. See [NOTICE](NOTICE) for artifact attribution.

