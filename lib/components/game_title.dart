import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/painting.dart';
import 'package:balloon_crazy/config.dart';

class GameTitle extends PositionComponent {
  static const double balloonFontSize = 30.0;
  static const double crazyFontSize = 40.0;

  GameTitle() {
    // Define the title colors
    final whitePaint = TextPaint(
        style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: balloonFontSize,
            fontWeight: FontWeight.bold));
    final colors = [
      TextPaint(
          style: const TextStyle(
              color: Color(0xFFFF0000),
              fontSize: crazyFontSize,
              fontWeight: FontWeight.bold)), // Red
      TextPaint(
          style: const TextStyle(
              color: Color(0xFFFFA500),
              fontSize: crazyFontSize,
              fontWeight: FontWeight.bold)), // Orange
      TextPaint(
          style: const TextStyle(
              color: Color(0xFFFFFF00),
              fontSize: crazyFontSize,
              fontWeight: FontWeight.bold)), // Yellow
      TextPaint(
          style: const TextStyle(
              color: Color(0xFF00FF00),
              fontSize: crazyFontSize,
              fontWeight: FontWeight.bold)), // Green
      TextPaint(
          style: const TextStyle(
              color: Color.fromARGB(255, 85, 0, 255),
              fontSize: crazyFontSize,
              fontWeight: FontWeight.bold)), // Blue
    ];

    final title = TextComponent(text: 'Balloon ', textRenderer: whitePaint);
    final crazyLetters = 'CRAZY!'.split('');

    double xOffset = title.size.x + 10;
    for (int i = 0; i < crazyLetters.length; i++) {
      final letter = TextComponent(
          text: crazyLetters[i], textRenderer: colors[i % colors.length]);
      letter.position = Vector2(xOffset, 0);
      add(letter);
      xOffset += letter.size.x;
    }

    position = Vector2((gameWidth * .05), 30);
    add(title);
  }
}
