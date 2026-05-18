import 'package:flutter/material.dart';
import '../models/catch.dart';
import '../models/fishing_spot.dart';
import '../services/database_service.dart';

class FishingProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  
  List<Catch> _catches = [];
  List<FishingSpot> _spots = [];
  bool _isLoading = true;

  List<Catch> get catches => _catches;
  List<FishingSpot> get spots => _spots;
  bool get isLoading => _isLoading;

  FishingProvider() {
    _init();
  }

  Future<void> _init() async {
    await refreshData();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshData() async {
    final catchMaps = await _dbService.getAllCatches();
    _catches = catchMaps.map((m) => Catch.fromMap(m)).toList();
    
    final spotMaps = await _dbService.getAllSpots();
    _spots = spotMaps.map((m) => FishingSpot.fromMap(m)).toList();
    
    notifyListeners();
  }

  Future<void> addCatch(Catch newCatch) async {
    await _dbService.saveCatch(newCatch.toMap());
    await refreshData();
  }

  Future<void> addSpot(FishingSpot newSpot) async {
    await _dbService.saveSpot(newSpot.toMap());
    await refreshData();
  }

  int get totalCatchCount => _catches.length;
  
  double get totalWeight => _catches.fold(0.0, (sum, item) => sum + item.weight);

  Catch? get lastCatch => _catches.isEmpty ? null : _catches.first;

  String getSpotName(int id) {
    try {
      return _spots.firstWhere((s) => s.id == id).name;
    } catch (e) {
      return 'Ismeretlen helyszín';
    }
  }
}
