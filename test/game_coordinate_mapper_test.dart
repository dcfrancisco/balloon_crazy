import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_crazy/input/game_coordinate_mapper.dart';

void main() {
  const mapper = GameCoordinateMapper(worldWidth: 820, worldHeight: 1600);

  test('maps a uniformly scaled viewport without distortion', () {
    final point = mapper.worldPoint(
      widgetX: 410,
      widgetY: 400,
      renderWidth: 820,
      renderHeight: 1600,
    );

    expect(point.x, 410);
    expect(point.y, 400);
  });

  test('accounts for horizontal letterboxing', () {
    final point = mapper.worldPoint(
      widgetX: 500,
      widgetY: 500,
      renderWidth: 1000,
      renderHeight: 1000,
    );

    expect(point.x, closeTo(410, 0.001));
    expect(point.y, closeTo(800, 0.001));
  });

  test('clamps touches outside the game viewport', () {
    final point = mapper.worldPoint(
      widgetX: -100,
      widgetY: 2000,
      renderWidth: 820,
      renderHeight: 1600,
    );

    expect(point.x, 0);
    expect(point.y, 1600);
  });
}
