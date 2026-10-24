import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_crazy/widgets/game_app.dart';

void main() {
  testWidgets('game app shows the welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const GameApp());
    await tester.pump();

    expect(find.text('TAP TO PLAY'), findsOneWidget);
  });
}
