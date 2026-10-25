import 'package:balloon_crazy/app/balloon_crazy_v2_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('V2 app opens on the Level 1 briefing without a game board', (
    tester,
  ) async {
    await tester.pumpWidget(const BalloonCrazyV2App());

    expect(find.text('FIRST LIFT'), findsOneWidget);
    expect(find.text('START LEVEL'), findsOneWidget);
    expect(find.text('CATCH 0/8'), findsNothing);
  });
}
