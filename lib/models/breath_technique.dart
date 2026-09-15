class BreathTechnique {
  final String id;
  final String name;
  final String description;
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;
  final int holdAfterExhaleSeconds;

  const BreathTechnique({
    required this.id,
    required this.name,
    required this.description,
    required this.inhaleSeconds,
    required this.holdSeconds,
    required this.exhaleSeconds,
    this.holdAfterExhaleSeconds = 0,
  });

  int get totalCycleSeconds =>
      inhaleSeconds + holdSeconds + exhaleSeconds + holdAfterExhaleSeconds;

  static const List<BreathTechnique> defaultPresets = [
    BreathTechnique(
      id: 'box',
      name: 'Box Breathing (Samavritti)',
      description: 'Navy SEAL stress-regulation protocol for high cognitive calm',
      inhaleSeconds: 4,
      holdSeconds: 4,
      exhaleSeconds: 4,
      holdAfterExhaleSeconds: 4,
    ),
    BreathTechnique(
      id: 'sleep_478',
      name: '4-7-8 Deep Rest Flow',
      description: 'Dr. Andrew Weil parasympathetic nervous system sedative',
      inhaleSeconds: 4,
      holdSeconds: 7,
      exhaleSeconds: 8,
    ),
    BreathTechnique(
      id: 'coherence_55',
      name: 'Resonant Heart Coherence',
      description: '5.5 breaths per minute optimal HRV cardiovascular sync',
      inhaleSeconds: 5,
      holdSeconds: 0,
      exhaleSeconds: 5,
    ),
    BreathTechnique(
      id: 'pranayama_calm',
      name: 'Pranayama Vayu',
      description: 'Extended elongated exhalation for rapid anxiety relief',
      inhaleSeconds: 3,
      holdSeconds: 2,
      exhaleSeconds: 6,
    ),
  ];
}
