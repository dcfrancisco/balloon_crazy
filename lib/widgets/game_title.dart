import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameTitle extends StatelessWidget {
  /// Create a GameTitle.
  ///
  /// [balloonFontSize] controls the size of the "Balloon" word. [crazyFontSize]
  /// controls the size of the colored "CRAZY!" letters.
  const GameTitle({
    super.key,
    this.balloonFontSize = 15,
    this.crazyFontSize = 20,
  });

  final double balloonFontSize;
  final double crazyFontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Balloon ',
          style: GoogleFonts.pressStart2p(
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: balloonFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...'CRAZY!'.split('').map((letter) {
          final color = _getColorForLetter(letter);
          return Text(
            letter,
            style: GoogleFonts.pressStart2p(
              textStyle: TextStyle(
                color: color,
                fontSize: crazyFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }),
      ],
    );
  }

  Color _getColorForLetter(String letter) {
    switch (letter) {
      case 'C':
        return Colors.red;
      case 'R':
        return Colors.orange;
      case 'A':
        return Colors.yellow;
      case 'Z':
        return Colors.green;
      case 'Y':
        return Colors.blue;
      case '!':
        return Colors.purple;
      default:
        return Colors.white;
    }
  }
}
