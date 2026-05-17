import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/fishing_spot.dart';
import '../providers/fishing_provider.dart';

class AddFishingSpotScreen extends StatefulWidget {
  const AddFishingSpotScreen({super.key});

  @override
  State<AddFishingSpotScreen> createState() => _AddFishingSpotScreenState();
}

class _AddFishingSpotScreenState extends State<AddFishingSpotScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _coordinates = '';
  String _notes = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Új horgászhely')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Horgászvíz neve',
                hintText: 'pl. Balaton, Ráckevei-Duna',
              ),
              validator: (val) => (val == null || val.isEmpty) ? 'Kötelező' : null,
              onSaved: (val) => _name = val!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Koordináták / Helyszín',
                hintText: 'pl. 46.95, 17.89 vagy "Északi part"',
                suffixIcon: Icon(Icons.my_location),
              ),
              onSaved: (val) => _coordinates = val ?? '',
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Jegyzetek (mélység, akadó, csali)',
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              onSaved: (val) => _notes = val ?? '',
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final newSpot = FishingSpot(
                    id: const Uuid().v4(),
                    name: _name,
                    coordinates: _coordinates,
                    notes: _notes,
                  );
                  Provider.of<FishingProvider>(context, listen: false).addSpot(newSpot);
                  Navigator.pop(context);
                }
              },
              child: const Text('MENTÉS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
