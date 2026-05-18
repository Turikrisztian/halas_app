import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/fishing_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FishingProvider>(
      builder: (context, provider, child) {
        final lastCatch = provider.lastCatch;
        final biteIndex = provider.getBiteIndex(DateTime.now());
        final personalBests = provider.getPersonalBests();
        final restrictions = provider.getCurrentRestrictions();

        return SingleChildScrollView(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 120.0),
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

              // --- 2. FUNKCIÓ: Aktuális Tilalmak Jelzése ---
              if (restrictions.isNotEmpty) ...[
                _buildRestrictionBanner(context, restrictions),
                const SizedBox(height: 32),
              ],
              
              // --- 3. FUNKCIÓ: Kapásindex ---
              Text(
                'Időjárás & Esélyek',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildBiteIndexCard(context, biteIndex),

              const SizedBox(height: 32),
              Text(
                'Legutóbbi Fogás',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (lastCatch != null)
                _buildLastCatchCard(context, lastCatch, provider)
              else
                _buildEmptyCard('Még nincs rögzített fogásod.'),

              const SizedBox(height: 32),
              // --- 4. FUNKCIÓ: Trófeaszoba (PB) ---
              if (personalBests.isNotEmpty) ...[
                Text(
                  'Egyéni Rekordok (PB)',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: personalBests.length,
                    itemBuilder: (context, index) {
                      final species = personalBests.keys.elementAt(index);
                      final fish = personalBests[species]!;
                      return _buildPBCard(context, species, fish.weight);
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildRestrictionBanner(BuildContext context, List<String> species) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aktuális tilalmak:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 16),
                ),
                Text(
                  species.join(', '),
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiteIndexCard(BuildContext context, int index) {
    String text = 'Átlagos';
    Color color = Colors.orange;
    IconData icon = Icons.trending_flat;

    if (index >= 4) {
      text = 'Kiváló';
      color = Colors.red;
      icon = Icons.trending_up;
    } else if (index <= 2) {
      text = 'Gyenge';
      color = Colors.blue;
      icon = Icons.trending_down;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Column(
              children: [
                Icon(Icons.wb_sunny, color: Colors.orange, size: 48),
                SizedBox(height: 8),
                Text('Napos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              children: [
                Icon(icon, color: color, size: 48),
                const SizedBox(height: 8),
                Text('$text kapás', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
                Text('Index: $index/5', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPBCard(BuildContext context, String species, double weight) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E7D32).withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(species, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text('${weight.toStringAsFixed(1)} kg', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
          const Text('REKORD', style: TextStyle(fontSize: 10, letterSpacing: 1.5, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildLastCatchCard(BuildContext context, dynamic lastCatch, FishingProvider provider) {
    return Card(
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
    );
  }

  Widget _buildEmptyCard(String message) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          ),
        ),
      ),
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
