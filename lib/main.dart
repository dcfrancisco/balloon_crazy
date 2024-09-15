import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:balloon_crazy/balloon_crazy.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    final game = BalloonCrazy();
    runApp(GameWidget(game: game));
  });
}
