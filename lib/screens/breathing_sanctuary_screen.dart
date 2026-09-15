import 'dart:async';
import 'package:flutter/material.dart';
import '../models/breath_technique.dart';
import '../painters/mandala_breath_painter.dart';
import '../sheets/mindful_stats_sheet.dart';
import '../sheets/techniques_sheet.dart';
import '../theme/zenvura_palette.dart';

class BreathingSanctuaryScreen extends StatefulWidget {
  const BreathingSanctuaryScreen({super.key});

  @override
  State<BreathingSanctuaryScreen> createState() => _BreathingSanctuaryScreenState();
}

class _BreathingSanctuaryScreenState extends State<BreathingSanctuaryScreen>
    with SingleTickerProviderStateMixin {
  BreathTechnique _technique = BreathTechnique.defaultPresets[0];
  bool _isActive = false;
  String _currentPhase = 'TAP TO BEGIN';
  int _completedCycles = 4;
  int _totalMinutes = 12;

  Timer? _phaseTimer;
  int _phaseSecondsLeft = 0;

  late AnimationController _animCtrl;
  late Animation<double> _expansionAnimation;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: _technique.inhaleSeconds),
    );
    _expansionAnimation = CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOutSine);
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    _animCtrl.dispose();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _isActive = true;
    });
    _runInhalePhase();
  }

  void _pauseBreathing() {
    _phaseTimer?.cancel();
    _animCtrl.stop();
    setState(() {
      _isActive = false;
      _currentPhase = 'PAUSED';
    });
  }

  void _runInhalePhase() {
    if (!_isActive) return;
    setState(() {
      _currentPhase = 'INHALE';
      _phaseSecondsLeft = _technique.inhaleSeconds;
    });
    _animCtrl.duration = Duration(seconds: _technique.inhaleSeconds);
    _animCtrl.forward(from: 0.0);

    _phaseTimer = Timer(Duration(seconds: _technique.inhaleSeconds), () {
      if (_technique.holdSeconds > 0) {
        _runHoldPhase();
      } else {
        _runExhalePhase();
      }
    });
  }

  void _runHoldPhase() {
    if (!_isActive) return;
    setState(() {
      _currentPhase = 'HOLD';
      _phaseSecondsLeft = _technique.holdSeconds;
    });
    _phaseTimer = Timer(Duration(seconds: _technique.holdSeconds), () {
      _runExhalePhase();
    });
  }

  void _runExhalePhase() {
    if (!_isActive) return;
    setState(() {
      _currentPhase = 'EXHALE';
      _phaseSecondsLeft = _technique.exhaleSeconds;
    });
    _animCtrl.duration = Duration(seconds: _technique.exhaleSeconds);
    _animCtrl.reverse(from: 1.0);

    _phaseTimer = Timer(Duration(seconds: _technique.exhaleSeconds), () {
      if (_technique.holdAfterExhaleSeconds > 0) {
        _runHoldAfterExhalePhase();
      } else {
        _cycleComplete();
      }
    });
  }

  void _runHoldAfterExhalePhase() {
    if (!_isActive) return;
    setState(() {
      _currentPhase = 'HOLD EMPTY';
      _phaseSecondsLeft = _technique.holdAfterExhaleSeconds;
    });
    _phaseTimer = Timer(Duration(seconds: _technique.holdAfterExhaleSeconds), () {
      _cycleComplete();
    });
  }

  void _cycleComplete() {
    if (!_isActive) return;
    setState(() {
      _completedCycles++;
      if (_completedCycles % 5 == 0) _totalMinutes++;
    });
    _runInhalePhase();
  }

  void _openTechniquesSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => TechniquesSheet(
        activeTechnique: _technique,
        onSelect: (t) {
          _pauseBreathing();
          setState(() {
            _technique = t;
            _currentPhase = 'READY';
          });
        },
      ),
    );
  }

  void _openStatsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => MindfulStatsSheet(
        completedCycles: _completedCycles,
        totalMinutes: _totalMinutes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_technique.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: 'Mindfulness Log',
            onPressed: _openStatsSheet,
          ),
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Technique Protocols',
            onPressed: _openTechniquesSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),

            // Immersive Pulsing Sacred Geometry Mandala Canvas
            Center(
              child: SizedBox(
                width: 280,
                height: 280,
                child: AnimatedBuilder(
                  animation: _expansionAnimation,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: MandalaBreathPainter(
                        expansion: _expansionAnimation.value,
                        primaryColor: ZenvuraPalette.mint,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentPhase,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                                color: ZenvuraPalette.textPrimary,
                              ),
                            ),
                            if (_isActive && _phaseSecondsLeft > 0)
                              Text(
                                '$_phaseSecondsLeft s',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: ZenvuraPalette.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const Spacer(),

            // Control Trigger Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isActive ? Colors.redAccent : ZenvuraPalette.mint,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: _isActive ? _pauseBreathing : _startBreathing,
                    icon: Icon(_isActive ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 28),
                    label: Text(
                      _isActive ? 'PAUSE SESSION' : 'START FLOW',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
