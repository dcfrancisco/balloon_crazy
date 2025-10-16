import 'package:flutter_test/flutter_test.dart';
import 'package:balloon_crazy/services/leaderboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('addScore sorts and trims to maxEntries', () async {
    SharedPreferences.setMockInitialValues({});
    final service = LeaderboardService(maxEntries: 3);

    await service.saveTop([]);

    final entries = [
      LeaderboardEntry(name: 'A', score: 50, date: '1'),
      LeaderboardEntry(name: 'B', score: 70, date: '2'),
      LeaderboardEntry(name: 'C', score: 60, date: '3'),
    ];
    await service.saveTop(entries);

    // Adding a new high score
    final added = await service.addScore(
      LeaderboardEntry(name: 'D', score: 80, date: '4'),
    );
    expect(added, isTrue);

    final top = await service.loadTop();
    expect(top.length, 3);
    expect(top.first.name, 'D');
  });

  test('saving as NONAME works', () async {
    SharedPreferences.setMockInitialValues({});
    final service = LeaderboardService(maxEntries: 5);

    final entry = LeaderboardEntry(name: 'NONAME', score: 42, date: 'd');
    final added = await service.addScore(entry);
    expect(added, isTrue);

    final top = await service.loadTop();
    expect(top.any((e) => e.name == 'NONAME' && e.score == 42), isTrue);
  });
}
