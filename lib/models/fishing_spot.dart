class FishingSpot {
  final String id;
  final String name;
  final String? coordinates;
  final String notes;

  FishingSpot({
    required this.id,
    required this.name,
    this.coordinates,
    required this.notes,
  });
}
