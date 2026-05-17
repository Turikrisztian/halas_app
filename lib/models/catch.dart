class Catch {
  final String id;
  final String species;
  final double weight; // kg
  final double length; // cm
  final String bait;
  final DateTime dateTime;
  final String? photoPath;
  final String spotId;

  Catch({
    required this.id,
    required this.species,
    required this.weight,
    required this.length,
    required this.bait,
    required this.dateTime,
    this.photoPath,
    required this.spotId,
  });
}
