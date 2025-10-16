import 'package:flutter/material.dart';
import 'package:balloon_crazy/services/leaderboard.dart';
import 'package:balloon_crazy/balloon_crazy.dart';
import 'package:balloon_crazy/ui/name_dialog.dart';

class WonPrompt extends StatefulWidget {
  final BalloonCrazy game;
  const WonPrompt({required this.game, super.key});

  @override
  State<WonPrompt> createState() => _WonPromptState();
}

class _WonPromptState extends State<WonPrompt> {
  final _service = LeaderboardService();
  String? _currentName;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  Future<void> _prepare() async {
    final name = await _service.getCurrentName();
    setState(() => _currentName = name);
  }

  Future<void> _saveScoreAndContinue() async {
    String? name = _currentName;
    bool skipped = false;
    if (name == null || name.trim().isEmpty) {
      while (true) {
        final res = await _askForName();
        if (res == null) {
          // User canceled — continue without saving
          widget.game.startGame();
          return;
        }
        if (res == '::SKIP::') {
          skipped = true;
          break;
        }
        if (res.trim().isNotEmpty) {
          name = res.trim();
          break;
        }
        // empty string submitted — re-prompt
      }
    }

    if (skipped) {
      // Retro default when player explicitly skips entering a name
      final entry = LeaderboardEntry(
        name: 'NONAME',
        score: widget.game.score.value,
        date: DateTime.now().toIso8601String(),
      );
      final wasAddedSkip = await _service.addScore(entry);
      if (wasAddedSkip) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Saved as NONAME')));
        }
      }
      widget.game.startGame();
      return;
    }

    final entry = LeaderboardEntry(
      name: name!,
      score: widget.game.score.value,
      date: DateTime.now().toIso8601String(),
    );
    final wasAdded = await _service.addScore(entry);
    if (wasAdded) {
      await _service.setCurrentName(name);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your score made the leaderboard.')),
        );
      }
    }

    widget.game.startGame();
  }

  Future<String?> _askForName() async {
    return await showNameDialog(context, initial: _currentName);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'YOU WON!',
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Score: ${widget.game.score.value}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saveScoreAndContinue,
              child: const Text('Save Score / Play Again'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => widget.game.startGame(),
              child: const Text('Skip & Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}
