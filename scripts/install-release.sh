#!/data/data/com.termux/files/usr/bin/sh
set -eu

REPOSITORY="gsn943314/pocket-lab"
RELEASE_TAG="android-arm64-2026-09-04"
ARCHIVE="pocket-lab-codex-aarch64-linux-android.tar.zst"
EXPECTED_ARCHIVE_SHA256="0de86c42cc1d49e2be89aa1205d8f0b6b302b9d7bb1161b97c3129d5ca1751c8"

if [ "$(uname -m)" != "aarch64" ]; then
  echo "This release only supports AArch64 Android/Termux." >&2
  exit 1
fi

for command_name in curl sha256sum tar zstd; do
  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Missing command: $command_name" >&2
    exit 1
  fi
done

WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT HUP INT TERM
DOWNLOAD_URL="https://github.com/$REPOSITORY/releases/download/$RELEASE_TAG/$ARCHIVE"

curl -fL --retry 3 -o "$WORK_DIR/$ARCHIVE" "$DOWNLOAD_URL"
printf '%s  %s\n' "$EXPECTED_ARCHIVE_SHA256" "$WORK_DIR/$ARCHIVE" | sha256sum -c -
tar --use-compress-program=unzstd -xf "$WORK_DIR/$ARCHIVE" -C "$WORK_DIR"

printf '%s  %s\n' \
  '98436ae2ac750664a586f3102395d1ac7bfee411af0ec327d5158ba56f66af6b' \
  "$WORK_DIR/codex" | sha256sum -c -
printf '%s  %s\n' \
  'e842d9186367aaec3cac7e1574467f0a8209110a6c05ea4e39686891b1e19e91' \
  "$WORK_DIR/codex-code-mode-host" | sha256sum -c -

install -m 700 "$WORK_DIR/codex" "$PREFIX/bin/codex"
install -m 700 "$WORK_DIR/codex-code-mode-host" "$PREFIX/bin/codex-code-mode-host"

echo "Installed codex and codex-code-mode-host into $PREFIX/bin"
codex --version
