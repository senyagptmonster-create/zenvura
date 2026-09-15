import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/pulse_theme.dart';
import 'breathing_flow_controller.dart';

class BreathingSphereView extends StatefulWidget {
  const BreathingSphereView({super.key});

  @override
  State<BreathingSphereView> createState() => _BreathingSphereViewState();
}

class _BreathingSphereViewState extends State<BreathingSphereView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _syncAnimation(BreathingFlowController controller) {
    if (!controller.isActive || controller.isPaused) {
      if (_animController.isAnimating) _animController.stop();
      return;
    }

    final durationSec = controller.currentPhaseDuration;
    if (durationSec <= 0) return;

    final phase = controller.currentPhase;
    final dur = Duration(seconds: durationSec);

    if (_animController.duration != dur) {
      _animController.duration = dur;
    }

    if (phase == BreathPhase.inhale) {
      if (!_animController.isAnimating || _animController.status != AnimationStatus.forward) {
        _animController.forward(from: controller.phaseProgress);
      }
    } else if (phase == BreathPhase.exhale) {
      if (!_animController.isAnimating || _animController.status != AnimationStatus.reverse) {
        _animController.reverse(from: 1.0 - controller.phaseProgress);
      }
    } else if (phase == BreathPhase.holdInhale) {
      _animController.value = 1.0;
    } else if (phase == BreathPhase.holdExhale || phase == BreathPhase.idle) {
      _animController.value = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BreathingFlowController>();
    _syncAnimation(controller);

    final tech = controller.selectedTechnique;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Breathing Sphere'),
        actions: [
          IconButton(
            tooltip: 'Haptic Cues',
            icon: Icon(
              controller.vibrationEnabled
                  ? Icons.vibration_rounded
                  : Icons.smartphone_rounded,
              color: controller.vibrationEnabled
                  ? PulseColors.mint
                  : PulseColors.textSecondary,
            ),
            onPressed: () => controller.toggleVibration(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Technique Info Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: PulseColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: PulseColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: PulseColors.primaryTeal.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.air_rounded,
                        color: PulseColors.mint,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tech.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: PulseColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tech.category,
                            style: const TextStyle(
                              fontSize: 12,
                              color: PulseColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: PulseColors.surfaceLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: PulseColors.border),
                      ),
                      child: Text(
                        '${tech.cycleDuration}s / cycle',
                        style: const TextStyle(
                          fontSize: 12,
                          color: PulseColors.mint,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Animated Breathing Sphere
              SizedBox(
                height: 290,
                width: 290,
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    double expansion;
                    if (controller.currentPhase == BreathPhase.holdInhale) {
                      expansion = 1.0;
                    } else if (controller.currentPhase == BreathPhase.holdExhale ||
                        controller.currentPhase == BreathPhase.idle) {
                      expansion = 0.0;
                    } else {
                      expansion = _animController.value;
                    }

                    return CustomPaint(
                      painter: _BreathingSpherePainter(
                        expansion: expansion,
                        phase: controller.currentPhase,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              controller.currentPhase.label.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2.0,
                                color: PulseColors.textPrimary,
                              ),
                            ),
                            if (controller.isActive &&
                                controller.currentPhaseDuration > 0) ...[
                              const SizedBox(height: 8),
                              Text(
                                '${controller.currentPhaseDuration - controller.secondsInPhase}s',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w300,
                                  color: PulseColors.mint,
                                ),
                              ),
                              Text(
                                'Cycle ${controller.currentCycle} of ${controller.targetCycles}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: PulseColors.textSecondary,
                                ),
                              ),
                            ] else if (controller.currentPhase ==
                                BreathPhase.completed) ...[
                              const SizedBox(height: 6),
                              const Icon(
                                Icons.check_circle_rounded,
                                color: PulseColors.mint,
                                size: 36,
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Peace Restored',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: PulseColors.softMint,
                                ),
                              ),
                            ] else ...[
                              const SizedBox(height: 6),
                              const Text(
                                'Tap Start to flow',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: PulseColors.textSecondary,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Guidance Text
              Text(
                controller.currentPhase.guidance,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: PulseColors.textSecondary,
                ),
              ),

              const SizedBox(height: 24),

              // Cycle Target Selector (when idle)
              if (!controller.isActive) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Rounds: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: PulseColors.textSecondary,
                      ),
                    ),
                    ...[3, 5, 8, 10].map((count) {
                      final isSelected = controller.targetCycles == count;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text('$count'),
                          selected: isSelected,
                          selectedColor: PulseColors.mint,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? PulseColors.background
                                : PulseColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                          backgroundColor: PulseColors.surface,
                          side: const BorderSide(color: PulseColors.border),
                          onSelected: (_) => controller.setTargetCycles(count),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 20),
              ],

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!controller.isActive)
                    ElevatedButton.icon(
                      onPressed: () => controller.startSession(),
                      icon: const Icon(Icons.play_arrow_rounded, size: 28),
                      label: const Text('Start Breathing'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else ...[
                    OutlinedButton.icon(
                      onPressed: () => controller.stopSession(),
                      icon: const Icon(Icons.stop_rounded, color: PulseColors.errorRed),
                      label: const Text(
                        'End',
                        style: TextStyle(color: PulseColors.errorRed),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: PulseColors.errorRed),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (controller.isPaused) {
                          controller.resumeSession();
                        } else {
                          controller.pauseSession();
                        }
                      },
                      icon: Icon(
                        controller.isPaused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        size: 26,
                      ),
                      label: Text(controller.isPaused ? 'Resume' : 'Pause'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _BreathingSpherePainter extends CustomPainter {
  final double expansion;
  final BreathPhase phase;

  _BreathingSpherePainter({
    required this.expansion,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final minRadius = size.width * 0.28;
    final maxRadius = size.width * 0.46;
    final currentRadius = minRadius + (maxRadius - minRadius) * expansion;

    // Outer faint aura
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          PulseColors.mint.withValues(alpha: 0.18 * (0.4 + 0.6 * expansion)),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius * 1.15))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, maxRadius * 1.15, auraPaint);

    // Ripple concentric guides
    final guidePaint = Paint()
      ..color = PulseColors.border.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, minRadius, guidePaint);
    canvas.drawCircle(center, (minRadius + maxRadius) / 2, guidePaint);
    canvas.drawCircle(center, maxRadius, guidePaint);

    // Dynamic glowing ring
    final glowPaint = Paint()
      ..color = PulseColors.lightTeal.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(center, currentRadius, glowPaint);

    // Main sphere fill with rich gradient
    final fillPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.2, -0.2),
        colors: [
          PulseColors.surfaceLight,
          PulseColors.primaryTeal.withValues(alpha: 0.85),
          PulseColors.surface,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: currentRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, currentRadius, fillPaint);

    // Accent contour ring
    final contourPaint = Paint()
      ..color = PulseColors.mint.withValues(alpha: 0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, currentRadius, contourPaint);

    // Subtle orbiting bead indicator
    final beadAngle = expansion * 2 * math.pi;
    final beadOffset = Offset(
      center.dx + currentRadius * math.cos(beadAngle),
      center.dy + currentRadius * math.sin(beadAngle),
    );
    final beadPaint = Paint()
      ..color = PulseColors.softMint
      ..style = PaintingStyle.fill;
    canvas.drawCircle(beadOffset, 4.5, beadPaint);
  }

  @override
  bool shouldRepaint(covariant _BreathingSpherePainter oldDelegate) {
    return oldDelegate.expansion != expansion || oldDelegate.phase != phase;
  }
}
