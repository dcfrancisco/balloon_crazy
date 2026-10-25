# ADR 0016: Establish a distinct V2 visual identity

- Status: Accepted for implementation
- Date: 2026-10-25

## Context

V2 needs to look like a deliberate new edition while keeping the original
character, balloon-catching silhouette, and immediate readability. The concept
boards show a bright illustrated world, but they do not yet define production
rules for the logo, backgrounds, board layers, or user interface.

## Decision

V2 uses a bright arcade-adventure style with crisp characters and balloons over
softly painted scenery. The original green-capped player remains the identity
anchor. The V2 title may be redrawn, but it keeps the words “Balloon Crazy” and
the playful multicolour letter treatment.

### Region art direction

- **Meadow, Levels 1–4:** blue daylight, lake, green grass, distant mountains.
- **Twilight, Levels 5–8:** warm sunset, purple shadows, stronger wind cues.
- **Summit, Levels 9–12:** high-altitude sunset/aurora, dramatic silhouettes,
  highest contrast for hazards.

Each board is assembled from separate sky, distant scenery, near scenery, and
ground layers. Decorative layers never own collision or cover the catch lane.

### Readability rules

- Normal balloons use stable red, yellow, green, blue, and pink silhouettes.
- Specials are distinguishable by both shape/pattern and colour.
- Hazards use dark bodies, warning outlines, and an audio cue; colour alone is
  never the only warning.
- Player, balloons, objective text, and lives must meet strong visual contrast
  against every region background.
- Effects may briefly overlap objects but cannot hide a catch or hazard decision.
- HUD layout and hitboxes remain stable when artwork is replaced.

### Asset rollout

Production art is delivered in this order:

1. V2 logo and Meadow board layers.
2. Player ready, run, catch, bank, fall, and win sheets.
3. Five normal balloons and pop effects.
4. Gold, striped, crystal, skull, heart, and rainbow balloons.
5. Power-up icons and HUD states.
6. Twilight and Summit layers, then level-select presentation.

Every asset follows ADR 0013 for frame manifests and provenance. Generated
concept art is reference material until it has been reviewed, cleaned, split
into production layers, and recorded in the provenance register.

## Consequences

V2 can receive a new visual treatment without moving collision geometry or
changing level balance. Level 1 becomes the art-quality reference board before
the remaining regions are produced.

