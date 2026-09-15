import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/pulse_theme.dart';
import '../breathing_sphere/breathing_flow_controller.dart';

class MindfulnessStreaksView extends StatefulWidget {
  const MindfulnessStreaksView({super.key});

  @override
  State<MindfulnessStreaksView> createState() => _MindfulnessStreaksViewState();
}

class _MindfulnessStreaksViewState extends State<MindfulnessStreaksView> {
  int _quoteIndex = 0;

  final List<Map<String, String>> _zenQuotes = const [
    {
      'quote': 'Feelings come and go like clouds in a windy sky. Conscious breathing is my anchor.',
      'author': 'Thich Nhat Hanh',
    },
    {
      'quote': 'The breath is the bridge which connects life to consciousness, which unites your body to your thoughts.',
      'author': 'Thich Nhat Hanh',
    },
    {
      'quote': 'Inhale the present, exhale the past. The only moment you truly possess is now.',
      'author': 'Mindful Maxim',
    },
    {
      'quote': 'Within you there is a stillness and a sanctuary to which you can retreat at any time.',
      'author': 'Hermann Hesse',
    },
    {
      'quote': 'Smile, breathe, and go slowly. There is nowhere to arrive except the present moment.',
      'author': 'Zen Proverb',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BreathingFlowController>();
    final streak = controller.streakDays;
    final totalMin = controller.totalMindfulMinutes;
    final totalSessions = controller.sessions.length;

    // Build 28-day streak matrix
    final today = DateTime.now();
    final sessionDates = controller.sessions
        .map((s) => '${s.timestamp.year}-${s.timestamp.month}-${s.timestamp.day}')
        .toSet();

    final milestones = [
      _Milestone(
        title: 'Initial Inhalation',
        description: 'Completed your first mindful session.',
        icon: Icons.spa_outlined,
        isUnlocked: totalSessions >= 1,
        progress: (totalSessions / 1).clamp(0.0, 1.0),
        progressLabel: '$totalSessions / 1 session',
      ),
      _Milestone(
        title: 'Calm Foundation',
        description: 'Maintained a 3-day breathing streak.',
        icon: Icons.local_fire_department_rounded,
        isUnlocked: streak >= 3,
        progress: (streak / 3).clamp(0.0, 1.0),
        progressLabel: '$streak / 3 days',
      ),
      _Milestone(
        title: 'Serenity Master',
        description: 'Sustained continuous practice for 7 consecutive days.',
        icon: Icons.military_tech_rounded,
        isUnlocked: streak >= 7,
        progress: (streak / 7).clamp(0.0, 1.0),
        progressLabel: '$streak / 7 days',
      ),
      _Milestone(
        title: 'Deep Oasis',
        description: 'Accumulated 30 total mindful minutes.',
        icon: Icons.hourglass_bottom_rounded,
        isUnlocked: totalMin >= 30,
        progress: (totalMin / 30).clamp(0.0, 1.0),
        progressLabel: '$totalMin / 30 min',
      ),
      _Milestone(
        title: 'Century of Breath',
        description: 'Surpassed 100 mindful minutes of conscious respiration.',
        icon: Icons.workspace_premium_rounded,
        isUnlocked: totalMin >= 100,
        progress: (totalMin / 100).clamp(0.0, 1.0),
        progressLabel: '$totalMin / 100 min',
      ),
    ];

    final currentQuote = _zenQuotes[_quoteIndex % _zenQuotes.length];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mindful Streaks'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Streak Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [PulseColors.surfaceLight, PulseColors.surface],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: PulseColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: PulseColors.primaryTeal.withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                        border: Border.all(color: PulseColors.mint, width: 2),
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: PulseColors.accentAmber,
                        size: 38,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$streak Day Streak',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: PulseColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            streak > 0
                                ? 'Your discipline cultivates unbroken stillness.'
                                : 'Take a session today to start your calming streak.',
                            style: const TextStyle(
                              fontSize: 13,
                              color: PulseColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Streak Calendar Matrix (Past 28 Days)
              const Text(
                'Past 28 Days Rhythm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: PulseColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: PulseColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: PulseColors.border),
                ),
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 28,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) {
                        final dayOffset = 27 - index;
                        final date = today.subtract(Duration(days: dayOffset));
                        final key = '${date.year}-${date.month}-${date.day}';
                        final isRecorded = sessionDates.contains(key);
                        final isToday = dayOffset == 0;

                        return Tooltip(
                          message: '${date.month}/${date.day}: ${isRecorded ? "Completed" : "Rest"}',
                          child: Container(
                            decoration: BoxDecoration(
                              color: isRecorded
                                  ? PulseColors.mint
                                  : PulseColors.surfaceLight,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isToday
                                    ? PulseColors.accentAmber
                                    : (isRecorded ? PulseColors.mint : PulseColors.border),
                                width: isToday ? 1.5 : 1.0,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${date.day}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: isRecorded
                                      ? PulseColors.background
                                      : PulseColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: PulseColors.surfaceLight,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: PulseColors.border),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text('Rest',
                            style: TextStyle(fontSize: 11, color: PulseColors.textSecondary)),
                        const SizedBox(width: 12),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: PulseColors.mint,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text('Mindful Day',
                            style: TextStyle(fontSize: 11, color: PulseColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Zen Quote Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: PulseColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: PulseColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.format_quote_rounded,
                                color: PulseColors.mint, size: 20),
                            SizedBox(width: 6),
                            Text(
                              'Zen Contemplation',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: PulseColors.mint,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          color: PulseColors.textSecondary,
                          onPressed: () {
                            setState(() {
                              _quoteIndex = (_quoteIndex + 1) % _zenQuotes.length;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '"${currentQuote['quote']}"',
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: PulseColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '— ${currentQuote['author']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: PulseColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Milestones List
              const Text(
                'Mindful Milestones',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: PulseColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...milestones.map((m) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: PulseColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: m.isUnlocked ? PulseColors.mint : PulseColors.border,
                      width: m.isUnlocked ? 1.2 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: m.isUnlocked
                              ? PulseColors.mint.withValues(alpha: 0.2)
                              : PulseColors.surfaceLight,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          m.icon,
                          color: m.isUnlocked
                              ? PulseColors.mint
                              : PulseColors.textSecondary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  m.title,
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                    color: m.isUnlocked
                                        ? PulseColors.textPrimary
                                        : PulseColors.textSecondary,
                                  ),
                                ),
                                if (m.isUnlocked)
                                  const Icon(
                                    Icons.check_circle_rounded,
                                    size: 18,
                                    color: PulseColors.mint,
                                  ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              m.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: PulseColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: m.progress,
                                minHeight: 5,
                                backgroundColor: PulseColors.surfaceLight,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  m.isUnlocked
                                      ? PulseColors.mint
                                      : PulseColors.lightTeal,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                m.progressLabel,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: PulseColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _Milestone {
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;
  final double progress;
  final String progressLabel;

  const _Milestone({
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    required this.progress,
    required this.progressLabel,
  });
}
