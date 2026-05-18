import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/fishing_provider.dart';

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
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 12, bottom: 160),
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
                subtitle: Text(
                  DateFormat('yyyy.MM.dd - HH:mm').format(item.dateTime),
                  style: const TextStyle(fontSize: 18),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            );
          },
        );
      },
    );
  }
}
