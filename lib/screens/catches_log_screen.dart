import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/fishing_provider.dart';
import '../models/catch.dart';

class CatchesLogScreen extends StatelessWidget {
  const CatchesLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FishingProvider>(
      builder: (context, provider, child) {
        final catches = provider.catches;

        if (catches.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.set_meal, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text(
                  'Még nincs rögzített fogásod.',
                  style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Használd a középső narancssárga + gombot!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 12, bottom: 150),
          itemCount: catches.length,
          itemBuilder: (context, index) {
            final item = catches[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  child: Icon(Icons.set_meal, size: 35, color: Theme.of(context).colorScheme.primary),
                ),
                title: Text(
                  '${item.species} - ${item.weight} kg',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('yyyy.MM.dd - HH:mm').format(item.dateTime),
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      provider.getSpotName(item.spotId),
                      style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showCatchDetails(context, item, provider),
                onLongPress: () => _confirmDelete(context, provider, item),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, FishingProvider provider, Catch item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Fogás törlése?'),
        content: Text('Biztosan törölni szeretnéd ezt a(z) ${item.weight} kg-os ${item.species} fogást?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Mégse')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              provider.deleteCatch(item.id!);
              Navigator.pop(ctx);
            },
            child: const Text('Törlés'),
          ),
        ],
      ),
    );
  }

  void _showCatchDetails(BuildContext context, Catch item, FishingProvider provider) {
    final recipe = provider.getRecipeById(item.baitRecipeId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.species, style: Theme.of(context).textTheme.headlineMedium),
            const Divider(thickness: 2),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.monitor_weight, 'Súly:', '${item.weight} kg'),
            _buildDetailRow(Icons.straighten, 'Hossz:', '${item.length} cm'),
            _buildDetailRow(Icons.location_on, 'Helyszín:', provider.getSpotName(item.spotId)),
            _buildDetailRow(Icons.restaurant, 'Csali:', item.bait),
            
            if (recipe != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.brown.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.brown.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.inventory_2_rounded, color: Colors.brown),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Használt recept:', style: TextStyle(fontSize: 12, color: Colors.brown)),
                          Text(recipe.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            if (item.notes.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text('Megjegyzés:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(item.notes, style: const TextStyle(fontSize: 18)),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 24),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(width: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
