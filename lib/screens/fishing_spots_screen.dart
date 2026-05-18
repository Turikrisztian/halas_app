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
                Icon(Icons.map_outlined, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                const Text(
                  'Nincs még mentett helyszíned.',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
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
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: const Icon(Icons.location_on, color: Colors.red, size: 40),
                title: Text(
                  spot.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    spot.notes.length > 60 
                        ? '${spot.notes.substring(0, 60)}...' 
                        : spot.notes,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  _showSpotDetails(context, spot);
                },
              ),
            );
          },
        );
      },
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
                Expanded(
                  child: Text(
                    spot.name, 
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context), 
                  icon: const Icon(Icons.close, size: 30)
                ),
              ],
            ),
            const Divider(thickness: 2),
            const SizedBox(height: 16),
            if (spot.latitude != null) ...[
              const Text(
                'Koordináták:', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                '${spot.latitude!.toStringAsFixed(4)}, ${spot.longitude!.toStringAsFixed(4)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
            ],
            const Text(
              'Jegyzetek:', 
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                spot.notes.isEmpty ? 'Nincs jegyzet.' : spot.notes,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
