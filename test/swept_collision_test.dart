import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_crazy/domain/swept_collision.dart';

void main() {
  test('detects a catch when a frame crosses the player', () {
    expect(
      sweptVerticalCatch(
        previousY: 900,
        nextY: 1400,
        objectHeight: 55,
        objectX: 400,
        objectWidth: 55,
        targetY: 1300,
        targetHeight: 100,
        targetX: 420,
        targetWidth: 80,
      ),
      isTrue,
    );
  });

  test('rejects a crossing outside the player horizontal bounds', () {
    expect(
      sweptVerticalCatch(
        previousY: 900,
        nextY: 1400,
        objectHeight: 55,
        objectX: 100,
        objectWidth: 55,
        targetY: 1300,
        targetHeight: 100,
        targetX: 420,
        targetWidth: 80,
      ),
      isFalse,
    );
  });
}
