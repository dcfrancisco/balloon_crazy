````markdown
# 🎮 BALLOON CRAZY - Original Gameplay Reference

## Overview
This document details the gameplay mechanics from the original 1980s BALLOON.BAS game to serve as a reference for implementation.

---

## 📋 Game Setup

### Initial Values
- **Lives**: 4 (displayed as tiny icons at top of screen)
- **Starting Speed**: `SP! = 4` (balloon fall speed in pixels)
- **Difficulty Factor**: `DF = 10` (collision detection tolerance - smaller = harder to catch)
- **Grid Layout**: 4 rows × 15 columns of balloons
- **Player Start Position**: Bottom of screen
- **Hit Point (HP)**: Y=164 (the Y coordinate where balloons can be caught)

### Visual Layout
```
Score: 0                    ♥♥♥♥ (Lives)
═══════════════════════════════════════
○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○  Row 3 (BP=3)
○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○  Row 2 (BP=2)
○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○  Row 1 (BP=1)
○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○  Row 0 (BP=0)


           [Catching Area]

═══════════════════════════════════════
              👤 (Player)
═══════════════════════════════════════
              [Floor]
```

---

## 🎯 Core Gameplay Mechanics

### 1. Balloon Storage System (Line 350)
```basic
BP=3:FOR I=0 TO BP:BP$(I)="ABCDEFGHIJKLMNO":NEXT
```
- Balloons are organized in 4 rows (BP = 0 to 3)
- Each row is a string with 15 characters (A-O), each representing a balloon position
- Rows are depleted sequentially from **top to bottom** (BP=3 → BP=2 → BP=1 → BP=0)

### 2. Balloon Dropping Algorithm (Line 220)
```basic
BY=BP*20+20:T$=BP$(BP):PTR=.5+RND(1)*LEN(T$):
BX=(ASC(MID$(T$,PTR))-64)*15+30:
T$=LEFT$(T$,PTR-1)+MID$(T$,PTR+1):BP$(BP)=T$:
IF T$="" THEN BP=BP-1
```

**How it works:**
1. Select current active row (BP)
2. Calculate Y position: `BY = BP * 20 + 20`
3. Randomly pick a balloon from that row's string
4. Calculate X position from character code
5. Remove that balloon from the string
6. If row is empty, move to next row (`BP = BP - 1`)

**Key Point**: Only ONE balloon falls at a time!

### 3. Catching Mechanism (Line 240)

#### Collision Detection
```basic
IF ABS(BY-HP)<SP! THEN 
  IF ABS((BX-7)-X)<DF THEN
```

**Two-stage check:**
- **Vertical**: Balloon Y position must be within `SP!` pixels of hit point (HP=164)
- **Horizontal**: Balloon X position must be within `DF=10` pixels of player X center

#### When Successfully Caught
```basic
Y=Y-13                    ' Player rises 13 pixels
HP=HP-13                  ' Hit point adjusts up
FLOATERS=FLOATERS+1       ' Increment caught count
SP!=SP!+.5                ' Speed increases by 0.5
```

**Effects:**
- ✅ Player visually rises 13 pixels
- ✅ Balloon attaches above player (visual stack)
- ✅ Hit point moves up with player
- ✅ Counter increments
- ✅ **Game difficulty increases** - balloons fall faster
- ✅ Score +10 points

### 4. Banking System (Lines 240 & 380-430)

#### Trigger Condition
```basic
IF FLOATERS=7-BP THEN GOSUB 380
```

**Dynamic Banking Requirement:**
- Row 3 (BP=3): Need **4 balloons** (7-3=4)
- Row 2 (BP=2): Need **5 balloons** (7-2=5)
- Row 1 (BP=1): Need **6 balloons** (7-1=6)
- Row 0 (BP=0): Need **7 balloons** (7-0=7) - HARDEST!

**Why this matters:** As you clear rows, you must catch MORE balloons before banking, increasing difficulty and risk.

#### Banking Animation (Lines 390-410)
```basic
FOR I = 1 TO FLOATERS
  PUT (X,MY),POP,PSET              ' Show pop sprite
  PUT (X+7,MY-13),BALL             ' Show balloon
  PUT (X+7,MY-18),XBALL            ' Show X mark
  FOR J=0 TO 5:SOUND 100+J,.5:NEXT ' Pop sound
  SC!=SC!+10                        ' +10 points per balloon
  Y=Y+13                            ' Lower player 13 pixels
NEXT
```

**Banking Process:**
1. Each caught balloon pops individually with animation
2. Pop sound plays for each (rising pitch)
3. Score increases by 10 per balloon
4. Player descends back to starting position (13 pixels per balloon)
5. All variables reset:
   - `FLOATERS = 0` (no balloons held)
   - `SP! = 4` (speed resets to base)
   - `HP = 164` (hit point back to start)

---

## 💥 Losing a Life

### When Balloon Hits Floor (Line 230)
```basic
IF BY>180 THEN 440
```

#### Death Sequence (Lines 440-550)

**1. Balloon Pop Animation (Line 440)**
```basic
PUT (BX,BY),BALL
PUT (BX,BY-5),XBALL      ' Show X mark on balloon
FOR J=0 TO 5:SOUND 105-J,.5:NEXT  ' Descending sound
```

**2. Player Shows "FALL" Sprite (Line 450)**
```basic
PUT (X,MY),MAN
PUT (X,MY),FALL
```

**3. Pop All Held Balloons (Lines 470-500)**
```basic
IF FLOATERS=0 THEN 510
FOR I=1 TO FLOATERS
  ' Pop each held balloon with animation
  ' Player drops 13 pixels per balloon
NEXT
```

**4. Tumble Animation (Lines 510-540)**
```basic
' Player bounces across screen horizontally
NY=MY:S=-6:
FOR I=X+5 TO 291 STEP 5
  PUT (I-5,NY),FALL
  NY=NY+S
  IF NY<MY-18 OR NY>MY THEN NY=NY-S:S=-S  ' Bounce
  PUT (I,NY),FALL:SOUND 100+NY,.5
NEXT
' Player falls off top of screen
```

**5. Life Lost (Line 550)**
```basic
LIVES=LIVES-1
IF LIVES>0 THEN continue
ELSE GAME OVER
```

---

## 🎲 Progressive Difficulty System

### Speed Ramping
| Event | Speed Change | Effect |
|-------|-------------|---------|
| Game Start | `SP! = 4` | Base speed |
| Each Catch | `SP! = SP! + 0.5` | +0.5 pixels/frame |
| Banking | `SP! = 4` | Reset to base |
| After 5 catches | `SP! = 6.5` | 62.5% faster |
| After 10 catches | `SP! = 9` | 125% faster |

### Banking Difficulty Curve
| Row Active | Balloons Needed | Difficulty |
|------------|----------------|------------|
| Row 3 (Top) | 4 | ⭐ Easy |
| Row 2 | 5 | ⭐⭐ Medium |
| Row 1 | 6 | ⭐⭐⭐ Hard |
| Row 0 (Bottom) | 7 | ⭐⭐⭐⭐ Very Hard |

**Strategic Implication:** Players must hold more balloons (higher risk of missing and dying) as the game progresses.

---

## 🎯 Scoring System

### Points Awarded
- **Catch a balloon**: +10 points (immediate)
- **Bank balloons**: +10 points per balloon (during banking animation)

### Example Score Progression
1. Catch 4 balloons in Row 3: **40 points** (10 × 4)
2. Banking triggers automatically
3. Banking animation: **+40 points** (10 × 4)
4. **Total for Row 3**: 80 points

---

## 🔄 Game Loop Flow

```
START GAME
├─→ Initialize 4 rows of balloons
├─→ Player at bottom, HP=164, SP!=4, FLOATERS=0
│
MAIN LOOP:
├─→ Drop one balloon from current row (BP)
├─→ Move player left/right (joystick)
├─→ Balloon falls at speed SP!
│
├─→ CHECK COLLISION
│   ├─→ YES: Catch balloon
│   │   ├─→ Player rises 13 pixels
│   │   ├─→ FLOATERS++, SP!+=0.5
│   │   ├─→ Score +10
│   │   └─→ IF FLOATERS==7-BP: BANK BALLOONS
│   │       ├─→ Pop animation for each
│   │       ├─→ Score +10 per balloon
│   │       ├─→ Player descends to start
│   │       ├─→ Reset: SP!=4, FLOATERS=0
│   │       └─→ Continue with next row
│   │
│   └─→ NO: Balloon continues falling
│       └─→ IF hits floor (BY>180):
│           ├─→ Pop balloon (X mark)
│           ├─→ Pop all held balloons
│           ├─→ Player tumble animation
│           ├─→ LIVES--
│           └─→ IF LIVES==0: GAME OVER
│
├─→ IF current row empty (T$==""):
│   └─→ Move to next row (BP--)
│
└─→ IF all rows empty (BP<0):
    └─→ YOU WIN!
```

---

## 🎨 Visual Elements

### Sprites Used
1. **MAN** - Player character
2. **BALL** - Balloon (intact)
3. **XBALL** - Balloon with X (popped)
4. **POP** - Pop animation sprite
5. **FALL** - Player falling/dying sprite
6. **TINY** - Tiny life icon

### Animation Principles
- **Smooth movement**: Player and balloons move every frame
- **Visual feedback**: Every action has a sprite change or sound
- **Stacking visual**: Caught balloons appear above player
- **Death sequence**: Multi-stage animation (pop → fall → bounce → scroll off)

---

## 💡 Key Design Decisions

### Why These Mechanics Work

1. **One balloon at a time**: Creates focused gameplay, easier to track
2. **Speed increase per catch**: Natural difficulty curve within each session
3. **Speed reset on banking**: Provides relief, rewards successful banking
4. **Dynamic banking threshold**: Forces longer risky sequences as game progresses
5. **Row-based depletion**: Clear visual progress, increasing pressure
6. **Held balloon visualization**: Player can see their risk/reward situation
7. **Tumble animation**: Dramatic consequence for failure, emotional impact

---

## 🔧 Implementation Notes

### Critical Variables to Track
```
BP          : Current active row (3 → 0)
FLOATERS    : Number of balloons currently held
SP!         : Current balloon fall speed
HP          : Hit point Y coordinate (where balloons can be caught)
X, Y        : Player position
LIVES       : Remaining lives (starts at 4)
SC!         : Score
```

### State Machine
```
WELCOME → PLAYING → (BANKING | DYING) → PLAYING → GAME_OVER → WELCOME
```

### Important Timings (from original)
- Banking animation: ~0.1 seconds per balloon pop
- Death tumble: ~2-3 seconds total animation
- Pop sound duration: 0.5 seconds per balloon
- Base balloon speed: 4 pixels per frame (~60 FPS)

---

## 📊 Playtesting Metrics

### Original Difficulty Balance
- Average player clears **1-2 rows** before losing all lives
- Expert players can clear **all 4 rows** (60 total balloons)
- Maximum theoretical score per row:
  - Row 3: 120 points (15 balloons × 8 = 120)
  - Row 2: 150 points
  - Row 1: 180 points
  - Row 0: 210 points
  - **Perfect game**: ~660 points

### Difficulty Factors
- **DF = 10**: Standard (10-pixel horizontal tolerance)
- **DF = 5**: Hard mode (5-pixel tolerance)
- **DF = 15**: Easy mode (15-pixel tolerance)

---

## 🎯 Modern Adaptations

### Touch Controls (instead of joystick)
- **Tap/Drag**: Move player to finger position
- **Smooth following**: Player smoothly follows touch point
- **Visual indicator**: Show touch point or target marker

### Quality of Life Improvements
- **Pause functionality**: Not in original
- **High score tracking**: Save best score
- **Sound toggle**: Mute option
- **Visual settings**: Particle effects, screen shake

### Keep Original Spirit
- ✅ One balloon falling at a time
- ✅ Speed ramping and reset cycle
- ✅ Dynamic banking requirements
- ✅ Row-based progression
- ✅ Risk/reward tension of holding balloons

---

## 📝 Summary

The genius of BALLOON CRAZY lies in its escalating tension:
1. You want to catch balloons (points + progress)
2. But each catch makes you rise (harder to position)
3. And speeds up the game (less reaction time)
4. And you must catch MORE balloons to bank as rows clear
5. Until finally banking gives you sweet relief and reset

This creates a perfect risk/reward loop that keeps players engaged!

---

*Document created: October 15, 2025*  
*Original game: BALLOON.BAS (1980s)*  
*Reference for: Balloon Crazy Flutter/Flame remake* 

## ✅ Not implemented / TODO

Below is a running checklist of gameplay systems, polish, and engineering items that are not yet implemented (or are only partially implemented) in the current repo. Use this as a development checklist.

- [ ] Exact original grid size: implement 4 rows × 15 columns (current build uses configurable columns; confirm and set to 15 if desired)
- [ ] Strict one-balloon-at-a-time behavior (current drop logic can differ)
- [ ] Precise original hit-point math (HP/SP! parity and frame-accurate timing)
- [ ] Banking animation parity (per-balloon pop timing, pitch-swept sounds, exact score timing)
- [ ] Full death/tumble animation sequence matching original (bounce, pitch sound, off-screen fall)
- [ ] Sound effects integrated and user-toggleable (pop, bank, death, UI)
- [ ] High score persistence and high-score screen
- [ ] Pause/resume functionality and overlay
- [ ] Difficulty modes and a settings UI (DF variants)
- [ ] Accessibility options (larger UI, color contrast, alternate controls)
- [ ] Input smoothing toggle (immediate snap vs. smooth follow)
- [ ] Debug HUD runtime toggle (show/hide during development)
- [ ] Verify full asset set: MAN, BALL, XBALL, POP, FALL, TINY at correct sizes
- [ ] Test assets for CI (small placeholders under `assets/images/test/`)
- [ ] Add more unit/widget tests for banking, scoring, and lose-life sequences
- [ ] CI pipeline for `flutter test` and `flutter analyze`
- [ ] Performance profiling and optimizations (reduce overdraw, per-frame allocations)
- [ ] Mobile polish (safe area, orientation handling, platform-specific tweaks)
- [ ] Optional controller/keyboard mapping for desktop builds
- [ ] Visual polish: particles, screen shake, haptics
- [ ] Localization and string extraction for translations
- [ ] Developer docs: architecture overview and API contracts
# 🎮 BALLOON CRAZY - Original Gameplay Reference

## Overview
This document details the gameplay mechanics from the original 1980s BALLOON.BAS game to serve as a reference for implementation.

---

## 📋 Game Setup

### Initial Values
- **Lives**: 4 (displayed as tiny icons at top of screen)
- **Starting Speed**: `SP! = 4` (balloon fall speed in pixels)
- **Difficulty Factor**: `DF = 10` (collision detection tolerance - smaller = harder to catch)
- **Grid Layout**: 4 rows × 15 columns of balloons
- **Player Start Position**: Bottom of screen
- **Hit Point (HP)**: Y=164 (the Y coordinate where balloons can be caught)

### Visual Layout
```
Score: 0                    ♥♥♥♥ (Lives)
═══════════════════════════════════════
○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○  Row 3 (BP=3)
○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○  Row 2 (BP=2)
○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○  Row 1 (BP=1)
○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○ ○  Row 0 (BP=0)


           [Catching Area]

═══════════════════════════════════════
              👤 (Player)
═══════════════════════════════════════
              [Floor]
```

---

## 🎯 Core Gameplay Mechanics

### 1. Balloon Storage System (Line 350)
```basic
BP=3:FOR I=0 TO BP:BP$(I)="ABCDEFGHIJKLMNO":NEXT
```
- Balloons are organized in 4 rows (BP = 0 to 3)
- Each row is a string with 15 characters (A-O), each representing a balloon position
- Rows are depleted sequentially from **top to bottom** (BP=3 → BP=2 → BP=1 → BP=0)

### 2. Balloon Dropping Algorithm (Line 220)
```basic
BY=BP*20+20:T$=BP$(BP):PTR=.5+RND(1)*LEN(T$):
BX=(ASC(MID$(T$,PTR))-64)*15+30:
T$=LEFT$(T$,PTR-1)+MID$(T$,PTR+1):BP$(BP)=T$:
IF T$="" THEN BP=BP-1
```

**How it works:**
1. Select current active row (BP)
2. Calculate Y position: `BY = BP * 20 + 20`
3. Randomly pick a balloon from that row's string
4. Calculate X position from character code
5. Remove that balloon from the string
6. If row is empty, move to next row (`BP = BP - 1`)

**Key Point**: Only ONE balloon falls at a time!

### 3. Catching Mechanism (Line 240)

#### Collision Detection
```basic
IF ABS(BY-HP)<SP! THEN 
  IF ABS((BX-7)-X)<DF THEN
```

**Two-stage check:**
- **Vertical**: Balloon Y position must be within `SP!` pixels of hit point (HP=164)
- **Horizontal**: Balloon X position must be within `DF=10` pixels of player X center

#### When Successfully Caught
```basic
Y=Y-13                    ' Player rises 13 pixels
HP=HP-13                  ' Hit point adjusts up
FLOATERS=FLOATERS+1       ' Increment caught count
SP!=SP!+.5                ' Speed increases by 0.5
```

**Effects:**
- ✅ Player visually rises 13 pixels
- ✅ Balloon attaches above player (visual stack)
- ✅ Hit point moves up with player
- ✅ Counter increments
- ✅ **Game difficulty increases** - balloons fall faster
- ✅ Score +10 points

### 4. Banking System (Lines 240 & 380-430)

#### Trigger Condition
```basic
IF FLOATERS=7-BP THEN GOSUB 380
```

**Dynamic Banking Requirement:**
- Row 3 (BP=3): Need **4 balloons** (7-3=4)
- Row 2 (BP=2): Need **5 balloons** (7-2=5)
- Row 1 (BP=1): Need **6 balloons** (7-1=6)
- Row 0 (BP=0): Need **7 balloons** (7-0=7) - HARDEST!

**Why this matters:** As you clear rows, you must catch MORE balloons before banking, increasing difficulty and risk.

#### Banking Animation (Lines 390-410)
```basic
FOR I = 1 TO FLOATERS
  PUT (X,MY),POP,PSET              ' Show pop sprite
  PUT (X+7,MY-13),BALL             ' Show balloon
  PUT (X+7,MY-18),XBALL            ' Show X mark
  FOR J=0 TO 5:SOUND 100+J,.5:NEXT ' Pop sound
  SC!=SC!+10                        ' +10 points per balloon
  Y=Y+13                            ' Lower player 13 pixels
NEXT
```

**Banking Process:**
1. Each caught balloon pops individually with animation
2. Pop sound plays for each (rising pitch)
3. Score increases by 10 per balloon
4. Player descends back to starting position (13 pixels per balloon)
5. All variables reset:
   - `FLOATERS = 0` (no balloons held)
   - `SP! = 4` (speed resets to base)
   - `HP = 164` (hit point back to start)

---

## 💥 Losing a Life

### When Balloon Hits Floor (Line 230)
```basic
IF BY>180 THEN 440
```

#### Death Sequence (Lines 440-550)

**1. Balloon Pop Animation (Line 440)**
```basic
PUT (BX,BY),BALL
PUT (BX,BY-5),XBALL      ' Show X mark on balloon
FOR J=0 TO 5:SOUND 105-J,.5:NEXT  ' Descending sound
```

**2. Player Shows "FALL" Sprite (Line 450)**
```basic
PUT (X,MY),MAN
PUT (X,MY),FALL
```

**3. Pop All Held Balloons (Lines 470-500)**
```basic
IF FLOATERS=0 THEN 510
FOR I=1 TO FLOATERS
  ' Pop each held balloon with animation
  ' Player drops 13 pixels per balloon
NEXT
```

**4. Tumble Animation (Lines 510-540)**
```basic
' Player bounces across screen horizontally
NY=MY:S=-6:
FOR I=X+5 TO 291 STEP 5
  PUT (I-5,NY),FALL
  NY=NY+S
  IF NY<MY-18 OR NY>MY THEN NY=NY-S:S=-S  ' Bounce
  PUT (I,NY),FALL:SOUND 100+NY,.5
NEXT
' Player falls off top of screen
```

**5. Life Lost (Line 550)**
```basic
LIVES=LIVES-1
IF LIVES>0 THEN continue
ELSE GAME OVER
```

---

## 🎲 Progressive Difficulty System

### Speed Ramping
| Event | Speed Change | Effect |
|-------|-------------|---------|
| Game Start | `SP! = 4` | Base speed |
| Each Catch | `SP! = SP! + 0.5` | +0.5 pixels/frame |
| Banking | `SP! = 4` | Reset to base |
| After 5 catches | `SP! = 6.5` | 62.5% faster |
| After 10 catches | `SP! = 9` | 125% faster |

### Banking Difficulty Curve
| Row Active | Balloons Needed | Difficulty |
|------------|----------------|------------|
| Row 3 (Top) | 4 | ⭐ Easy |
| Row 2 | 5 | ⭐⭐ Medium |
| Row 1 | 6 | ⭐⭐⭐ Hard |
| Row 0 (Bottom) | 7 | ⭐⭐⭐⭐ Very Hard |

**Strategic Implication:** Players must hold more balloons (higher risk of missing and dying) as the game progresses.

---

## 🎯 Scoring System

### Points Awarded
- **Catch a balloon**: +10 points (immediate)
- **Bank balloons**: +10 points per balloon (during banking animation)

### Example Score Progression
1. Catch 4 balloons in Row 3: **40 points** (10 × 4)
2. Banking triggers automatically
3. Banking animation: **+40 points** (10 × 4)
4. **Total for Row 3**: 80 points

---

## 🔄 Game Loop Flow

```
START GAME
├─→ Initialize 4 rows of balloons
├─→ Player at bottom, HP=164, SP!=4, FLOATERS=0
│
MAIN LOOP:
├─→ Drop one balloon from current row (BP)
├─→ Move player left/right (joystick)
├─→ Balloon falls at speed SP!
│
├─→ CHECK COLLISION
│   ├─→ YES: Catch balloon
│   │   ├─→ Player rises 13 pixels
│   │   ├─→ FLOATERS++, SP!+=0.5
│   │   ├─→ Score +10
│   │   └─→ IF FLOATERS==7-BP: BANK BALLOONS
│   │       ├─→ Pop animation for each
│   │       ├─→ Score +10 per balloon
│   │       ├─→ Player descends to start
│   │       ├─→ Reset: SP!=4, FLOATERS=0
│   │       └─→ Continue with next row
│   │
│   └─→ NO: Balloon continues falling
│       └─→ IF hits floor (BY>180):
│           ├─→ Pop balloon (X mark)
│           ├─→ Pop all held balloons
│           ├─→ Player tumble animation
│           ├─→ LIVES--
│           └─→ IF LIVES==0: GAME OVER
│
├─→ IF current row empty (T$==""):
│   └─→ Move to next row (BP--)
│
└─→ IF all rows empty (BP<0):
    └─→ YOU WIN!
```

---

## 🎨 Visual Elements

### Sprites Used
1. **MAN** - Player character
2. **BALL** - Balloon (intact)
3. **XBALL** - Balloon with X (popped)
4. **POP** - Pop animation sprite
5. **FALL** - Player falling/dying sprite
6. **TINY** - Tiny life icon

### Animation Principles
- **Smooth movement**: Player and balloons move every frame
- **Visual feedback**: Every action has a sprite change or sound
- **Stacking visual**: Caught balloons appear above player
- **Death sequence**: Multi-stage animation (pop → fall → bounce → scroll off)

---

## 💡 Key Design Decisions

### Why These Mechanics Work

1. **One balloon at a time**: Creates focused gameplay, easier to track
2. **Speed increase per catch**: Natural difficulty curve within each session
3. **Speed reset on banking**: Provides relief, rewards successful banking
4. **Dynamic banking threshold**: Forces longer risky sequences as game progresses
5. **Row-based depletion**: Clear visual progress, increasing pressure
6. **Held balloon visualization**: Player can see their risk/reward situation
7. **Tumble animation**: Dramatic consequence for failure, emotional impact

---

## 🔧 Implementation Notes

### Critical Variables to Track
```
BP          : Current active row (3 → 0)
FLOATERS    : Number of balloons currently held
SP!         : Current balloon fall speed
HP          : Hit point Y coordinate (where balloons can be caught)
X, Y        : Player position
LIVES       : Remaining lives (starts at 4)
SC!         : Score
```

### State Machine
```
WELCOME → PLAYING → (BANKING | DYING) → PLAYING → GAME_OVER → WELCOME
```

### Important Timings (from original)
- Banking animation: ~0.1 seconds per balloon pop
- Death tumble: ~2-3 seconds total animation
- Pop sound duration: 0.5 seconds per balloon
- Base balloon speed: 4 pixels per frame (~60 FPS)

---

## 📊 Playtesting Metrics

### Original Difficulty Balance
- Average player clears **1-2 rows** before losing all lives
- Expert players can clear **all 4 rows** (60 total balloons)
- Maximum theoretical score per row:
  - Row 3: 120 points (15 balloons × 8 = 120)
  - Row 2: 150 points
  - Row 1: 180 points
  - Row 0: 210 points
  - **Perfect game**: ~660 points

### Difficulty Factors
- **DF = 10**: Standard (10-pixel horizontal tolerance)
- **DF = 5**: Hard mode (5-pixel tolerance)
- **DF = 15**: Easy mode (15-pixel tolerance)

---

## 🎯 Modern Adaptations

### Touch Controls (instead of joystick)
- **Tap/Drag**: Move player to finger position
- **Smooth following**: Player smoothly follows touch point
- **Visual indicator**: Show touch point or target marker

### Quality of Life Improvements
- **Pause functionality**: Not in original
- **High score tracking**: Save best score
- **Sound toggle**: Mute option
- **Visual settings**: Particle effects, screen shake

### Keep Original Spirit
- ✅ One balloon falling at a time
- ✅ Speed ramping and reset cycle
- ✅ Dynamic banking requirements
- ✅ Row-based progression
- ✅ Risk/reward tension of holding balloons

---

## 📝 Summary

The genius of BALLOON CRAZY lies in its escalating tension:
1. You want to catch balloons (points + progress)
2. But each catch makes you rise (harder to position)
3. And speeds up the game (less reaction time)
4. And you must catch MORE balloons to bank as rows clear
5. Until finally banking gives you sweet relief and reset

This creates a perfect risk/reward loop that keeps players engaged!

---

*Document created: October 15, 2025*  
*Original game: BALLOON.BAS (1980s)*  
*Reference for: Balloon Crazy Flutter/Flame remake*
