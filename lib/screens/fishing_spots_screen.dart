import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/fishing_spot.dart';
import '../providers/fishing_provider.dart';
import 'add_fishing_spot_screen.dart';

class FishingSpotsScreen extends StatelessWidget {
  const FishingSpotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FishingProvider>(
        builder: (context, provider, child) {
          final spots = provider.spots;

          if (spots.isEmpty) {
            return const Center(
              child: Text('Még nincs rögzített horgászhelyed.\nKattints a + gombra!'),
            );
          }

          return ListView.builder(
            itemCount: spots.length,
            itemBuilder: (context, index) {
              final spot = spots[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.red),
                  title: Text(spot.name),
                  subtitle: Text(
                    spot.notes.length > 50 
                        ? '${spot.notes.substring(0, 50)}...' 
                        : spot.notes,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFishingSpotScreen()),
          );
        },
        child: const Icon(Icons.add_location),
      ),
    );
  }

  void _showSpotDetails(BuildContext context, FishingSpot spot) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 24.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(spot.name, style: Theme.of(context).textTheme.headlineSmall),
            const Divider(),
            const SizedBox(height: 8),
            if (spot.coordinates != null && spot.coordinates!.isNotEmpty) ...[
              const Text('Koordináták:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(spot.coordinates!),
              const SizedBox(height: 16),
            ],
            const Text('Jegyzetek:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(spot.notes),
            const SizedBox(height: 30),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Bezárás'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
