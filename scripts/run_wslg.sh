#!/usr/bin/env bash
# scripts/run_wslg.sh — Windows (WSL2 + WSLg) launcher for the prebuilt
# Linux/amd64 binary. Runs build/main inside the class Docker image
# with WSLg's X11 sockets mounted, so the game draws into a real
# Windows window (hardware-accelerated, no noVNC browser tab).
#
# No source compile — uses the prebuilt build/main that ships in this
# repo. Same binary as bash scripts/run.sh; different display target.
set -euo pipefail

PROJECT_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
IMAGE_NAME="${IMAGE_NAME:-chwoong/team_00_project:0.1.0}"
CONTAINER_NAME="farm-sim-team18-wslg"

# Sanity: confirm we are actually in WSL.
IS_WSL=0
if [[ -n "${WSL_DISTRO_NAME:-}" ]]; then IS_WSL=1; fi
if [[ -f /proc/version ]] && grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then IS_WSL=1; fi
if [[ "${IS_WSL}" -ne 1 ]]; then
    echo "[run-wslg] Not running inside WSL — this script is for Windows + WSL2." >&2
    echo "          On macOS use 'make run-native'. Universal path: 'make run'." >&2
    exit 1
fi

DISPLAY_ARG="${DISPLAY:-:0}"

X11_MOUNT=()
[[ -S /tmp/.X11-unix/X0 ]] && X11_MOUNT=(-v /tmp/.X11-unix:/tmp/.X11-unix)
[[ -d /mnt/wslg ]]         && X11_MOUNT+=(-v /mnt/wslg:/mnt/wslg)

# Find an X11 auth cookie if the user has one — varies by WSLg version
# and distro. Falls back to `xhost +local:` if none exists.
XAUTH_FILE=""
for candidate in "${XAUTHORITY:-}" "${HOME}/.Xauthority" "/mnt/wslg/.Xauthority"; do
    if [[ -n "${candidate}" && -f "${candidate}" ]]; then
        XAUTH_FILE="${candidate}"
        break
    fi
done
if [[ -z "${XAUTH_FILE}" ]] && command -v xhost >/dev/null 2>&1; then
    xhost +local: >/dev/null 2>&1 || true
fi

echo "[run-wslg] DISPLAY=${DISPLAY_ARG}  XAUTHORITY=${XAUTH_FILE:-(none, using xhost)}"

XAUTH_MOUNT=()
XAUTH_ENV=()
if [[ -n "${XAUTH_FILE}" ]]; then
    XAUTH_MOUNT=(-v "${XAUTH_FILE}:/tmp/.X11-cookie:ro")
    XAUTH_ENV=(-e XAUTHORITY=/tmp/.X11-cookie)
fi

docker rm -f "${CONTAINER_NAME}" >/dev/null 2>&1 || true
docker run --rm -it \
    --platform linux/amd64 \
    --name "${CONTAINER_NAME}" \
    -e DISPLAY="${DISPLAY_ARG}" \
    ${XAUTH_ENV[@]+"${XAUTH_ENV[@]}"} \
    ${XAUTH_MOUNT[@]+"${XAUTH_MOUNT[@]}"} \
    ${X11_MOUNT[@]+"${X11_MOUNT[@]}"} \
    -v "${PROJECT_ROOT}":/workspace \
    -w /workspace \
    "${IMAGE_NAME}" \
    bash -c '
        set -e
        chmod +x /workspace/build/main || true
        exec /workspace/build/main
    '
