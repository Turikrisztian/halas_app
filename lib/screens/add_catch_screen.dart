import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/catch.dart';
import '../providers/fishing_provider.dart';

class AddCatchScreen extends StatefulWidget {
  const AddCatchScreen({super.key});

  @override
  State<AddCatchScreen> createState() => _AddCatchScreenState();
}

class _AddCatchScreenState extends State<AddCatchScreen> {
  final _formKey = GlobalKey<FormState>();
  String _species = 'Ponty';
  double _weight = 0;
  double _length = 0;
  String _bait = '';
  String? _selectedSpotId;

  final List<String> _fishSpecies = [
    'Ponty', 'Amur', 'Csuka', 'Harcsa', 'Süllő', 'Kárász', 'Dévérkeszeg', 'Egyéb'
  ];

  @override
  Widget build(BuildContext context) {
    final spots = Provider.of<FishingProvider>(context).spots;

    return Scaffold(
      appBar: AppBar(title: const Text('Új fogás rögzítése')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            DropdownButtonFormField<String>(
              value: _species,
              decoration: const InputDecoration(labelText: 'Hal fajtája'),
              items: _fishSpecies.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => _species = val!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Súly (kg)', 
                suffixText: 'kg',
                hintText: 'pl. 5.2'
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (val) {
                if (val == null || val.isEmpty) return 'Kötelező megadni a súlyt';
                final normalized = val.replaceAll(',', '.');
                if (double.tryParse(normalized) == null) return 'Érvénytelen számformátum';
                return null;
              },
              onSaved: (val) => _weight = double.parse(val!.replaceAll(',', '.')),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Hossz (cm)', 
                suffixText: 'cm',
                hintText: 'pl. 65'
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (val) {
                if (val == null || val.isEmpty) return 'Kötelező megadni a hosszt';
                final normalized = val.replaceAll(',', '.');
                if (double.tryParse(normalized) == null) return 'Érvénytelen számformátum';
                return null;
              },
              onSaved: (val) => _length = double.parse(val!.replaceAll(',', '.')),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Használt csali'),
              validator: (val) => (val == null || val.isEmpty) ? 'Add meg a csalit is' : null,
              onSaved: (val) => _bait = val!,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedSpotId,
              decoration: const InputDecoration(labelText: 'Horgászhely'),
              hint: const Text('Válassz helyszínt'),
              items: spots.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
              validator: (val) => val == null ? 'Válassz egy helyszínt' : null,
              onChanged: (val) => setState(() => _selectedSpotId = val),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final newCatch = Catch(
                    id: const Uuid().v4(),
                    species: _species,
                    weight: _weight,
                    length: _length,
                    bait: _bait,
                    dateTime: DateTime.now(),
                    spotId: _selectedSpotId!,
                  );
                  Provider.of<FishingProvider>(context, listen: false).addCatch(newCatch);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fogás sikeresen rögzítve!')),
                  );
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
