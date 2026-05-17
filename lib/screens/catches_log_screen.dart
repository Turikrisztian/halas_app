import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/fishing_provider.dart';
import 'add_catch_screen.dart';

class CatchesLogScreen extends StatelessWidget {
  const CatchesLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<FishingProvider>(
        builder: (context, provider, child) {
          final catches = provider.catches.reversed.toList();

          if (catches.isEmpty) {
            return const Center(
              child: Text('Még nincs rögzített fogásod.\nKattints a + gombra!'),
            );
          }

          return ListView.builder(
            itemCount: catches.length,
            itemBuilder: (context, index) {
              final item = catches[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.set_meal),
                  ),
                  title: Text('${item.species} - ${item.weight} kg'),
                  subtitle: Text(
                    '${DateFormat('yyyy.MM.dd').format(item.dateTime)} - ${provider.getSpotName(item.spotId)}',
                  ),
                  trailing: const Icon(Icons.more_vert),
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
            MaterialPageRoute(builder: (context) => const AddCatchScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
