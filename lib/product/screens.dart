import '../app/brand.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/theme.dart';
import 'zenvura_store.dart';

class ZenvuraHome extends StatefulWidget {
  const ZenvuraHome({super.key});

  @override
  State<ZenvuraHome> createState() => _ZenvuraHomeState();
}

class _ZenvuraHomeState extends State<ZenvuraHome> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const BreathingSphereScreen(),
    const TechniquesScreen(),
    const HistoryScreen(),
    const StreaksScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ZenvuraStore>().loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(
        title: Text('Zenvura', style: AppTheme.display(cInk)),
        backgroundColor: cSurface,
        iconTheme: const IconThemeData(color: cInk),
      ),
      drawer: Drawer(
        backgroundColor: cSurface,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: cAccent),
              child: Text('Zenvura Menu', style: AppTheme.display(Colors.white)),
            ),
            ListTile(
              title: Text('Breathing Sphere', style: AppTheme.text(cInk)),
              onTap: () { setState(() { _currentIndex = 0; }); Navigator.pop(context); },
            ),
            ListTile(
              title: Text('Techniques', style: AppTheme.text(cInk)),
              onTap: () { setState(() { _currentIndex = 1; }); Navigator.pop(context); },
            ),
            ListTile(
              title: Text('Session History', style: AppTheme.text(cInk)),
              onTap: () { setState(() { _currentIndex = 2; }); Navigator.pop(context); },
            ),
            ListTile(
              title: Text('Streaks', style: AppTheme.text(cInk)),
              onTap: () { setState(() { _currentIndex = 3; }); Navigator.pop(context); },
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
    );
  }
}

class BreathingSphereScreen extends StatelessWidget {
  const BreathingSphereScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cAccent.withValues(alpha: 0.5),
            ),
            child: Center(
              child: Text('Inhale', style: AppTheme.display(cInk)),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: cAccent),
            onPressed: () {
              context.read<ZenvuraStore>().addSession('Box Breathing');
            },
            child: const Text('Complete Session'),
          ),
        ],
      ),
    );
  }
}

class TechniquesScreen extends StatelessWidget {
  const TechniquesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final techniques = ['Box Breathing', '4-7-8', 'Pranayama'];
    return ListView.builder(
      itemCount: techniques.length,
      itemBuilder: (context, index) {
        return Card(
          color: cSurface,
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(techniques[index], style: AppTheme.text(cInk)),
            trailing: const Icon(Icons.play_circle_fill, color: cAccent),
          ),
        );
      },
    );
  }
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ZenvuraStore>();
    return ListView.builder(
      itemCount: store.sessions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(store.sessions[index], style: AppTheme.text(cInk)),
          leading: const Icon(Icons.history, color: cAccent2),
        );
      },
    );
  }
}

class StreaksScreen extends StatelessWidget {
  const StreaksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<ZenvuraStore>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_fire_department, size: 64, color: cAccent),
          const SizedBox(height: 16),
          Text('${store.streak} Day Streak!', style: AppTheme.display(cInk)),
        ],
      ),
    );
  }
}
