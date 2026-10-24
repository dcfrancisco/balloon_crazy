import 'dart:math' as math;

/// Maps touch coordinates from a possibly letterboxed widget into the fixed
/// 820x1600 game world.
class GameCoordinateMapper {
  const GameCoordinateMapper({
    required this.worldWidth,
    required this.worldHeight,
  });

  final double worldWidth;
  final double worldHeight;

  ({double x, double y}) worldPoint({
    required double widgetX,
    required double widgetY,
    required double renderWidth,
    required double renderHeight,
  }) {
    if (renderWidth <= 0 || renderHeight <= 0) {
      return (
        x: widgetX.clamp(0, worldWidth),
        y: widgetY.clamp(0, worldHeight),
      );
    }
    final scale = math.min(
      renderWidth / worldWidth,
      renderHeight / worldHeight,
    );
    final viewportWidth = worldWidth * scale;
    final viewportHeight = worldHeight * scale;
    final offsetX = (renderWidth - viewportWidth) / 2;
    final offsetY = (renderHeight - viewportHeight) / 2;
    return (
      x: ((widgetX - offsetX) / scale).clamp(0, worldWidth),
      y: ((widgetY - offsetY) / scale).clamp(0, worldHeight),
    );
  }
}
