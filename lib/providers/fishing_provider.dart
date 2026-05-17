import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/catch.dart';
import '../models/fishing_spot.dart';

class FishingProvider with ChangeNotifier {
  final List<Catch> _catches = [];
  final List<FishingSpot> _spots = [
    FishingSpot(
      id: 'default-1',
      name: 'Balaton - Balatonfüred',
      coordinates: '46.9589, 17.8914',
      notes: 'Mély víz, sok akadó, bojlis hely.',
    ),
  ];

  List<Catch> get catches => [..._catches];
  List<FishingSpot> get spots => [..._spots];

  void addCatch(Catch newCatch) {
    _catches.add(newCatch);
    notifyListeners();
  }

  void addSpot(FishingSpot newSpot) {
    _spots.add(newSpot);
    notifyListeners();
  }

  int get totalCatchCount => _catches.length;

  double get totalWeight {
    return _catches.fold(0.0, (sum, item) => sum + item.weight);
  }

  Catch? get lastCatch {
    if (_catches.isEmpty) return null;
    return _catches.last;
  }
  
  String getSpotName(String id) {
    try {
      return _spots.firstWhere((s) => s.id == id).name;
    } catch (e) {
      return 'Ismeretlen hely';
    }
  }
}
