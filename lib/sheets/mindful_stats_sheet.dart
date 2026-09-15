import 'package:flutter/material.dart';
import '../theme/zenvura_palette.dart';

class MindfulStatsSheet extends StatelessWidget {
  final int completedCycles;
  final int totalMinutes;

  const MindfulStatsSheet({
    super.key,
    required this.completedCycles,
    required this.totalMinutes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ZenvuraPalette.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Mindful Respiration Log',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ZenvuraPalette.textPrimary),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _buildMetricCard('Completed Cycles', '$completedCycles', Icons.repeat_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _buildMetricCard('Mindful Minutes', '$totalMinutes min', Icons.spa_rounded)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: ZenvuraPalette.card,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.self_improvement_rounded, color: ZenvuraPalette.mint, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Regular rhythmic breathing restores autonomic balance and lowers resting heart rate.',
                    style: TextStyle(fontSize: 12, color: ZenvuraPalette.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZenvuraPalette.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ZenvuraPalette.mint, size: 22),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: ZenvuraPalette.textPrimary)),
          const SizedBox(height: 2),
          Text(title, style: const TextStyle(fontSize: 12, color: ZenvuraPalette.textSecondary)),
        ],
      ),
    );
  }
}
