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
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 120.0), // Padding a lebegő menü miatt
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gyors Statisztika',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildStatCard(
                    context,
                    'Fogások',
                    '${provider.totalCatchCount} db',
                    Colors.blue[800]!,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    context,
                    'Összsúly',
                    '${provider.totalWeight.toStringAsFixed(1)} kg',
                    Colors.green[800]!,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Legutóbbi Fogás',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (lastCatch != null)
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.set_meal, size: 40, color: Colors.orange),
                      ),
                      title: Text(
                        '${lastCatch.species} - ${lastCatch.weight} kg',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        '${DateFormat('yyyy.MM.dd').format(lastCatch.dateTime)}\n${provider.getSpotName(lastCatch.spotId)}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      isThreeLine: true,
                    ),
                  ),
                )
              else
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(
                        'Még nincs rögzített fogásod.',
                        style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 32),
              Text(
                'Időjárás & Esélyek',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.wb_sunny, color: Colors.orange, size: 48),
                          SizedBox(height: 8),
                          Text('Napos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.trending_up, color: Colors.red, size: 48),
                          SizedBox(height: 8),
                          Text('Kiváló kapás', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
