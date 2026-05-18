import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/fishing_provider.dart';
import '../models/tournament.dart';

class TournamentScreen extends StatefulWidget {
  const TournamentScreen({super.key});

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  void _showCreateDialog() {
    TournamentType selectedType = TournamentType.totalWeight;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Új verseny létrehozása'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Verseny neve'),
              ),
              const SizedBox(height: 16),
              DropdownButton<TournamentType>(
                value: selectedType,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: TournamentType.totalWeight, child: Text('Összsúly alapján')),
                  DropdownMenuItem(value: TournamentType.maxWeight, child: Text('Legnagyobb hal alapján')),
                ],
                onChanged: (val) => setDialogState(() => selectedType = val!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Mégse')),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  Provider.of<FishingProvider>(context, listen: false)
                      .createTournament(_nameController.text, selectedType);
                  _nameController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Létrehozás'),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Csatlakozás versenyhez'),
        content: TextField(
          controller: _codeController,
          decoration: const InputDecoration(labelText: '6 jegyű kód', hintText: '123456'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Mégse')),
          ElevatedButton(
            onPressed: () {
              final success = Provider.of<FishingProvider>(context, listen: false)
                  .joinTournament(_codeController.text);
              if (success) {
                _codeController.clear();
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Helytelen kód!')),
                );
              }
            },
            child: const Text('Csatlakozás'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digitális Versenyszoba')),
      body: Consumer<FishingProvider>(
        builder: (context, provider, child) {
          final tournament = provider.activeTournament;

          if (tournament == null) {
            return _buildNoTournamentView();
          }

          return _buildActiveTournamentView(provider, tournament);
        },
      ),
    );
  }

  Widget _buildNoTournamentView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emoji_events_outlined, size: 100, color: Colors.grey),
            const SizedBox(height: 24),
            const Text(
              'Nincs aktív versenyed.',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Hozz létre egy saját versenyt a barátaiddal, vagy csatlakozz egy meglévőhöz a kódjukkal!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                backgroundColor: Colors.orange.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _showCreateDialog,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('SAJÁT VERSENY INDÍTÁSA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _showJoinDialog,
              icon: const Icon(Icons.group_add_outlined),
              label: const Text('CSATLAKOZÁS KÓDDAL', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTournamentView(FishingProvider provider, Tournament tournament) {
    final leaderboard = provider.getTournamentLeaderboard();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Card(
          color: Colors.orange.shade700,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text('BELÉPÉSI KÓD', style: TextStyle(color: Colors.white70, letterSpacing: 2)),
                Text(
                  tournament.joinCode,
                  style: const TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold, letterSpacing: 10),
                ),
                const SizedBox(height: 8),
                Text(
                  'Verseny: ${tournament.name}',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text('Élő Ranglista', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        
        // Grafikon szekció
        _buildChart(provider),
        
        const SizedBox(height: 32),
        ...leaderboard.asMap().entries.map((entry) {
          int idx = entry.key;
          var participant = entry.value;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: idx == 0 ? Colors.amber : Colors.grey.shade200,
              child: Text('${idx + 1}', style: TextStyle(color: idx == 0 ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
            ),
            title: Text(participant.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            trailing: Text(
              '${participant.score.toStringAsFixed(2)} kg',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B5E20)),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildChart(FishingProvider provider) {
    final data = provider.getChartData();
    if (data.isEmpty) return const SizedBox();

    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (data.map((e) => e['score'] as double).reduce((a, b) => a > b ? a : b) + 1).toDouble(),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int idx = value.toInt();
                  if (idx >= 0 && idx < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(data[idx]['name'].toString().split(' ').first, style: const TextStyle(fontSize: 10)),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: data.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value['score'],
                  color: entry.key == 0 ? Colors.orange : Colors.green,
                  width: 25,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
