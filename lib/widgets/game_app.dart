import 'package:balloon_crazy/widgets/score_card.dart';
import 'package:balloon_crazy/widgets/paused_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:balloon_crazy/widgets/overlay_screen.dart';
import 'package:balloon_crazy/widgets/game_title.dart';
import 'package:balloon_crazy/balloon_crazy.dart';
import 'package:balloon_crazy/ui/welcome_leaderboard.dart';
import 'package:balloon_crazy/ui/won_prompt.dart';
import 'package:balloon_crazy/config.dart';

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> with WidgetsBindingObserver {
  late final BalloonCrazy game;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    game = BalloonCrazy();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      game.pauseGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.pressStart2pTextTheme().apply(
          bodyColor: const Color(0xff184e77),
          displayColor: const Color(0xff184e77),
        ),
      ),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff5555fa), Color.fromARGB(255, 139, 139, 251)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 5.0),
                          child: GameTitle(),
                        ),
                        ScoreCard(score: game.score, lives: game.lives),
                      ],
                    ),
                    Expanded(
                      child: FittedBox(
                        child: SizedBox(
                          width: gameWidth,
                          height: gameHeight,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Provide the actual rendered size back to the game
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                game.widgetRenderWidth = constraints.maxWidth;
                                game.widgetRenderHeight = constraints.maxHeight;
                              });
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  GameWidget(
                                    game: game,
                                    overlayBuilderMap: {
                                      PlayState.welcome.name: (context, game) =>
                                          SizedBox.expand(
                                            child: WelcomeLeaderboard(
                                              game: game as BalloonCrazy,
                                            ),
                                          ),
                                      PlayState.gameOver.name:
                                          (context, game) => GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () => (game as BalloonCrazy)
                                                .startGame(),
                                            child: const SizedBox.expand(
                                              child: OverlayScreen(
                                                title: 'G A M E   O V E R',
                                                subtitle: 'Tap to Play Again',
                                              ),
                                            ),
                                          ),
                                      PlayState.won.name: (context, game) =>
                                          SizedBox.expand(
                                            child: WonPrompt(
                                              game: game as BalloonCrazy,
                                            ),
                                          ),
                                      'paused': (context, game) =>
                                          SizedBox.expand(
                                            child: PausedOverlay(
                                              game: game as BalloonCrazy,
                                            ),
                                          ),
                                    },
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: IconButton(
                                      tooltip: 'Pause game',
                                      onPressed: game.pauseGame,
                                      icon: const Icon(Icons.pause_rounded),
                                      color: Colors.white,
                                    ),
                                  ),
                                  Positioned(
                                    top: 16,
                                    left: 16,
                                    child: ValueListenableBuilder<int>(
                                      valueListenable: game.heldBalloons,
                                      builder: (context, held, _) => held == 0
                                          ? const SizedBox.shrink()
                                          : DecoratedBox(
                                              decoration: BoxDecoration(
                                                color: Colors.black45,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 6,
                                                    ),
                                                child: Text(
                                                  'STACK: $held',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 58,
                                    left: 0,
                                    right: 0,
                                    child: ValueListenableBuilder<String?>(
                                      valueListenable: game.feedback,
                                      builder: (context, message, _) =>
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 180,
                                            ),
                                            child: message == null
                                                ? const SizedBox.shrink()
                                                : Center(
                                                    child: Text(
                                                      message,
                                                      key: ValueKey(message),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
