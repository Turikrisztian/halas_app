enum TournamentType { totalWeight, maxWeight }

class TournamentParticipant {
  final String userId;
  final String userName;
  double score;

  TournamentParticipant({
    required this.userId,
    required this.userName,
    this.score = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'score': score,
    };
  }

  factory TournamentParticipant.fromMap(Map<String, dynamic> map) {
    return TournamentParticipant(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Ismeretlen',
      score: (map['score'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Tournament {
  final String id;
  final String name;
  final String joinCode;
  final String creatorId;
  final List<TournamentParticipant> participants;
  final TournamentType type;
  final DateTime createdAt;

  Tournament({
    required this.id,
    required this.name,
    required this.joinCode,
    required this.creatorId,
    required this.participants,
    required this.type,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'joinCode': joinCode,
      'creatorId': creatorId,
      'participants': participants.map((p) => p.toMap()).toList(),
      'type': type.index,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Tournament.fromMap(Map<String, dynamic> map) {
    return Tournament(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      joinCode: map['joinCode'] ?? '',
      creatorId: map['creatorId'] ?? '',
      participants: (map['participants'] as List?)
              ?.map((p) => TournamentParticipant.fromMap(p))
              .toList() ??
          [],
      type: TournamentType.values[map['type'] ?? 0],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
