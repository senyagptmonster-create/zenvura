import 'package:flutter/material.dart';
import 'screens/breathing_sanctuary_screen.dart';
import 'theme/zenvura_palette.dart';

class ZenvuraApp extends StatelessWidget {
  const ZenvuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zenvura Breath Sanctuary',
      debugShowCheckedModeBanner: false,
      theme: ZenvuraPalette.themeData,
      home: const BreathingSanctuaryScreen(),
    );
  }
}
