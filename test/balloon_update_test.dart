import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_crazy/components/balloon.dart';
import 'package:flame/components.dart';

void main() {
  test('balloon update moves by velocity*dt', () {
    final balloon = Balloon(
      position: Vector2(10, 20),
      size: Vector2(10, 10),
      velocity: Vector2(0, 50),
      rowIndex: 0,
      columnIndex: 0,
    );

    // call update with dt = 0.5 seconds
    balloon.update(0.5);

    // expected y moved by 50 * 0.5 = 25
    expect(balloon.position.y, closeTo(20 + 25, 0.0001));
  });
}
