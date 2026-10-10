# Security

## Binary releases

The Android ARM64 binaries are community builds, not official OpenAI releases. Verify the release archive and extracted executables against the SHA-256 values published by this repository before installation.

Only install releases from `https://github.com/gsn943314/pocket-lab`.

## Credentials

Do not publish or copy these paths when sharing a Termux setup:

- `~/.codex/`
- `~/.config/gh/`
- shell history files
- `.env` files
- SSH keys
- API keys, cookies, or authentication tokens

This project does not require credentials to be embedded in any script or binary archive. Authenticate Codex separately after installation using its normal login flow.

## Reporting

For vulnerabilities in these scripts or release packaging, open a GitHub security advisory or issue in this repository. Report vulnerabilities in Codex itself through OpenAI's upstream security process.

