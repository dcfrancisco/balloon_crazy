# Asset and sprite plan

Date: 2026-10-25  
Decision: preserve the current identity; complete and normalize it after the gameplay scale is approved.

## Visual essence to retain

- Saturated blue/purple playfield.
- Bright red balloon with a small highlight and tied tail.
- Cheerful red/green pixel skater with a broad stance.
- Multicolor `CRAZY!` wordmark and restrained retro display typography.
- Simple, readable arcade feedback rather than realistic art or heavy particles.

The current screenshots communicate the premise, but tiny downscaled sprites, a large empty vertical field, weak HUD contrast, and inconsistent asset scales keep them from store quality.

## Existing asset disposition

| Asset | Current assessment | Planned disposition |
|---|---|---|
| `assets/images/player.png` | Strong recognizable design; 1024² source downscaled drastically | Keep as style reference; re-export approved pixel-scale frames |
| `assets/images/red_balloon.png` | Used at runtime; 80×94 and stylistically close to current game | Keep as visual reference; normalize into atlas |
| `balloon_red.png`, `balloon_green.png` | Different 48×64 set; unused | Do not ship in v1 unless provenance and future use are approved |
| `balloon_pop.png` | 80×21 three-frame strip; frame metadata absent | Runtime now treats it as a named 3-frame horizontal pop sequence; provenance and final export remain open |
| `heart.png` | 1024²; current lives UI actually uses player art | Decide between tiny skater life icon (more original) or heart; use only one |
| `pop.wav`, `drop.wav`, `game_over.wav` | Packaged but unused; provenance not documented | Audition, normalize, and license-clear before integration or replace |
| DigitalReadout fonts | Bundled; license files claimed but absent | Block release until exact license/source are recorded |
| Press Start 2P via `google_fonts` | Brand fit; not bundled as documented | Bundle licensed font or replace with a cleared local face |
| screenshots and `BalloonCrazy.png` | Historical/product references | Keep outside production bundle; strip device metadata before store use |

## Minimum production sprite set

Use a single consistent grid/pixel density and transparent PNG atlas (or lossless individual files if Flame tooling makes that safer). Required states:

### Player

- idle/ready, 2 frames;
- move left and right, 2 frames each (mirroring allowed only if visually correct);
- catch/recoil, 2 frames;
- bank/pop pose, 2 frames;
- miss/tumble, 6–8 readable frames;
- tiny life icon, 1 frame;
- optional win pose, 2–4 frames.

### Balloon and effects

- intact red balloon, 2 subtle float frames;
- held balloon, 1 frame sized for stack readability;
- pop, 4–6 frames;
- missed/burst marker, 2–3 frames;
- small bank spark/score accent, 3–4 frames (optional if pop is sufficient).

### UI/store

- production app icon master with safe-zone review;
- native launch/splash artwork;
- sound on/off, haptics on/off, pause, resume, close/replay icons;
- store screenshots generated from release builds, not mock gameplay.

## Sprite production brief

- Preserve the current character silhouette, red clothing, green hat/shoes, black outline, and playful stance.
- Preserve the balloon's red/orange highlight and green/blue tail accent, but simplify noisy pixels at small sizes.
- Design at the actual logical render scale; upscale previews with nearest-neighbor only.
- No antialiasing on pixel edges inside the game atlas.
- Provide transparent backgrounds, fixed canvas per animation family, consistent foot/catch anchors, and no frame-to-frame jitter.
- Collision shapes are authored separately in code/data; opaque bounds do not automatically define gameplay fairness.
- Avoid text inside generated raster assets except the approved store/brand master.

## Why sprites were not generated now

The current task explicitly stops before implementation. Player footprint, catch plane, logical resolution, and animation timing are not yet approved through a playable vertical slice. Generating a full sheet now would either constrain those decisions or cause rework. Existing art is sufficient for the first functional slice; generate the missing production set immediately after the renderer/input scale gate.

## Asset acceptance gate

- Pixel-perfect review at 1× logical size and on small/tall physical phones.
- No blurred filtering, clipped stack, anchor jitter, or unreadable silhouette.
- Full provenance/license entry for source and generated derivatives.
- Automated load test and atlas/frame-name validation.
- Audio peaks normalized, no clipping, short effects preloaded, and independent mute behavior verified.
