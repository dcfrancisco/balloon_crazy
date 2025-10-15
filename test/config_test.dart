import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_crazy/config.dart';

void main() {
  test('game size constants', () {
    expect(gameWidth, 820.0);
    expect(gameHeight, 1600.0);
    expect(gridColumns, greaterThanOrEqualTo(1));
    expect(gridRows, greaterThanOrEqualTo(1));
  });
}
