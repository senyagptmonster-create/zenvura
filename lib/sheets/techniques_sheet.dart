import 'package:flutter/material.dart';
import '../models/breath_technique.dart';
import '../theme/zenvura_palette.dart';

class TechniquesSheet extends StatelessWidget {
  final BreathTechnique activeTechnique;
  final ValueChanged<BreathTechnique> onSelect;

  const TechniquesSheet({
    super.key,
    required this.activeTechnique,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ZenvuraPalette.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
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
            'Pranayama Breathing Protocols',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ZenvuraPalette.textPrimary),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: BreathTechnique.defaultPresets.length,
            separatorBuilder: (context, _) => const SizedBox(height: 10),
            itemBuilder: (ctx, i) {
              final t = BreathTechnique.defaultPresets[i];
              final isSelected = t.id == activeTechnique.id;
              return InkWell(
                onTap: () {
                  onSelect(t);
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ZenvuraPalette.card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? ZenvuraPalette.mint : Colors.white10,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? ZenvuraPalette.mint : Colors.white30,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.name, style: const TextStyle(fontWeight: FontWeight.bold, color: ZenvuraPalette.textPrimary)),
                            const SizedBox(height: 3),
                            Text(t.description, style: const TextStyle(fontSize: 12, color: ZenvuraPalette.textSecondary)),
                            const SizedBox(height: 6),
                            Text(
                              'Inhale: ${t.inhaleSeconds}s  *  Hold: ${t.holdSeconds}s  *  Exhale: ${t.exhaleSeconds}s',
                              style: const TextStyle(fontSize: 11, color: ZenvuraPalette.teal, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
