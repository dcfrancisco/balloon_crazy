# Original Inspired v1 gameplay rules

Status: canonical recovery specification  
Ruleset ID: `original_inspired_v1`  
Date: 2026-10-25

## Design intent

This mode preserves the recognizable 1985 loop: one falling balloon, a growing stack above the player, increasing speed, automatic banking, row progression, four lives, and a finite board. It corrects ambiguities and apparent listing defects where literal emulation would undermine that loop.

## Board and progression

- The board contains four visible horizontal rows of fifteen balloons: 60 total.
- Play starts with the lowest row, closest to the player, then advances upward one row at a time. This matches `BP=3 → 0` and `BY=BP*20+20` in the BASIC listing; the older reference's “top to bottom” wording is incorrect.
- Exactly one balloon may be active/falling at a time.
- A queued balloon is selected uniformly from the active row using the session's seeded random source.
- The active row advances only after its last selected balloon is caught or missed. The balloon retains its source tier for threshold calculations.
- No new balloon starts while catch, bank, miss, or resume resolution blocks simulation.

## Player and input

- The player moves horizontally only.
- Touch drag maps to a clamped target position. Touch start never teleports outside the valid movement bounds.
- The production implementation must use one coordinate transform from screen space to logical playfield space and test letterboxed aspect ratios.
- Keyboard left/right input may exist, but it cannot produce a gameplay advantage over touch.

## Catch, stack, and difficulty

- A catch succeeds when the active balloon crosses the current catch plane while horizontally overlapping the configured catch window.
- A successful catch removes the active balloon, adds one unbanked balloon to the visible stack, raises the player/catch plane by one stack step, and increases fall speed for the next balloon.
- A catch awards **zero immediate points**. The balloon remains at risk until banked.
- Base fall speed returns after a bank or miss. This intentionally treats BASIC line 430's `SP1=4` as a likely typo for `SP!=4`.
- Catch detection is continuous/swept across the timestep so a slow frame cannot tunnel through the catch plane.

## Banking and score

- Banking is automatic; v1 has no fire button.
- Required held counts by source tier are:

| Tier played | Source `BP` | Required to bank |
|---|---:|---:|
| 1, lowest row | 3 | 4 |
| 2 | 2 | 5 |
| 3 | 1 | 6 |
| 4, highest row | 0 | 7 |

- At the threshold, the domain enters `banking`; each held balloon becomes safe and awards 10 points.
- Presentation may pop balloons sequentially, but score settlement is one atomic domain transaction. Restart or interruption cannot produce a partial/double bank.
- After banking: held count is zero, player/catch plane returns to base height, and fall speed returns to base.
- When the final board balloon resolves, any remaining held balloons are banked before the win result.
- Maximum score for clearing all 60 balloons is 600. Missed balloons and held balloons lost on a miss score zero.

## Miss and lives

- A balloon crossing the miss plane unresolved causes exactly one miss.
- A miss discards the active balloon and every held/unbanked balloon, decrements one life, returns player/catch plane and speed to base, and plays the miss/tumble sequence.
- The session starts with four lives. Lives never go below zero.
- After a non-terminal miss, the next balloon comes from the remaining active row.
- At zero lives, the session becomes `gameOver` and rejects all gameplay commands.

## Win, result, and leaderboard

- Win occurs only after all 60 board balloons have resolved and the final held stack has banked.
- Win and game over both create an immutable result containing ruleset ID, score, outcome, duration, and completion time.
- Both outcomes may qualify for the same local leaderboard. Capturing a name is optional and must not block replay.
- Restart always creates a new session ID; effects and callbacks from the previous session are ignored.

## Pause and lifecycle

- Opening pause, backgrounding the app, losing focus, or receiving an interruption stops simulation time and input immediately.
- Returning after a lifecycle interruption shows a paused overlay and requires an explicit resume action.
- No catch, miss, bank, or spawn can occur while paused.

## Required feedback

- Catch: stack grows, short rising sound, optional light haptic.
- Bank: readable pop cadence, score change, player settles, stronger success haptic.
- Miss: missed balloon pop, held stack loss, character tumble, life change, descending sound.
- Last life/game over and final clear/win must be visually and audibly distinct.
- Audio and haptics can be disabled independently. Reduced motion shortens/nonessential movement without changing rules.

## Acceptance examples

1. Starting tier 1 with zero held: four catches yield zero until the fourth catch settles a 40-point bank.
2. Three tier-1 catches followed by a miss leave score unchanged, clear the three held balloons, and reduce lives from 4 to 3.
3. After a tier-2 bank of five, the score increases by 50 once, even if the pop animation is interrupted by backgrounding.
4. Selecting the final balloon of a row does not change that balloon's bank threshold to the next tier.
5. Clearing the last board balloon with three held banks all four held balloons, then produces a win.
6. Sending catch and miss candidates for the same balloon resolves it once according to crossing/collision order and cannot both score and lose a life.
7. Restarting during a bank produces a new zero-score session; completion of the old bank cannot change it.
8. The same seed and command/timestep trace produces the same selected columns, events, and final result.

## Intentional differences from the current prototype

- 60 balloons, not 40.
- One falling balloon, not multiple timer-spawned balloons.
- Lowest row first, not random columns across all rows.
- Score only on bank, not catch plus bank.
- Player and catch plane rise with the held stack.
- Fall speed actually increases after catches and resets after resolution.
- Threshold follows source tier instead of a disconnected constant.
- Both terminal outcomes use the result/leaderboard flow.

## Intentional differences from literal BASIC execution

- The apparent `SP1` reset typo is corrected to reset speed.
- Tier transition occurs after the last balloon resolves, avoiding a last-balloon threshold off-by-one.
- Timing is elapsed-time based rather than CPU/frame-loop based.
- Touch, pause, lifecycle safety, settings, and continuous collision are modern additions.
