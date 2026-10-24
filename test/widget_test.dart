import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_crazy/widgets/game_app.dart';

void main() {
  testWidgets('game app shows the welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const GameApp());
    // The game loads fonts, assets, and the presentation board asynchronously.
    // Advance a bounded amount of simulated time so this remains a real
    // welcome-screen assertion without depending on a single frame race.
    for (
      var attempt = 0;
      attempt < 20 && find.text('TAP TO PLAY').evaluate().isEmpty;
      attempt++
    ) {
      await tester.pump(const Duration(milliseconds: 250));
    }

    expect(find.text('TAP TO PLAY'), findsOneWidget);
  });
}
