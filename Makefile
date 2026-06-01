# Demo repo Makefile.
#
# All targets use the prebuilt binaries that ship in build/. No source
# compile, no source-repo clone needed.
#
#   make run        — Docker + noVNC + browser   (works everywhere)
#   make run-shell  — same image, drops to bash for manual launch
#   make run-native — host-native binary, no Docker      (macOS arm64 / Linux x86_64)
#   make run-wslg   — Docker + WSLg passthrough          (Windows 11 + WSL2)

.PHONY: run run-shell run-native run-wslg

run:
	bash scripts/run.sh

run-shell:
	bash scripts/run_shell.sh

run-native:
	bash scripts/run_native.sh

run-wslg:
	bash scripts/run_wslg.sh
