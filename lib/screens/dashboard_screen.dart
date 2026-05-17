import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/fishing_provider.dart';
import '../models/catch.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FishingProvider>(
      builder: (context, provider, child) {
        final lastCatch = provider.lastCatch;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gyors Statisztika',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildStatCard(
                    context,
                    'Fogások',
                    '${provider.totalCatchCount} db',
                    Colors.blue,
                  ),
                  _buildStatCard(
                    context,
                    'Összsúly',
                    '${provider.totalWeight.toStringAsFixed(1)} kg',
                    Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Legutóbbi Fogás',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),
              if (lastCatch != null)
                Card(
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.set_meal, size: 40, color: Colors.orange),
                    title: Text('${lastCatch.species} - ${lastCatch.weight} kg'),
                    subtitle: Text(
                      '${DateFormat('yyyy.MM.dd').format(lastCatch.dateTime)} - ${provider.getSpotName(lastCatch.spotId)}',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                )
              else
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Még nincs rögzített fogásod.'),
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                'Időjárás & Kapásindex',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.wb_sunny, color: Colors.yellow),
                          Text('Napos'),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.trending_up, color: Colors.red),
                          Text('Kiváló index'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, Color color) {
    return Expanded(
      child: Card(
        color: color.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
