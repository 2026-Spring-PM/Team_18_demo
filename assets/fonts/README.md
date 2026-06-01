# Fonts

All three faces below are bundled in this folder (OFL/SIL licensed) and loaded
in `src/main.cpp`. They are committed to the repo so the game looks identical on
every machine and in the Docker grading container — no system fonts required.

| id        | file                | role                                   | license |
|-----------|---------------------|----------------------------------------|---------|
| `ui`      | `CascadiaMono.ttf`  | Latin UI text (clean monospace)        | OFL 1.1 |
| `kr`      | `D2Coding.ttf`      | Korean (Hangul) UI text — monospace    | OFL 1.1 |
| `default` | `font.ttf` (Galmuri11) | pixel fallback, covers Latin+Hangul | OFL 1.1 |

The renderer (`Renderer::pickUiFont`) routes each string automatically: Latin
goes to `ui`, anything containing Hangul goes to `kr`, and `default` is the
fallback when `ui`/`kr` can't be loaded. `ui`/`kr` are vector fonts rendered
smooth at the exact requested size; Galmuri keeps its 11px pixel-snapping only
when it is the face actually chosen.

License texts / attribution: `CascadiaMono-OFL.txt`, `D2Coding-OFL.txt`,
`Galmuri-OFL.txt`.

To swap a face, drop a new TTF here and update the matching `registerFont(...)`
call in `main.cpp`.
