import 'package:flutter/material.dart';
import '../helpers/hungarian_fishing_rules.dart';
import 'package:intl/intl.dart';

class FishRulesScreen extends StatelessWidget {
  const FishRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rules = HungarianFishingRules.rules;

    return Scaffold(
      appBar: AppBar(title: const Text('Országos Horgászrend')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rules.length,
        itemBuilder: (context, index) {
          final species = rules.keys.elementAt(index);
          final rule = rules[species]!;

          return Card(
            // JAVÍTVA: EdgeInsets.bottom(12) -> EdgeInsets.only(bottom: 12)
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ExpansionTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(species[0], style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
              ),
              title: Text(species, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              subtitle: Text('Min. méret: ${rule.minLength.toInt()} cm'),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20, color: Colors.red),
                          const SizedBox(width: 12),
                          const Text('Tilalmi időszak:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Text(
                          rule.closedSeasonStart != null
                              ? '${_formatMD(rule.closedSeasonStart!)} — ${_formatMD(rule.closedSeasonEnd!)}'
                              : 'Nincs országos tilalma.',
                          style: TextStyle(fontSize: 18, color: rule.closedSeasonStart != null ? Colors.red : Colors.green),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.straighten, size: 20, color: Colors.blue),
                          const SizedBox(width: 12),
                          const Text('Méretkorlátozás:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: Text('${rule.minLength.toInt()} cm felett megtartható.', style: const TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatMD(DateTime date) {
    return DateFormat('MMMM d.', 'hu_HU').format(date);
  }
}