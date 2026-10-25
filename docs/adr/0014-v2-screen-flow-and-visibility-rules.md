# ADR 0014: Keep game state and board visibility explicit

- Status: Accepted for planning
- Date: 2026-10-25

## Context

The balloon field belongs in active play. Showing it at startup, on the
leaderboard, or on unrelated menus makes the game state ambiguous and was a
recurring V1 presentation defect.

## Decision

V2 uses explicit screens:

`Home → Mode Select → Level Select → Briefing → Play → Pause/Results`

- The balloon field is created only for Play and may remain frozen behind Pause.
- Home, mode select, level select, briefing, results, leaderboard, and stats do
  not render active balloons.
- Play owns score, lives, objective progress, and held stack presentation.
- Pause freezes simulation; it does not create a second board.
- Results destroy the active board before showing replay or next-level actions.

## Consequences

Screen tests can assert which state owns the board. Navigation cannot leak old
balloons into the leaderboard or startup screen, and lifecycle pause/resume has
one unambiguous simulation owner.

