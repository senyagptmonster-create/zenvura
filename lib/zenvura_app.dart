import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/pulse_theme.dart';
import 'modules/breathing_sphere/breathing_flow_controller.dart';
import 'modules/breathing_sphere/breathing_sphere_view.dart';
import 'modules/techniques/techniques_library_view.dart';
import 'modules/history/session_history_view.dart';
import 'modules/streaks/mindfulness_streaks_view.dart';

class ZenvuraApp extends StatelessWidget {
  const ZenvuraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BreathingFlowController()..initialize(),
      child: MaterialApp(
        title: 'Zenvura Breath Companion',
        debugShowCheckedModeBanner: false,
        theme: PulseTheme.darkTheme,
        home: const ZenvuraNavigationScaffold(),
      ),
    );
  }
}

class ZenvuraNavigationScaffold extends StatefulWidget {
  const ZenvuraNavigationScaffold({super.key});

  @override
  State<ZenvuraNavigationScaffold> createState() =>
      _ZenvuraNavigationScaffoldState();
}

class _ZenvuraNavigationScaffoldState extends State<ZenvuraNavigationScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const BreathingSphereView(),
      TechniquesLibraryView(
        onSelectAndNavigate: () {
          setState(() => _currentIndex = 0);
        },
      ),
      const SessionHistoryView(),
      const MindfulnessStreaksView(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.air_rounded),
            activeIcon: Icon(Icons.air_rounded),
            label: 'Sphere',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement_outlined),
            activeIcon: Icon(Icons.self_improvement_rounded),
            label: 'Techniques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_rounded),
            activeIcon: Icon(Icons.history_rounded),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            activeIcon: Icon(Icons.emoji_events_rounded),
            label: 'Streaks',
          ),
        ],
      ),
    );
  }
}
