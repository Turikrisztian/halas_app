import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/catch.dart';
import '../providers/fishing_provider.dart';

class AddCatchScreen extends StatelessWidget {
  const AddCatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Új fogás rögzítése')),
      body: const AddCatchForm(),
    );
  }
}

class AddCatchForm extends StatefulWidget {
  const AddCatchForm({super.key});

  @override
  State<AddCatchForm> createState() => _AddCatchFormState();
}

class _AddCatchFormState extends State<AddCatchForm> {
  final _formKey = GlobalKey<FormState>();
  String _species = 'Ponty';
  double _weight = 0;
  double _length = 0;
  String _bait = '';
  int? _selectedSpotId;
  String _notes = '';

  final List<String> _fishSpecies = [
    'Ponty', 'Amur', 'Csuka', 'Harcsa', 'Süllő', 'Kárász', 'Dévérkeszeg', 'Egyéb'
  ];

  @override
  Widget build(BuildContext context) {
    final spots = Provider.of<FishingProvider>(context).spots;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text('Mit fogtál?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _species,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            isExpanded: true,
            items: _fishSpecies.map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 20)))).toList(),
            onChanged: (val) => setState(() => _species = val!),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Súly (kg)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        suffixText: 'kg',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (val) => (val == null || val.isEmpty) ? 'Írd be!' : null,
                      onSaved: (val) => _weight = double.tryParse(val!.replaceAll(',', '.')) ?? 0,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hossz (cm)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),
                    TextFormField(
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        suffixText: 'cm',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (val) => (val == null || val.isEmpty) ? 'Írd be!' : null,
                      onSaved: (val) => _length = double.tryParse(val!.replaceAll(',', '.')) ?? 0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Csali', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          TextFormField(
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'pl. Kukorica, Bojli',
            ),
            validator: (val) => (val == null || val.isEmpty) ? 'Mi volt a csali?' : null,
            onSaved: (val) => _bait = val!,
          ),
          const SizedBox(height: 24),
          const Text('Hol fogtad?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: _selectedSpotId,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Válassz helyszínt',
            ),
            items: spots.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name, style: const TextStyle(fontSize: 18)))).toList(),
            validator: (val) => val == null ? 'Válassz helyet!' : null,
            onChanged: (val) => setState(() => _selectedSpotId = val),
          ),
          const SizedBox(height: 24),
          const Text('Megjegyzés', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          TextFormField(
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Pár szó a fogásról...',
            ),
            maxLines: 3,
            onSaved: (val) => _notes = val ?? '',
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(70),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final newCatch = Catch(
                  species: _species,
                  weight: _weight,
                  length: _length,
                  bait: _bait,
                  dateTime: DateTime.now(),
                  spotId: _selectedSpotId!,
                  notes: _notes,
                );
                Provider.of<FishingProvider>(context, listen: false).addCatch(newCatch);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fogás sikeresen mentve!', style: TextStyle(fontSize: 18)),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('FOGÁS MENTÉSE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
