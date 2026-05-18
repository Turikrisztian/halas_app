import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fishing_provider.dart';

class YearlySummaryScreen extends StatelessWidget {
  const YearlySummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    final provider = Provider.of<FishingProvider>(context);
    final summary = provider.getYearlySummary(year);

    return Scaffold(
      appBar: AppBar(
        title: Text('$year. évi Összesítő'),
      ),
      body: summary.isEmpty
          ? const Center(child: Text('Nincs adat az idei évről.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: summary.length,
              itemBuilder: (context, index) {
                final spotId = summary.keys.elementAt(index);
                final spotName = provider.getSpotName(spotId);
                final speciesMap = summary[spotId]!;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Text(
                          spotName,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...speciesMap.entries.map((entry) {
                        return ListTile(
                          title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${entry.value['count']} db'),
                          trailing: Text(
                            '${entry.value['weight'].toStringAsFixed(2)} kg',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
