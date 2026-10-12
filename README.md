# Pocket Lab

I wanted to find out if I could build a phone app using nothing but a phone. This repo is what came out of it: the scripts, a small patch, and the Codex binaries I use to run a full React Native workflow inside Termux on an Android phone.

Termux is the terminal, Expo CLI runs Metro, Expo Go shows the app, and a Codex CLI built for Android ARM64 edits the code. The full story, including everything that broke along the way, is on [my site](https://davidkuo.tech/projects/pocketlab).

> [!IMPORTANT]
> This is a personal project, not an official OpenAI or Expo release. The binaries only run on ARM64 (aarch64) Android inside Termux.

## What you need

- An ARM64 Android phone with about 2 GB of free storage
- [Termux](https://f-droid.org/packages/com.termux/) from F-Droid (or the [GitHub releases](https://github.com/termux/termux-app/releases))
- [Expo Go](https://play.google.com/store/apps/details?id=host.exp.exponent) from Google Play

## Install Codex

Compiling Codex on a phone takes more than three hours, so I put the binaries I built in the [releases](https://github.com/gsn943314/pocket-lab/releases). The install script downloads them, checks their SHA-256 hashes, and puts them in `$PREFIX/bin`:

```sh
pkg update
pkg install -y curl zstd openssl liblzma
curl -fsSLO https://raw.githubusercontent.com/gsn943314/pocket-lab/main/scripts/install-release.sh
chmod +x install-release.sh
./install-release.sh
```

If `pkg update` asks whether to replace a configuration file, pressing Enter to keep the default is fine.

Then run `codex` and sign in the usual way.

The release is built from the Codex source as of September 4, 2026. If it stops working with newer Codex services, building a newer version yourself is the way forward.

If you'd rather build it yourself, the steps and the one-line patch are in [docs/build-codex-on-termux.md](docs/build-codex-on-termux.md). Expect a long build and a lot of memory use: even on a Pixel 10, the default build ran out of memory until I limited it to one job. One piece, `codex-code-mode-host`, depends on V8, which has no prebuilt version for Android, so I built that one on a computer. It works on my phone, but I haven't written up a repeatable recipe for it yet.

## Run Expo on the same phone

```sh
pkg install -y nodejs
npx create-expo-app@latest my-app
cd my-app
npx expo start --localhost
```

In Expo Go, enter the `exp://` address that Metro prints, and the app shows up on the same phone.

My usual setup is two Termux sessions: one running Metro, and one running Codex in the project folder. I make changes through Codex and see the result in Expo Go.

Android may stop Termux in the background while you're looking at Expo Go. Running `termux-wake-lock` first helps keep Metro alive.

One limit worth knowing: Expo Go is a prebuilt app, so anything that needs new native code or special Android permissions (like drawing over other apps) needs a development build instead. More in [docs/expo-workflow.md](docs/expo-workflow.md).

## License

My scripts and docs are MIT licensed. Codex is made by OpenAI ([openai/codex](https://github.com/openai/codex)) under Apache-2.0, and the release binaries are built from it. See [NOTICE](NOTICE).
