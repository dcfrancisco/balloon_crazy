import 'package:balloon_crazy/widgets/score_card.dart';
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

class _GameAppState extends State<GameApp> {
  late final BalloonCrazy game;

  @override
  void initState() {
    super.initState();
    game = BalloonCrazy();
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
                              return GameWidget(
                                game: game,
                                overlayBuilderMap: {
                                  PlayState.welcome.name: (context, game) =>
                                      SizedBox.expand(
                                        child: WelcomeLeaderboard(
                                          game: game as BalloonCrazy,
                                        ),
                                      ),
                                  PlayState.gameOver.name: (context, game) =>
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: () =>
                                            (game as BalloonCrazy).startGame(),
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
                                },
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
