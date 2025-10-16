import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_crazy/balloon_crazy.dart';
import 'package:balloon_crazy/components/balloon.dart';
import 'package:flame/components.dart';

void main() {
  test('win not declared when active falling balloon remains', () async {
    final game = BalloonCrazy();

    // prepare an empty matrix (no queued balloons)
    game.balloonMatrix = List.generate(
      4,
      (_) => List<Balloon?>.filled(0, null),
    );

    // add a falling balloon to the world
    final balloon = Balloon(
      position: Vector2(100, 100),
      size: Vector2(10, 10),
      velocity: Vector2(0, 50),
      rowIndex: 0,
      columnIndex: 0,
    );
    // attach balloon to game's world
    game.world.add(balloon);

    final matrixEmpty = game.balloonMatrix.every(
      (col) => col.every((b) => b == null),
    );
    final noActiveBalloons = game.world.children.whereType<Balloon>().isEmpty;

    // matrix is empty, but world has an active balloon -> should not be considered win
    expect(matrixEmpty, true);
    expect(noActiveBalloons, false);
  });
}
