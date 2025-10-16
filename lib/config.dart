const gameWidth = 820.0;
const gameHeight = 1600.0;

// Balloons / grid
const gridRows = 4;
const gridColumns = 10;
const balloonWidth = 55.0;
const balloonHeight = 55.0;
const horizontalSpacing = 20.0;
const verticalSpacing = 20.0;
const gridStartMargin =
    20.0; // left/right margin inside gameWidth when centering grid
const gridStartY = 100.0;
// Additional vertical offset to nudge balloons lower on the screen
const gridStartYOffset = 20.0;
const balloonDropSpeed = 100.0; // pixels per second when balloons fall

// Gameplay tuning
const baseSP =
    4.0; // base speed unit from original; used as a multiplier baseline
const hitPointY = 164.0; // reference hit point Y (from original documentation)

// Player / floor
const floorHeight = 200.0;
const playerWidth = 80.0;
const playerHeight = 100.0;
const playerInitialYOffset = 50.0; // how far above the floor the player sits
const playerMoveSpeed = 500.0;

// Visuals / gameplay
const initialLives = 4;
const visualBalloonSize = 30.0;
const visualBalloonYOffset =
    30.0; // vertical spacing between stacked visual balloons

const balloonGutter = gameWidth * 0.015;

// Additional balloon-specific speeds and size aliases
const balloonFallSpeed = balloonDropSpeed; // standard falling speed (px/s)
const balloonInitialDropSpeed = balloonDropSpeed; // alias for spawn speed
const balloonCaughtSpeed =
    0.0; // speed when balloon is caught/attached to player

// Aliases for clarity
const fallingBalloonWidth = balloonWidth;
const fallingBalloonHeight = balloonHeight;
const caughtBalloonSize = visualBalloonSize;
