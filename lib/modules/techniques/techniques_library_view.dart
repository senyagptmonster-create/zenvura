import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common/pulse_theme.dart';
import '../breathing_sphere/breathing_flow_controller.dart';

class TechniquesLibraryView extends StatefulWidget {
  final VoidCallback? onSelectAndNavigate;

  const TechniquesLibraryView({super.key, this.onSelectAndNavigate});

  @override
  State<TechniquesLibraryView> createState() => _TechniquesLibraryViewState();
}

class _TechniquesLibraryViewState extends State<TechniquesLibraryView> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Focus & Balance',
    'Rest & Unwind',
    'Harmonic Energy',
    'Stress Release',
    'Custom',
  ];

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BreathingFlowController>();
    final allTechs = controller.techniques;

    final filteredTechs = _selectedCategory == 'All'
        ? allTechs
        : _selectedCategory == 'Custom'
            ? allTechs.where((t) => t.id.startsWith('custom_')).toList()
            : allTechs.where((t) => t.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Techniques Library'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: PulseColors.mint,
        foregroundColor: PulseColors.background,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Custom Flow'),
        onPressed: () => _showAddCustomTechniqueModal(context, controller),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Filter Chips
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == _selectedCategory;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: PulseColors.mint,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? PulseColors.background
                          : PulseColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    backgroundColor: PulseColors.surface,
                    side: const BorderSide(color: PulseColors.border),
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = cat);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Technique Cards List
            Expanded(
              child: filteredTechs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.spa_rounded,
                              size: 48, color: PulseColors.textSecondary.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          const Text(
                            'No techniques found in this category',
                            style: TextStyle(color: PulseColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                      itemCount: filteredTechs.length,
                      itemBuilder: (context, index) {
                        final tech = filteredTechs[index];
                        final isSelected =
                            controller.selectedTechnique.id == tech.id;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? PulseColors.surfaceLight
                                : PulseColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? PulseColors.mint
                                  : PulseColors.border,
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            tech.name,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: PulseColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            tech.category,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: PulseColors.mint,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: PulseColors.primaryTeal,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'ACTIVE',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: PulseColors.softMint,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  tech.description,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: PulseColors.textSecondary,
                                    height: 1.35,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Timing Phase Pills
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    _buildPhasePill(
                                        'Inhale', '${tech.inhaleSeconds}s'),
                                    if (tech.holdInhaleSeconds > 0)
                                      _buildPhasePill('Hold',
                                          '${tech.holdInhaleSeconds}s'),
                                    _buildPhasePill(
                                        'Exhale', '${tech.exhaleSeconds}s'),
                                    if (tech.holdExhaleSeconds > 0)
                                      _buildPhasePill('Rest',
                                          '${tech.holdExhaleSeconds}s'),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.verified_outlined,
                                        size: 14,
                                        color: PulseColors.accentAmber),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        tech.benefit,
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          fontStyle: FontStyle.italic,
                                          color: PulseColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.selectTechnique(tech);
                                      if (widget.onSelectAndNavigate != null) {
                                        widget.onSelectAndNavigate!();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Selected ${tech.name}. Switch to Sphere to begin.'),
                                            backgroundColor:
                                                PulseColors.surfaceLight,
                                            behavior:
                                                SnackBarBehavior.floating,
                                            duration:
                                                const Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isSelected
                                          ? PulseColors.mint
                                          : PulseColors.surfaceLight,
                                      foregroundColor: isSelected
                                          ? PulseColors.background
                                          : PulseColors.mint,
                                      elevation: 0,
                                      side: BorderSide(
                                        color: isSelected
                                            ? Colors.transparent
                                            : PulseColors.border,
                                      ),
                                    ),
                                    child: Text(
                                      isSelected
                                          ? 'Ready in Breathing Sphere'
                                          : 'Select Technique',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
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

  Widget _buildPhasePill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: PulseColors.surfaceLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: PulseColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 11,
              color: PulseColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: PulseColors.mint,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCustomTechniqueModal(
      BuildContext context, BreathingFlowController controller) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    double inhale = 4;
    double holdInhale = 4;
    double exhale = 4;
    double holdExhale = 0;
    double cycles = 5;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: PulseColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: PulseColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Design Custom Rhythm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: PulseColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Technique Name',
                        hintText: 'e.g., Ocean Waves 5-5',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Intention / Notes',
                        hintText: 'e.g., Deep evening restorative pattern',
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSlider(
                      label: 'Inhale Duration',
                      value: inhale,
                      min: 1,
                      max: 12,
                      unit: 's',
                      onChanged: (v) => setModalState(() => inhale = v),
                    ),
                    _buildSlider(
                      label: 'Hold Inhale Duration',
                      value: holdInhale,
                      min: 0,
                      max: 16,
                      unit: 's',
                      onChanged: (v) => setModalState(() => holdInhale = v),
                    ),
                    _buildSlider(
                      label: 'Exhale Duration',
                      value: exhale,
                      min: 1,
                      max: 16,
                      unit: 's',
                      onChanged: (v) => setModalState(() => exhale = v),
                    ),
                    _buildSlider(
                      label: 'Hold Exhale Duration',
                      value: holdExhale,
                      min: 0,
                      max: 10,
                      unit: 's',
                      onChanged: (v) => setModalState(() => holdExhale = v),
                    ),
                    _buildSlider(
                      label: 'Target Rounds',
                      value: cycles,
                      min: 2,
                      max: 15,
                      unit: ' rounds',
                      onChanged: (v) => setModalState(() => cycles = v),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final name = nameCtrl.text.trim();
                          if (name.isEmpty) return;
                          controller.addCustomTechnique(
                            name: name,
                            category: 'Custom Rhythm',
                            description: descCtrl.text.trim().isEmpty
                                ? 'User crafted custom breathing cadence.'
                                : descCtrl.text.trim(),
                            inhale: inhale.round(),
                            holdInhale: holdInhale.round(),
                            exhale: exhale.round(),
                            holdExhale: holdExhale.round(),
                            cycles: cycles.round(),
                          );
                          Navigator.pop(ctx);
                          if (widget.onSelectAndNavigate != null) {
                            widget.onSelectAndNavigate!();
                          }
                        },
                        child: const Text('Save & Select Rhythm'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: PulseColors.textSecondary,
              ),
            ),
            Text(
              '${value.round()}$unit',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: PulseColors.mint,
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          activeColor: PulseColors.mint,
          inactiveColor: PulseColors.surfaceLight,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
