# ADR 0013: Treat sprites as authored, versioned game assets

- Status: Accepted for planning
- Date: 2026-10-25

## Context

The V2 concept board communicates the desired direction, but it is not a
production sprite sheet. The V1 character is part of the game's identity and
must remain recognisable across ready, catch, bank, run, and fall poses.

## Decision

- Use the V1 player silhouette as the consistency anchor for V2 poses.
- Author or provenance-clear every final sprite; concept images are references,
  not automatically shippable assets.
- Keep visible art separate from collision geometry.
- Record frame size, frame count, anchor point, source, license/provenance, and
  intended scale for each animated sheet.
- Create the player and normal balloon set first; add special balloons, hazards,
  power-ups, and effects only when a level needs them.
- Do not block rules or level playtesting on final art; provisional assets may
  be used behind the same sprite contracts.

## Consequences

Asset review becomes repeatable and legal risk stays visible. Art can improve
without changing hitboxes or level balance, and unused V2 concepts do not
silently enter the APK.

