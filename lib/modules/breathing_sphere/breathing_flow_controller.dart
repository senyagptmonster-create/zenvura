import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum BreathPhase {
  idle,
  inhale,
  holdInhale,
  exhale,
  holdExhale,
  completed,
}

extension BreathPhaseExtension on BreathPhase {
  String get label {
    switch (this) {
      case BreathPhase.idle:
        return 'Ready to Begin';
      case BreathPhase.inhale:
        return 'Breathe In';
      case BreathPhase.holdInhale:
        return 'Hold Breath';
      case BreathPhase.exhale:
        return 'Breathe Out';
      case BreathPhase.holdExhale:
        return 'Rest & Pause';
      case BreathPhase.completed:
        return 'Session Complete';
    }
  }

  String get guidance {
    switch (this) {
      case BreathPhase.idle:
        return 'Find a comfortable position and prepare your mind.';
      case BreathPhase.inhale:
        return 'Draw deep, soothing air through your nose.';
      case BreathPhase.holdInhale:
        return 'Maintain stillness with gentle lungs.';
      case BreathPhase.exhale:
        return 'Release tension slowly through your mouth.';
      case BreathPhase.holdExhale:
        return 'Rest comfortably in complete calm.';
      case BreathPhase.completed:
        return 'Well done. Carry this peaceful clarity forward.';
    }
  }
}

class BreathTechnique {
  final String id;
  final String name;
  final String category;
  final String description;
  final int inhaleSeconds;
  final int holdInhaleSeconds;
  final int exhaleSeconds;
  final int holdExhaleSeconds;
  final int defaultCycles;
  final String benefit;

  const BreathTechnique({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.inhaleSeconds,
    required this.holdInhaleSeconds,
    required this.exhaleSeconds,
    required this.holdExhaleSeconds,
    required this.defaultCycles,
    required this.benefit,
  });

  int get cycleDuration =>
      inhaleSeconds + holdInhaleSeconds + exhaleSeconds + holdExhaleSeconds;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'inhaleSeconds': inhaleSeconds,
        'holdInhaleSeconds': holdInhaleSeconds,
        'exhaleSeconds': exhaleSeconds,
        'holdExhaleSeconds': holdExhaleSeconds,
        'defaultCycles': defaultCycles,
        'benefit': benefit,
      };

  factory BreathTechnique.fromJson(Map<String, dynamic> json) => BreathTechnique(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        description: json['description'] as String,
        inhaleSeconds: json['inhaleSeconds'] as int,
        holdInhaleSeconds: json['holdInhaleSeconds'] as int,
        exhaleSeconds: json['exhaleSeconds'] as int,
        holdExhaleSeconds: json['holdExhaleSeconds'] as int,
        defaultCycles: json['defaultCycles'] as int? ?? 4,
        benefit: json['benefit'] as String? ?? 'Promotes mental serenity.',
      );
}

class BreathSession {
  final String id;
  final String techniqueName;
  final DateTime timestamp;
  final int durationSeconds;
  final int completedCycles;

  const BreathSession({
    required this.id,
    required this.techniqueName,
    required this.timestamp,
    required this.durationSeconds,
    required this.completedCycles,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'techniqueName': techniqueName,
        'timestamp': timestamp.toIso8601String(),
        'durationSeconds': durationSeconds,
        'completedCycles': completedCycles,
      };

  factory BreathSession.fromJson(Map<String, dynamic> json) => BreathSession(
        id: json['id'] as String,
        techniqueName: json['techniqueName'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        durationSeconds: json['durationSeconds'] as int,
        completedCycles: json['completedCycles'] as int,
      );
}

class BreathingFlowController extends ChangeNotifier {
  static const String _prefSessionsKey = 'zenvura_sessions_log';
  static const String _prefCustomTechKey = 'zenvura_custom_techniques';
  static const String _prefVibrationKey = 'zenvura_vibration_enabled';

  final List<BreathTechnique> _defaultTechniques = const [
    BreathTechnique(
      id: 'box_4_4_4_4',
      name: 'Box Breathing',
      category: 'Focus & Balance',
      description: 'Equal quad-phase rhythm used by elite performers to restore autonomic equilibrium.',
      inhaleSeconds: 4,
      holdInhaleSeconds: 4,
      exhaleSeconds: 4,
      holdExhaleSeconds: 4,
      defaultCycles: 5,
      benefit: 'Reduces cortisol levels and sharpens acute concentration.',
    ),
    BreathTechnique(
      id: 'sleep_4_7_8',
      name: '4-7-8 Deep Sleep',
      category: 'Rest & Unwind',
      description: 'Dr. Andrew Weil’s parasympathetic sedative rhythm to transition smoothly into sleep.',
      inhaleSeconds: 4,
      holdInhaleSeconds: 7,
      exhaleSeconds: 8,
      holdExhaleSeconds: 0,
      defaultCycles: 4,
      benefit: 'Slows cardiac pacing and encourages rapid nocturnal relaxation.',
    ),
    BreathTechnique(
      id: 'pranayama_2_1_4',
      name: 'Pranayama 2-1-4',
      category: 'Harmonic Energy',
      description: 'Ancient yogic ratio expanding vital prana and releasing mental stagnancy.',
      inhaleSeconds: 4,
      holdInhaleSeconds: 2,
      exhaleSeconds: 8,
      holdExhaleSeconds: 0,
      defaultCycles: 6,
      benefit: 'Improves oxygen circulation and settles mental turbulence.',
    ),
    BreathTechnique(
      id: 'awake_vitality',
      name: 'Awake Vitality',
      category: 'Morning Energy',
      description: 'Quick-rise invigorating pattern to dispel lethargy and oxygenate muscles.',
      inhaleSeconds: 6,
      holdInhaleSeconds: 0,
      exhaleSeconds: 2,
      holdExhaleSeconds: 1,
      defaultCycles: 6,
      benefit: 'Stimulates neural alertness without reliance on stimulants.',
    ),
    BreathTechnique(
      id: 'deep_calm',
      name: 'Deep Calm',
      category: 'Stress Release',
      description: 'Prolonged sigh exhalation protocol targeting the vagus nerve.',
      inhaleSeconds: 5,
      holdInhaleSeconds: 2,
      exhaleSeconds: 7,
      holdExhaleSeconds: 2,
      defaultCycles: 5,
      benefit: 'Deactivates sympathetic fight-or-flight within 3 cycles.',
    ),
  ];

  List<BreathTechnique> _techniques = [];
  List<BreathSession> _sessions = [];
  late BreathTechnique _selectedTechnique;

  bool _isInitialized = false;
  bool _vibrationEnabled = true;

  // Active Session State
  Timer? _timer;
  BreathPhase _currentPhase = BreathPhase.idle;
  int _secondsInPhase = 0;
  int _currentCycle = 1;
  int _targetCycles = 5;
  int _totalElapsedSeconds = 0;
  bool _isActive = false;
  bool _isPaused = false;

  BreathingFlowController() {
    _techniques = List.from(_defaultTechniques);
    _selectedTechnique = _techniques.first;
    _targetCycles = _selectedTechnique.defaultCycles;
  }

  bool get isInitialized => _isInitialized;
  List<BreathTechnique> get techniques => _techniques;
  List<BreathSession> get sessions => _sessions;
  BreathTechnique get selectedTechnique => _selectedTechnique;
  bool get vibrationEnabled => _vibrationEnabled;

  BreathPhase get currentPhase => _currentPhase;
  int get secondsInPhase => _secondsInPhase;
  int get currentCycle => _currentCycle;
  int get targetCycles => _targetCycles;
  int get totalElapsedSeconds => _totalElapsedSeconds;
  bool get isActive => _isActive;
  bool get isPaused => _isPaused;

  int get currentPhaseDuration {
    switch (_currentPhase) {
      case BreathPhase.inhale:
        return _selectedTechnique.inhaleSeconds;
      case BreathPhase.holdInhale:
        return _selectedTechnique.holdInhaleSeconds;
      case BreathPhase.exhale:
        return _selectedTechnique.exhaleSeconds;
      case BreathPhase.holdExhale:
        return _selectedTechnique.holdExhaleSeconds;
      case BreathPhase.idle:
      case BreathPhase.completed:
        return 0;
    }
  }

  double get phaseProgress {
    final total = currentPhaseDuration;
    if (total == 0) return 0.0;
    return (_secondsInPhase / total).clamp(0.0, 1.0);
  }

  int get totalMindfulMinutes {
    final totalSec = _sessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);
    return (totalSec / 60).round();
  }

  int get streakDays {
    if (_sessions.isEmpty) return 0;
    final dates = _sessions
        .map((s) => DateTime(s.timestamp.year, s.timestamp.month, s.timestamp.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final yesterdayNormalized = todayNormalized.subtract(const Duration(days: 1));

    if (!dates.contains(todayNormalized) && !dates.contains(yesterdayNormalized)) {
      return 0;
    }

    int streak = 0;
    DateTime checkDate = dates.contains(todayNormalized) ? todayNormalized : yesterdayNormalized;

    while (dates.contains(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }
    return streak;
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    final prefs = await SharedPreferences.getInstance();

    final sessionsJson = prefs.getStringList(_prefSessionsKey);
    if (sessionsJson != null) {
      _sessions = sessionsJson
          .map((s) {
            try {
              return BreathSession.fromJson(jsonDecode(s) as Map<String, dynamic>);
            } catch (_) {
              return null;
            }
          })
          .whereType<BreathSession>()
          .toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }

    final customTechJson = prefs.getStringList(_prefCustomTechKey);
    if (customTechJson != null) {
      for (final tStr in customTechJson) {
        try {
          final t = BreathTechnique.fromJson(jsonDecode(tStr) as Map<String, dynamic>);
          if (!_techniques.any((existing) => existing.id == t.id)) {
            _techniques.add(t);
          }
        } catch (_) {}
      }
    }

    _vibrationEnabled = prefs.getBool(_prefVibrationKey) ?? true;
    _isInitialized = true;
    notifyListeners();
  }

  void selectTechnique(BreathTechnique tech) {
    if (_isActive) {
      stopSession();
    }
    _selectedTechnique = tech;
    _targetCycles = tech.defaultCycles;
    notifyListeners();
  }

  void setTargetCycles(int cycles) {
    if (!_isActive && cycles >= 1 && cycles <= 20) {
      _targetCycles = cycles;
      notifyListeners();
    }
  }

  void toggleVibration() async {
    _vibrationEnabled = !_vibrationEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefVibrationKey, _vibrationEnabled);
    notifyListeners();
  }

  void startSession() {
    _isActive = true;
    _isPaused = false;
    _currentCycle = 1;
    _totalElapsedSeconds = 0;
    _startPhase(BreathPhase.inhale);
    _runTicker();
    notifyListeners();
  }

  void pauseSession() {
    _isPaused = true;
    _timer?.cancel();
    notifyListeners();
  }

  void resumeSession() {
    if (_isActive && _isPaused) {
      _isPaused = false;
      _runTicker();
      notifyListeners();
    }
  }

  void stopSession() {
    _timer?.cancel();
    _timer = null;
    _isActive = false;
    _isPaused = false;
    _currentPhase = BreathPhase.idle;
    _secondsInPhase = 0;
    notifyListeners();
  }

  void _runTicker() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _totalElapsedSeconds++;
      _secondsInPhase++;

      if (_secondsInPhase >= currentPhaseDuration) {
        _advancePhase();
      } else {
        notifyListeners();
      }
    });
  }

  void _advancePhase() {
    _secondsInPhase = 0;
    switch (_currentPhase) {
      case BreathPhase.inhale:
        if (_selectedTechnique.holdInhaleSeconds > 0) {
          _startPhase(BreathPhase.holdInhale);
        } else {
          _startPhase(BreathPhase.exhale);
        }
        break;
      case BreathPhase.holdInhale:
        _startPhase(BreathPhase.exhale);
        break;
      case BreathPhase.exhale:
        if (_selectedTechnique.holdExhaleSeconds > 0) {
          _startPhase(BreathPhase.holdExhale);
        } else {
          _completeOrNextCycle();
        }
        break;
      case BreathPhase.holdExhale:
        _completeOrNextCycle();
        break;
      case BreathPhase.idle:
      case BreathPhase.completed:
        break;
    }
    notifyListeners();
  }

  void _completeOrNextCycle() {
    if (_currentCycle >= _targetCycles) {
      _finishSession();
    } else {
      _currentCycle++;
      _startPhase(BreathPhase.inhale);
    }
  }

  void _startPhase(BreathPhase phase) {
    _currentPhase = phase;
    _secondsInPhase = 0;
  }

  void _finishSession() {
    _timer?.cancel();
    _timer = null;
    _currentPhase = BreathPhase.completed;
    _isActive = false;
    _isPaused = false;

    final session = BreathSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      techniqueName: _selectedTechnique.name,
      timestamp: DateTime.now(),
      durationSeconds: _totalElapsedSeconds,
      completedCycles: _targetCycles,
    );

    _sessions.insert(0, session);
    _saveSessions();
    notifyListeners();
  }

  Future<void> logManualSession(String techniqueName, int durationMinutes) async {
    final session = BreathSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      techniqueName: techniqueName,
      timestamp: DateTime.now(),
      durationSeconds: durationMinutes * 60,
      completedCycles: (durationMinutes * 60 / 16).round().clamp(1, 99),
    );
    _sessions.insert(0, session);
    await _saveSessions();
    notifyListeners();
  }

  Future<void> addCustomTechnique({
    required String name,
    required String category,
    required String description,
    required int inhale,
    required int holdInhale,
    required int exhale,
    required int holdExhale,
    required int cycles,
  }) async {
    final newTech = BreathTechnique(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      category: category,
      description: description,
      inhaleSeconds: inhale,
      holdInhaleSeconds: holdInhale,
      exhaleSeconds: exhale,
      holdExhaleSeconds: holdExhale,
      defaultCycles: cycles,
      benefit: 'Personalized bespoke breath pattern.',
    );
    _techniques.add(newTech);
    _selectedTechnique = newTech;
    _targetCycles = cycles;

    final prefs = await SharedPreferences.getInstance();
    final customTechs = _techniques.where((t) => t.id.startsWith('custom_')).toList();
    await prefs.setStringList(
      _prefCustomTechKey,
      customTechs.map((t) => jsonEncode(t.toJson())).toList(),
    );

    notifyListeners();
  }

  Future<void> deleteSession(String id) async {
    _sessions.removeWhere((s) => s.id == id);
    await _saveSessions();
    notifyListeners();
  }

  Future<void> clearHistory() async {
    _sessions.clear();
    await _saveSessions();
    notifyListeners();
  }

  Future<void> _saveSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _sessions.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList(_prefSessionsKey, encoded);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
