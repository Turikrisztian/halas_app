class FishRule {
  final double minLength; // cm
  final DateTime? closedSeasonStart; // Month and day matter
  final DateTime? closedSeasonEnd;

  const FishRule({
    required this.minLength,
    this.closedSeasonStart,
    this.closedSeasonEnd,
  });
}

class HungarianFishingRules {
  // Országos alapértelmezett szabályok (tájékoztató jelleggel)
  static final Map<String, FishRule> rules = {
    'Ponty': FishRule(
      minLength: 30,
      closedSeasonStart: DateTime(0, 5, 2),
      closedSeasonEnd: DateTime(0, 5, 31),
    ),
    'Csuka': FishRule(
      minLength: 40,
      closedSeasonStart: DateTime(0, 2, 1),
      closedSeasonEnd: DateTime(0, 3, 31),
    ),
    'Süllő': FishRule(
      minLength: 30,
      closedSeasonStart: DateTime(0, 3, 1),
      closedSeasonEnd: DateTime(0, 4, 30),
    ),
    'Harcsa': FishRule(
      minLength: 60,
      closedSeasonStart: DateTime(0, 5, 2),
      closedSeasonEnd: DateTime(0, 6, 15),
    ),
    'Balin': FishRule(
      minLength: 40,
      closedSeasonStart: DateTime(0, 3, 1),
      closedSeasonEnd: DateTime(0, 4, 30),
    ),
    'Amur': FishRule(minLength: 40), // Nincs országos tilalma
    'Kősüllő': FishRule(
      minLength: 25,
      closedSeasonStart: DateTime(0, 3, 1),
      closedSeasonEnd: DateTime(0, 6, 30),
    ),
    'Menyhal': FishRule(
      minLength: 25,
    ),
  };
}
