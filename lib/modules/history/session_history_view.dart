import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/pulse_theme.dart';
import '../breathing_sphere/breathing_flow_controller.dart';

class SessionHistoryView extends StatelessWidget {
  const SessionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BreathingFlowController>();
    final sessions = controller.sessions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session History'),
        actions: [
          if (sessions.isNotEmpty)
            IconButton(
              tooltip: 'Clear History',
              icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: () => _confirmClear(context, controller),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: PulseColors.primaryTeal,
        foregroundColor: PulseColors.softMint,
        icon: const Icon(Icons.edit_calendar_rounded),
        label: const Text('Log Minutes'),
        onPressed: () => _showManualLogDialog(context, controller),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Analytics Row
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Mindful Min',
                      value: '${controller.totalMindfulMinutes}',
                      icon: Icons.timer_outlined,
                      accentColor: PulseColors.mint,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Sessions',
                      value: '${sessions.length}',
                      icon: Icons.check_circle_outline_rounded,
                      accentColor: PulseColors.lightTeal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard(
                      title: 'Current Streak',
                      value: '${controller.streakDays}d',
                      icon: Icons.local_fire_department_rounded,
                      accentColor: PulseColors.accentAmber,
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: PulseColors.border, height: 1),

            // Sessions List
            Expanded(
              child: sessions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history_toggle_off_rounded,
                            size: 56,
                            color: PulseColors.textSecondary.withValues(alpha: 0.4),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No sessions recorded yet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: PulseColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Complete a breathing session to record mindful minutes.',
                            style: TextStyle(
                              fontSize: 13,
                              color: PulseColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                      itemCount: sessions.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        final durationMin = (session.durationSeconds / 60).toStringAsFixed(1);
                        final dateStr =
                            '${session.timestamp.year}-${session.timestamp.month.toString().padLeft(2, '0')}-${session.timestamp.day.toString().padLeft(2, '0')}';
                        final timeStr =
                            '${session.timestamp.hour.toString().padLeft(2, '0')}:${session.timestamp.minute.toString().padLeft(2, '0')}';

                        return Dismissible(
                          key: Key(session.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: PulseColors.errorRed.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.delete_outline,
                                color: PulseColors.errorRed),
                          ),
                          onDismissed: (_) => controller.deleteSession(session.id),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: PulseColors.surface,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: PulseColors.border),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: PulseColors.surfaceLight,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: PulseColors.border),
                                  ),
                                  child: const Icon(
                                    Icons.air_rounded,
                                    color: PulseColors.mint,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        session.techniqueName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: PulseColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '$dateStr at $timeStr • ${session.completedCycles} cycles',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: PulseColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '$durationMin min',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: PulseColors.mint,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${session.durationSeconds}s',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: PulseColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color accentColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: PulseColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PulseColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: accentColor, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              color: PulseColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showManualLogDialog(
      BuildContext context, BreathingFlowController controller) {
    final techCtrl = TextEditingController(text: 'Unguided Meditation');
    double durationMin = 10;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: PulseColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(color: PulseColors.border),
              ),
              title: const Text(
                'Log Mindful Minutes',
                style: TextStyle(color: PulseColors.textPrimary),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: techCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Session Label',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Duration:',
                        style: TextStyle(color: PulseColors.textSecondary),
                      ),
                      Text(
                        '${durationMin.round()} minutes',
                        style: const TextStyle(
                          color: PulseColors.mint,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: durationMin,
                    min: 1,
                    max: 60,
                    divisions: 59,
                    activeColor: PulseColors.mint,
                    inactiveColor: PulseColors.surfaceLight,
                    onChanged: (v) => setDialogState(() => durationMin = v),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel',
                      style: TextStyle(color: PulseColors.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final label = techCtrl.text.trim().isEmpty
                        ? 'Mindful Practice'
                        : techCtrl.text.trim();
                    controller.logManualSession(label, durationMin.round());
                    Navigator.pop(ctx);
                  },
                  child: const Text('Save Record'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmClear(
      BuildContext context, BreathingFlowController controller) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: PulseColors.surface,
        title: const Text('Reset Log',
            style: TextStyle(color: PulseColors.textPrimary)),
        content: const Text(
          'Are you sure you wish to clear all breathing session history? This action cannot be reversed.',
          style: TextStyle(color: PulseColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Keep',
                style: TextStyle(color: PulseColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PulseColors.errorRed,
            ),
            onPressed: () {
              controller.clearHistory();
              Navigator.pop(ctx);
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
