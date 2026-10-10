#!/data/data/com.termux/files/usr/bin/sh
set -eu

if ! command -v pkg >/dev/null 2>&1; then
  echo "This script must run inside Termux." >&2
  exit 1
fi

pkg update
pkg install -y clang git nodejs pkg-config protobuf python rust rust-std-aarch64-linux-android

echo "Termux build dependencies are installed."
rustc --version
protoc --version

