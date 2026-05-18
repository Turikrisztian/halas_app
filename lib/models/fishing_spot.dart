class FishingSpot {
  final int? id;
  final String name;
  final double? latitude;
  final double? longitude;
  final String notes;
  final DateTime createdAt;

  FishingSpot({
    this.id,
    required this.name,
    this.latitude,
    this.longitude,
    required this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FishingSpot.fromMap(Map<String, dynamic> map) {
    return FishingSpot(
      id: map['id'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
