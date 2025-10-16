import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardEntry {
  final String name;
  final int score;
  final String date;

  LeaderboardEntry({
    required this.name,
    required this.score,
    required this.date,
  });

  Map<String, dynamic> toJson() => {'name': name, 'score': score, 'date': date};
  static LeaderboardEntry fromJson(Map<String, dynamic> j) =>
      LeaderboardEntry(name: j['name'], score: j['score'], date: j['date']);
}

class LeaderboardService {
  static const _keyTop = 'leaderboard.top';
  static const _keyName = 'player.currentName';
  final int maxEntries;

  LeaderboardService({this.maxEntries = 10});

  Future<List<LeaderboardEntry>> loadTop() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyTop);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => LeaderboardEntry.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTop(List<LeaderboardEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_keyTop, json);
  }

  Future<String?> getCurrentName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  Future<void> setCurrentName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
  }

  Future<bool> addScore(LeaderboardEntry entry) async {
    final list = await loadTop();
    list.add(entry);
    list.sort((a, b) => b.score.compareTo(a.score));
    final wasAdded = list.indexOf(entry) < maxEntries;
    final trimmed = list.take(maxEntries).toList();
    await saveTop(trimmed);
    return wasAdded;
  }
}
