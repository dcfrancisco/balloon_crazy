# Balloon Crazy

**Balloon Crazy** is a whimsical and challenging game where players ride a skateboard to catch falling balloons on top of their head. Originally designed for Atari computers, this engaging game is now available for multiple platforms including Apple II, Commodore 64, IBM PC/PCjr, and TI-99/4A. This version is a modern adaptation built using Flutter.


[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20me%20a%20coffee-%F0%9F%8C%B5-yellow)](https://www.buymeacoffee.com/dcfrancisco)

If you enjoy this project, consider supporting development (coffee, hosting, tools). Your support helps cover time spent improving the game and keeping this project maintained. Thanks! �


![Balloon Crazy](assets/BalloonCrazy.png)

## Recovery status

🚧 **This project is a pre-alpha prototype under a documentation-led recovery.** 🚧

The approved scope, gameplay contract, architecture decisions, asset plan, and release gates are indexed in [`docs/README.md`](docs/README.md). The current runtime does not yet implement that contract; implementation intentionally follows the documented gates rather than adding features.

## Game Mechanics

### Objective
The main objective is to catch falling balloons by positioning the player character underneath them. You must balance on a skateboard and collect a specific number of balloons to score points and advance to the next level.

### Gameplay
1. **Movement**:
   - Drag horizontally to position the skater beneath the falling balloon.

2. **Catching Balloons**:
   - One red balloon falls at a time from the active row.
   - Position the player directly beneath it. Each catch adds to the visible stack, raises the catch point, and makes the next drop faster.

3. **Banking and scoring**:
   - Caught balloons are unbanked and do not score immediately.
   - Banking triggers automatically at tier thresholds of 4, 5, 6, and 7 balloons.
   - Each banked balloon awards 10 points. A miss loses the entire unbanked stack.

4. **Board progression**:
   - Clear four rows of fifteen balloons, beginning with the lowest row and moving upward.
   - The first release contains one finite board, not multiple levels.

5. **Lives and endings**:
   - You start with four lives. A miss costs one life and clears the unbanked stack.
   - Clear all 60 balloons to win; lose all four lives for game over. Both outcomes can enter the local leaderboard.

## Installation

To run this Flutter project, follow these steps:

1. **Clone the repository**:
   ```sh
   git clone git@github.com:dcfrancisco/balloon_crazy.git
   cd balloon_crazy
   ```


2. **Install dependencies**:

   ```sh
   flutter pub get
   ```

3. **Run the app**:

   ```sh
   flutter run
   ```

## Source Code

The original source code for Balloon Crazy, as typed in from page 59 of the December 1985 issue of COMPUTE! magazine, is included in this repository. You can find the `BALLOON.BAS` file in the `assets` folder.

- [BALLOON.BAS](assets/BALLOON.BAS) version by Charles Brannon

## Source
The original source code and detailed game description are from the December 1985 issue of COMPUTE! magazine. Here's the citation:

- Joseph Russ, "Balloon Crazy," [COMPUTE! Magazine, Issue 67, December 1985](https://archive.org/embed/1985-12-compute-magazine). Available online at [AtariMagazines.com](https://www.atarimagazines.com/compute/issue67/305_1_BALLOON_CRAZY.php).

Enjoy the delightful and challenging world of Balloon Crazy! Catch those balloons, score high, and become the ultimate Balloon Crazy champion!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Fonts / Attributions

The prototype references the following fonts. The README previously claimed that full license files were included, but those files are not currently tracked. This is a release blocker recorded in [`docs/asset-plan.md`](docs/asset-plan.md); do not distribute the fonts until their exact source and license are verified and added.

- DigitalReadout — font binaries are currently present; provenance/license verification is pending.

- Press Start 2P — currently requested through `google_fonts`; the recovery plan requires a verified, bundled production font.

Final in-app attribution will be generated from the verified asset provenance ledger before public release.
