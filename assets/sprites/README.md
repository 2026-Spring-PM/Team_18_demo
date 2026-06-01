# Sprites

The game pulls its art from four commercial/free tilesets (LimeZu farm pack +
Modern Exteriors / Interiors / User-Interface by LimeZu). The **full** packs are
~440 MB, far too big for GitHub, and `.gitignore` keeps them out of the repo:

```
assets/sprites/limezu_farm/
assets/sprites/moderninteriors-win/
assets/sprites/modernexteriors-win/
assets/sprites/modernuserinterface-win/
```

## What IS committed (so the demo runs after a clean clone)

Only the **~140 image files the game actually loads** (≈2 MB total) are
force-tracked into the repo, at their original paths inside those ignored
folders. The complete list is in **`USED_ASSETS.txt`**. Plus the hand-made
icons in `custom_icons/`.

That means a teammate can `git clone` and run the demo immediately — no need to
own the full asset packs.

## Regenerating the used-asset list

`AssetManager::registerTexture` is the single loader and
`assets::registerAll()` (in `src/assets/AssetRegistry.cpp`) registers every
texture at startup, so the used set == whatever `registerAll` references. To
refresh the manifest after adding/removing art:

1. Temporarily log each loaded path from `registerTexture` (write `path` to a
   file), run the game once, and collect the unique paths.
2. `git add -f` each path (the `-f` overrides the pack-dir gitignore), and
   update `USED_ASSETS.txt`.

If you DO have the full packs locally, drop them at the four paths above and
everything still resolves — the committed subset is just enough for the demo.

## Licensing note

These tilesets are **not** redistributable in full, which is the other reason
only the minimal in-use subset is committed (fair-use-sized excerpt for a
course demo). For anything public, buy/download the packs from LimeZu:
https://limezu.itch.io/
