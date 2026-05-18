import 'dart:math';
import 'package:flutter/material.dart';
import '../models/catch.dart';
import '../models/fishing_spot.dart';
import '../models/bait_recipe.dart';
import '../models/tournament.dart';
import '../services/database_service.dart';
import '../helpers/hungarian_fishing_rules.dart';

class FishingProvider with ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  
  List<Catch> _catches = [];
  List<FishingSpot> _spots = [];
  List<BaitRecipe> _baitRecipes = [];
  bool _isLoading = true;

  // --- FELHASZNÁLÓI ADATOK ---
  String _userName = "Magyar Horgász";
  final String _currentUserId = "user_789";

  // --- ONLINE VERSENY MODUL (SZIMULÁLT) ---
  Tournament? _activeTournament;

  List<Catch> get catches => _catches;
  List<FishingSpot> get spots => _spots;
  List<BaitRecipe> get baitRecipes => _baitRecipes;
  bool get isLoading => _isLoading;
  Tournament? get activeTournament => _activeTournament;
  String get userName => _userName;

  // --- STATISZTIKÁK A DASHBOARDHOZ ---
  int get totalCatchCount => _catches.length;
  double get totalWeight => _catches.fold(0.0, (sum, item) => sum + item.weight);
  Catch? get lastCatch => _catches.isEmpty ? null : _catches.first;

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

    final recipeMaps = await _dbService.getAllBaitRecipes();
    _baitRecipes = recipeMaps.map((m) => BaitRecipe.fromMap(m)).toList();
    
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  // --- ADATKEZELÉS ---

  Future<void> addCatch(Catch newCatch) async {
    await _dbService.saveCatch(newCatch.toMap());
    
    if (_activeTournament != null) {
      final pIndex = _activeTournament!.participants.indexWhere((p) => p.userId == _currentUserId);
      if (pIndex != -1) {
        if (_activeTournament!.type == TournamentType.totalWeight) {
          _activeTournament!.participants[pIndex].score += newCatch.weight;
        } else {
          _activeTournament!.participants[pIndex].score = max(_activeTournament!.participants[pIndex].score, newCatch.weight);
        }
      }
    }
    await refreshData();
  }

  Future<void> deleteCatch(int id) async {
    await _dbService.deleteCatch(id);
    await refreshData();
  }

  Future<void> addSpot(FishingSpot newSpot) async {
    await _dbService.saveSpot(newSpot.toMap());
    await refreshData();
  }

  Future<void> deleteSpot(int id) async {
    await _dbService.deleteSpot(id);
    await refreshData();
  }

  Future<void> addBaitRecipe(BaitRecipe recipe) async {
    await _dbService.saveBaitRecipe(recipe.toMap());
    await refreshData();
  }

  Future<void> deleteBaitRecipe(int id) async {
    await _dbService.deleteBaitRecipe(id);
    await refreshData();
  }

  // --- PRÉMIUM FUNKCIÓK ---

  List<String> getCurrentRestrictions() {
    final now = DateTime.now();
    final currentMD = now.month * 100 + now.day;
    List<String> restricted = [];

    HungarianFishingRules.rules.forEach((species, rule) {
      if (rule.closedSeasonStart != null && rule.closedSeasonEnd != null) {
        final startMD = rule.closedSeasonStart!.month * 100 + rule.closedSeasonStart!.day;
        final endMD = rule.closedSeasonEnd!.month * 100 + rule.closedSeasonEnd!.day;
        
        bool isRestricted = false;
        if (startMD <= endMD) {
          isRestricted = currentMD >= startMD && currentMD <= endMD;
        } else {
          isRestricted = currentMD >= startMD || currentMD <= endMD;
        }
        if (isRestricted) restricted.add(species);
      }
    });
    return restricted;
  }

  void createTournament(String name, TournamentType type) {
    final joinCode = (100000 + Random().nextInt(900000)).toString();
    _activeTournament = Tournament(
      id: "tour_${DateTime.now().millisecondsSinceEpoch}",
      name: name,
      joinCode: joinCode,
      creatorId: _currentUserId,
      participants: [TournamentParticipant(userId: _currentUserId, userName: _userName, score: 0.0)],
      type: type,
      createdAt: DateTime.now(),
    );
    notifyListeners();
  }

  bool joinTournament(String code) {
    if (_activeTournament != null && _activeTournament!.joinCode == code) {
      if (!_activeTournament!.participants.any((p) => p.userId == _currentUserId)) {
        _activeTournament!.participants.add(TournamentParticipant(userId: _currentUserId, userName: _userName, score: 0.0));
        notifyListeners();
      }
      return true;
    }
    return false;
  }

  List<TournamentParticipant> getTournamentLeaderboard() {
    if (_activeTournament == null) return [];
    final list = [..._activeTournament!.participants];
    list.sort((a, b) => b.score.compareTo(a.score));
    return list;
  }

  List<Map<String, dynamic>> getChartData() {
    final leaderboard = getTournamentLeaderboard();
    return leaderboard.map((p) => {'name': p.userName, 'score': p.score}).toList();
  }

  Map<int, Map<String, Map<String, dynamic>>> getYearlySummary(int year) {
    final yearlyCatches = _catches.where((c) => c.dateTime.year == year).toList();
    Map<int, Map<String, Map<String, dynamic>>> summary = {};
    for (var c in yearlyCatches) {
      summary.putIfAbsent(c.spotId, () => {});
      summary[c.spotId]!.putIfAbsent(c.species, () => {'count': 0, 'weight': 0.0});
      summary[c.spotId]![c.species]!['count'] += 1;
      summary[c.spotId]![c.species]!['weight'] += c.weight;
    }
    return summary;
  }

  String? validateCatch(String species, double length, DateTime date) {
    final rule = HungarianFishingRules.rules[species];
    if (rule == null) return null;
    if (length < rule.minLength) return "⚠️ Méret alatti! Minimális méret: ${rule.minLength} cm.";
    if (rule.closedSeasonStart != null && rule.closedSeasonEnd != null) {
      final currentMD = date.month * 100 + date.day;
      final startMD = rule.closedSeasonStart!.month * 100 + rule.closedSeasonStart!.day;
      final endMD = rule.closedSeasonEnd!.month * 100 + rule.closedSeasonEnd!.day;
      bool isRestricted = startMD <= endMD ? (currentMD >= startMD && currentMD <= endMD) : (currentMD >= startMD || currentMD <= endMD);
      if (isRestricted) return "⚠️ Tilalmi időszak! $species jelenleg védett.";
    }
    return null;
  }

  Map<String, Catch> getPersonalBests() {
    Map<String, Catch> pbs = {};
    for (var c in _catches) {
      if (!pbs.containsKey(c.species) || c.weight > pbs[c.species]!.weight) pbs[c.species] = c;
    }
    return pbs;
  }

  int getBiteIndex(DateTime date) {
    final cyclePos = (date.difference(DateTime(2024, 1, 11)).inDays) % 29.53;
    if (cyclePos < 2 || cyclePos > 27.5) return 5;
    if (cyclePos > 13 && cyclePos < 16.5) return 4;
    return (cyclePos > 6 && cyclePos < 8.5) || (cyclePos > 21 && cyclePos < 23.5) ? 2 : 3;
  }

  String getSpotName(int id) {
    try { return _spots.firstWhere((s) => s.id == id).name; } catch (e) { return 'Ismeretlen helyszín'; }
  }

  int getCatchCountForSpot(int spotId) => _catches.where((c) => c.spotId == spotId).length;

  BaitRecipe? getRecipeById(int? id) {
    if (id == null) return null;
    try { return _baitRecipes.firstWhere((r) => r.id == id); } catch (e) { return null; }
  }
}
