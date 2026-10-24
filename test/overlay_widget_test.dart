import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_crazy/widgets/game_app.dart';

void main() {
  testWidgets('welcome overlay shows and starts game on tap', (tester) async {
    await tester.pumpWidget(const GameApp());

    await tester.pumpAndSettle();

    expect(find.text('TAP TO PLAY'), findsOneWidget);

    await tester.tap(find.text('TAP TO PLAY'));
    await tester.pumpAndSettle();

    expect(find.text('TAP TO PLAY'), findsNothing);
  });
}
