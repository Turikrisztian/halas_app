import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fishing_provider.dart';
import 'package:intl/intl.dart';

class PersonalBestsScreen extends StatelessWidget {
  const PersonalBestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FishingProvider>(context);
    final pbs = provider.getPersonalBests();

    return Scaffold(
      appBar: AppBar(title: const Text('Trófeaszoba (PB)')),
      body: pbs.isEmpty
          ? const Center(child: Text('Még nincsenek rekordjaid.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pbs.length,
        itemBuilder: (context, index) {
          final species = pbs.keys.elementAt(index);
          final fish = pbs[species]!;

          return Card(
            // JAVÍTVA: EdgeInsets.bottom(16) -> EdgeInsets.only(bottom: 16)
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.green.shade800, Colors.green.shade500],
                  begin: Alignment.topLeft,
                  // JAVÍTVA: Offset.infinite -> Alignment.bottomRight
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const Icon(Icons.workspace_premium_rounded, color: Colors.amber, size: 50),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            species.toUpperCase(),
                            style: const TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${fish.weight.toStringAsFixed(2)} kg',
                            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${DateFormat('yyyy.MM.dd').format(fish.dateTime)} - ${provider.getSpotName(fish.spotId)}',
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}