import 'package:flutter/material.dart';
import 'package:balloon_crazy/services/leaderboard.dart';
import 'package:balloon_crazy/balloon_crazy.dart';
import 'package:balloon_crazy/ui/name_dialog.dart';
import 'package:balloon_crazy/widgets/game_title.dart';

class WelcomeLeaderboard extends StatefulWidget {
  final BalloonCrazy game;
  const WelcomeLeaderboard({required this.game, super.key});

  @override
  State<WelcomeLeaderboard> createState() => _WelcomeLeaderboardState();
}

class _WelcomeLeaderboardState extends State<WelcomeLeaderboard>
    with SingleTickerProviderStateMixin {
  final _service = LeaderboardService();
  List<LeaderboardEntry> _entries = [];
  String? _currentName;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _load();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnim = Tween<double>(begin: 0.98, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final entries = await _service.loadTop();
    final name = await _service.getCurrentName();
    if (!mounted) return;
    setState(() {
      _entries = entries;
      _currentName = name;
    });
  }

  TextStyle _nameStyle() => const TextStyle(color: Colors.white, fontSize: 18);
  TextStyle _scoreStyle() => const TextStyle(
    fontFamily: 'DigitalReadout',
    color: Colors.white,
    fontSize: 20,
  );
  TextStyle _rankStyle() => const TextStyle(
    fontFamily: 'DigitalReadout',
    color: Colors.white24,
    fontSize: 18,
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => widget.game.startGame(),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Center(
                child: GameTitle(balloonFontSize: 20, crazyFontSize: 36),
              ),
              const SizedBox(height: 12),
              Text(
                'Player: ${_currentName ?? '---'}',
                style: const TextStyle(color: Colors.white),
              ),
              // Keep the Edit Name button interactive by preventing the
              // GestureDetector from handling taps on it via an InkWell/Absorb
              // trick: the button itself will handle taps first.
              TextButton(
                onPressed: () async {
                  final newName = await showNameDialog(
                    context,
                    initial: _currentName,
                  );
                  if (newName != null && newName.isNotEmpty) {
                    await _service.setCurrentName(newName);
                    if (!mounted) return;
                    setState(() => _currentName = newName);
                  }
                },
                child: const Text('Edit Name'),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 320,
                child: Card(
                  color: Colors.white.withAlpha((0.06 * 255).round()),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            'LEADERBOARD',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        const Divider(color: Colors.white24),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: 10,
                            itemBuilder: (ctx, i) {
                              if (i < _entries.length) {
                                final e = _entries[i];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6.0,
                                    horizontal: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${i + 1}. ${e.name}',
                                        style: _nameStyle(),
                                      ),
                                      Text('${e.score}', style: _scoreStyle()),
                                    ],
                                  ),
                                );
                              }

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                  horizontal: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${i + 1}. ---', style: _rankStyle()),
                                    Text('--', style: _rankStyle()),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),
              Center(
                child: ScaleTransition(
                  scale: _pulseAnim,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () => widget.game.startGame(),
                    child: const Text(
                      'TAP TO PLAY',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
