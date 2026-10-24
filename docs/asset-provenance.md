# Asset provenance

Date: 2026-10-25

## `assets/images/player_fall_sheet.png`

- Purpose: six-frame player stumble/tumble strip for the miss sequence; now
  integrated into the playable miss flow.
- Source reference: the existing `assets/images/player.png` character sprite.
- Behavior reference: `FALL` in `assets/BALLOON.BAS`, lines 300 and 440–550.
- Regenerated with the Codex built-in image generation tool using the exact
  `player.png` character as the visual reference, so the miss poses retain the
  same man used during catches.
- Post-processing: cropped to six equal 362×400 frame cells; preserved as an
  RGBA PNG with transparent background.
- License/provenance status: generated derivative; retain this record with any
  release package and complete the publisher's asset ledger before store
  submission.

## Original object/action inventory

The BASIC source defines these visual objects and uses them as follows:

| Object | Source behavior | Current Flutter status |
|---|---|---|
| `MAN` | Ready/standing player pose | `player.png` |
| `FALL` | Miss movement: rightward zig-zag, then upward exit | `player_fall_sheet.png` integrated in `Player.playMissAnimation` |
| `POP` | Catch/bank/miss burst | `balloon_pop.png` three-frame strip, fixed in code |
| `BALL` | Intact red balloon | `red_balloon.png` |
| `XBALL` | Balloon impact/flash state | Existing pop/feedback projection; dedicated state remains optional |
| `TINY` | Life indicator | Current Flutter HUD uses player icons; review before store art lock |

The source also includes joystick guidance and an intro/demo sequence. Those
are interaction flows rather than production sprites and remain outside this
asset export.
