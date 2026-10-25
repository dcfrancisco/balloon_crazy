import 'package:flutter/material.dart';

import 'package:balloon_crazy/features/adventure/presentation/level_one_screen.dart';

class BalloonCrazyV2App extends StatelessWidget {
  const BalloonCrazyV2App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balloon Crazy V2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff168aad),
          brightness: Brightness.light,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(180, 52),
            textStyle: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ),
      home: const V2LevelOneScreen(),
    );
  }
}
