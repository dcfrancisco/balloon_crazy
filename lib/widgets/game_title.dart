import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameTitle extends StatelessWidget {
  const GameTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Balloon ',
          style: GoogleFonts.pressStart2p(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
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
