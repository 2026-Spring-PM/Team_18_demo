#!/usr/bin/env bash
# scripts/run_native.sh — launch the prebuilt binary directly on the
# host (no Docker, no VNC). Picks the right binary for the host OS.
#
# Supported:
#   macOS (Apple Silicon)  → build/main_macos_arm64
#   Linux (x86_64)         → build/main          (requires libsfml-graphics2.6 on host)
#
# macOS Intel and other architectures are not covered by the bundled
# binaries — use `bash scripts/run.sh` (Docker + noVNC) instead.
set -euo pipefail

PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${PROJECT_ROOT}"

OS="$(uname -s)"
ARCH="$(uname -m)"

case "${OS}" in
    Darwin)
        case "${ARCH}" in
            arm64)
                BIN="build/main_macos_arm64"
                # macOS needs SFML installed via Homebrew.
                if ! brew --prefix sfml@2 >/dev/null 2>&1; then
                    echo "[run-native] sfml@2 not installed. Run: brew install sfml@2"
                    exit 1
                fi
                ;;
            *)
                echo "[run-native] macOS ${ARCH} is not bundled — only arm64 ships."
                echo "[run-native] Fall back to: bash scripts/run.sh"
                exit 1
                ;;
        esac
        ;;
    Linux)
        case "${ARCH}" in
            x86_64)
                BIN="build/main"
                if ! ldconfig -p 2>/dev/null | grep -q 'libsfml-graphics.so.2.6'; then
                    echo "[run-native] libsfml-graphics2.6 not found on host. Install with:"
                    echo "[run-native]   sudo apt install libsfml-graphics2.6 libsfml-window2.6 libsfml-system2.6"
                    echo "[run-native] Or fall back to: bash scripts/run.sh"
                    exit 1
                fi
                ;;
            *)
                echo "[run-native] Linux ${ARCH} is not bundled — only x86_64 ships."
                echo "[run-native] Fall back to: bash scripts/run.sh"
                exit 1
                ;;
        esac
        ;;
    *)
        echo "[run-native] ${OS} is not supported by this script."
        echo "[run-native] On Windows use: make run-wslg (or make run for the browser fallback)."
        exit 1
        ;;
esac

chmod +x "${BIN}" 2>/dev/null || true
echo "[run-native] launching ${BIN}"
exec "./${BIN}"
