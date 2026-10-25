import 'package:flutter/material.dart';

import 'package:balloon_crazy/v2/v2_level_one_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xff168aad),
      ),
      home: const V2LevelOneScreen(),
    ),
  );
}
