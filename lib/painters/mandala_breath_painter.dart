import 'dart:math' as math;
import 'package:flutter/material.dart';

class MandalaBreathPainter extends CustomPainter {
  final double expansion; // 0.0 to 1.0
  final Color primaryColor;

  const MandalaBreathPainter({
    required this.expansion,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = (size.shortestSide / 2) * 0.9;
    final currentRadius = (maxRadius * (0.45 + 0.55 * expansion)).clamp(20.0, maxRadius);

    // Outer aura glow
    final glowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.15 * expansion + 0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(center, currentRadius * 1.15, glowPaint);

    // Concentric rippling rings
    for (int r = 1; r <= 3; r++) {
      final ringRadius = currentRadius * (r / 3.0);
      final ringPaint = Paint()
        ..color = primaryColor.withValues(alpha: (0.1 + 0.15 * expansion) / r)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(center, ringRadius, ringPaint);
    }

    // Sacred geometry petals (8 symmetrical loops)
    const int petals = 8;
    final petalPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.35 + 0.45 * expansion)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (int i = 0; i < petals; i++) {
      final angle = (i * 2 * math.pi) / petals + (expansion * 0.2);
      final petalCenter = Offset(
        center.dx + (currentRadius * 0.45) * math.cos(angle),
        center.dy + (currentRadius * 0.45) * math.sin(angle),
      );
      canvas.drawCircle(petalCenter, currentRadius * 0.35, petalPaint);
    }

    // Center core lotus bud
    final corePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8 + 4 * expansion, corePaint);
  }

  @override
  bool shouldRepaint(covariant MandalaBreathPainter oldDelegate) {
    return oldDelegate.expansion != expansion || oldDelegate.primaryColor != primaryColor;
  }
}
