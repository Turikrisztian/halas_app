class Catch {
  final int? id;
  final String species;
  final double weight;
  final double length;
  final String bait;
  final DateTime dateTime;
  final String? photoPath;
  final String notes;
  final int spotId;

  Catch({
    this.id,
    required this.species,
    required this.weight,
    required this.length,
    required this.bait,
    required this.dateTime,
    this.photoPath,
    this.notes = '',
    required this.spotId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'species': species,
      'weight': weight,
      'length': length,
      'bait': bait,
      'dateTime': dateTime.toIso8601String(),
      'photoPath': photoPath,
      'notes': notes,
      'spotId': spotId,
    };
  }

  factory Catch.fromMap(Map<String, dynamic> map) {
    return Catch(
      id: map['id'],
      species: map['species'],
      weight: map['weight'],
      length: map['length'],
      bait: map['bait'],
      dateTime: DateTime.parse(map['dateTime']),
      photoPath: map['photoPath'],
      notes: map['notes'] ?? '',
      spotId: map['spotId'],
    );
  }
}
