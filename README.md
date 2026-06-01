**Due date: 6/1 23:59**

# Farm Village Simulator

SNU 2026 Spring — Programming Methodology, Team 18. A satirical top-down
2D Korean university farm sim written in C++ with SFML. You play a
student who has to earn 3,000,000 골드 to bribe enough professors to
graduate, while tending crops, raising livestock, and building an
automated farm.

This is the **demo / release repo** — it ships a prebuilt Linux/amd64
binary plus the assets needed to run it. Source code lives at
[`2026-Spring-PM/Team_18`](https://github.com/2026-Spring-PM/Team_18).

# Get the repo

```
git clone https://github.com/2026-Spring-PM/Team_18_demo.git
cd Team_18_demo
```

# Run

All targets use the prebuilt binaries shipped in `build/`. No source
compile, no source-repo clone needed. Pick whichever fits your host:

| Your OS | Recommended | Command |
|---|---|---|
| Windows 11 (WSL2 + WSLg) | native window via WSLg | `make run-wslg` |
| macOS (Apple Silicon) | native macOS window | `make run-native` |
| Linux (x86_64, SFML installed) | native Linux window | `make run-native` |
| Anywhere else | Docker + browser | `make run` |

If `make` is not installed, replace `make <target>` with the matching
`bash scripts/<target>.sh`.

## Universal — Docker + browser (`make run`)

Works on every OS that runs Docker. Software-rendered, streamed via
noVNC. This is the canonical class-submission shape.

(1) Pull Docker Image
```
docker pull --platform linux/amd64 chwoong/team_00_project:0.1.0
```
(2) Run the app

Option A — Run automatically:
```
make run
```
or `bash scripts/run.sh`. This starts the container and immediately
launches `build/main`.

Option B — Enter the container first, then run manually:
```
make run-shell
```
or `bash scripts/run_shell.sh`. This drops you into a bash shell
inside the container; launch the binary yourself:
```
./build/main
```

(3) Web browser

http://localhost:6080/vnc.html

## Native (host SFML, no Docker)

```
make run-native
```

Launches the right prebuilt binary directly on the host. Faster than
the Docker path (real OS window, hardware OpenGL).

- **macOS arm64** — uses `build/main_macos_arm64`. Requires
  `brew install sfml@2` (the binary links against Homebrew SFML).
- **Linux x86_64** — uses `build/main`. Requires the host to have
  `libsfml-graphics2.6` etc. installed:
  ```
  sudo apt install libsfml-graphics2.6 libsfml-window2.6 libsfml-system2.6
  ```
- **Other OS / arch** — script errors out cleanly with a fallback
  hint. Use `make run` instead.

## Windows native window via WSLg (`make run-wslg`)

```
make run-wslg
```

From inside a WSL2 Ubuntu shell with Docker Desktop (WSL2 backend)
configured. Runs the prebuilt Linux binary inside the class Docker
image with WSLg's X11 sockets mounted, so the game draws into a real
Windows window — no browser, hardware-accelerated.

Same one-time setup as for `make run` on Windows: Docker Desktop with
WSL2 backend, plus `sudo apt install -y make` inside the WSL Ubuntu.

# Game System

### (1) GUI & Controls
- 2D top-down farm/village sim built with SFML
- Move with **WASD**, sprint with **Shift**, interact with **E**
- Left-click uses the held tool; **1–6** or mouse wheel cycles the hotbar
- **I** Inventory, **B** Build menu, **M** Market, **T** Tech tree, **Esc** Pause

### (2) Goal — graduate by bribing professors
- Earn **3,000,000 골드** by the end of the term and turn it in to 대표조교 (TA) to trigger the ending
- 16 sequential quests from the TA walk the player through every system (tilling, livestock, compost, cooking, power, automation)
- After the main chain, **대학원생 박준서** (a graduate student, appears outdoors at night only) unlocks 3 post-graduation automation quests

### (3) Tile Farming
- Till → water → fertilise → sow → grow → harvest, per-tile state
- **3 crops** (Wheat / Carrot / Corn) × **5 seed tiers** (Lv0..Lv4); higher-tier seeds need Crop Lab / Gene Sequencer to produce and give bigger yield
- **Fertiliser ladder**: Compost Lv0 → Lv1 → Lv2 → Lv3 → Lv4. Each tier shortens grow time further

### (4) Livestock
- Chicken / Sheep / Cow bought at the Hardware Store and placed in animal pens
- Daily product output (Egg / Wool / Milk) + passive Compost Lv0 generation
- Manual-merge breeding: combine two animals of the same tier to produce one at the next tier, up to Lv4

### (5) Cooking
- **Prep Table → Flour, Stone Oven → Bread, Cheese Machine → Cheese**
- Cooked goods sell for several times the raw-ingredient price — the highest gold-per-effort path

### (6) Power Grid & Water Network
- **Grid Hookup + Power Poles** with Factorio-style BFS energisation
- Power-gated devices (Biodigester, Synth Reactor, Water Pump, automation bots) only run when wired
- **Water network**: Lake → Water Pump → Pipe → Sprinkler; auto-waters a 3×3 zone around each sprinkler

### (7) Automation
- **Pipe linker** connects device output to device input — items flow automatically
- **Auto-Planter / Harvester Bot / Auto-Spreader** operate on fixed zones around each bot, all power-gated and Auto-only

### (8) Market & Economy
- Inside the Market building: a **stock-market sim** (4 abstract assets with OU price evolution, news events, options-style portfolio — open with **M**) running alongside the **fixed-price hardware/livestock store**
- Crop prices fluctuate by season and time-of-day
- **Affinity-gated side quests** from outdoor village NPCs unlock at thresholds; talking to villagers builds affinity over time

### (9) Day / Night & Weather
- Four phases per day (Morning / Noon / Evening / Night) with ambient lighting changes
- NPCs follow per-character routines — some only appear at certain times
- Weather (Clear / Rain) is driven by the same event scheduler as the market; rain auto-waters fields

### (10) Tutorial system
- ~22 contextual tutorials fire on first encounter (entering the farm, opening the build menu, crafting the first compost, etc)
- All seen tutorials persist across save/load and are **replayable** from the Quest Tracker (top-left) → **Rewatch Tutorials** button
