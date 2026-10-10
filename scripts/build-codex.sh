#!/data/data/com.termux/files/usr/bin/sh
set -eu

if [ ! -f "codex-rs/Cargo.toml" ]; then
  echo "Run this script from the root of an openai/codex checkout." >&2
  exit 1
fi

if ! command -v protoc >/dev/null 2>&1; then
  echo "protoc is missing. Run scripts/bootstrap-termux.sh first." >&2
  exit 1
fi

cd codex-rs
CARGO_BUILD_JOBS="${CARGO_BUILD_JOBS:-1}" \
CARGO_PROFILE_RELEASE_LTO="${CARGO_PROFILE_RELEASE_LTO:-false}" \
  cargo build --release -p codex-cli

echo "Built: $(pwd)/target/release/codex"

