#!/usr/bin/env bash
# Install kustomize into a temp bin dir and add it to GITHUB_PATH (skips if already present).
set -euo pipefail
if command -v kustomize >/dev/null 2>&1; then
  echo "kustomize already installed: $(command -v kustomize)"
  kustomize version || true
  exit 0
fi
VERSION="v5.4.3"
case "$(uname -m)" in
  x86_64|amd64) ARCH=amd64 ;;
  aarch64|arm64) ARCH=arm64 ;;
  *) echo "unsupported arch $(uname -m)"; exit 1 ;;
esac
BIN_DIR="${RUNNER_TEMP:-/tmp}/kustomize-bin"
mkdir -p "$BIN_DIR"
URL="https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${VERSION}/kustomize_${VERSION}_linux_${ARCH}.tar.gz"
echo "Downloading $URL"
curl -fsSL --retry 3 -o "$BIN_DIR/kustomize.tar.gz" "$URL"
tar -xzf "$BIN_DIR/kustomize.tar.gz" -C "$BIN_DIR"
rm -f "$BIN_DIR/kustomize.tar.gz"
chmod +x "$BIN_DIR/kustomize"
"$BIN_DIR/kustomize" version
echo "$BIN_DIR" >> "$GITHUB_PATH"
