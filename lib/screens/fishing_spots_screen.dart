import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/fishing_spot.dart';
import '../providers/fishing_provider.dart';

class FishingSpotsScreen extends StatelessWidget {
  const FishingSpotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FishingProvider>(
      builder: (context, provider, child) {
        final spots = provider.spots;

        if (spots.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text(
                  'Nincs még mentett helyszíned.',
                  style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 12, bottom: 120),
          itemCount: spots.length,
          itemBuilder: (context, index) {
            final spot = spots[index];
            final catchCount = provider.getCatchCountForSpot(spot.id!);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on, color: Colors.red, size: 30),
                ),
                title: Text(
                  spot.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      spot.notes.length > 50 ? '${spot.notes.substring(0, 50)}...' : spot.notes,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rögzített fogások: $catchCount db',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showSpotDetails(context, spot),
                onLongPress: () => _confirmDelete(context, provider, spot),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, FishingProvider provider, FishingSpot spot) {
    if (spot.id == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Az alapértelmezett helyszín nem törölhető!')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Helyszín törlése?'),
        content: Text('Biztosan törölni szeretnéd a(z) "${spot.name}" helyszínt?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Mégse')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              provider.deleteSpot(spot.id!);
              Navigator.pop(ctx);
            },
            child: const Text('Törlés'),
          ),
        ],
      ),
    );
  }

  void _showSpotDetails(BuildContext context, FishingSpot spot) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(spot.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, size: 30)),
              ],
            ),
            const Divider(thickness: 2),
            const SizedBox(height: 16),
            if (spot.latitude != null) ...[
              const Text('Koordináták:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(
                '${spot.latitude!.toStringAsFixed(5)}, ${spot.longitude!.toStringAsFixed(5)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
            ],
            const Text('Jegyzetek:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: Text(spot.notes.isEmpty ? 'Nincs jegyzet.' : spot.notes, style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
