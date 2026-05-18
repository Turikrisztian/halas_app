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
  int? _selectedRecipeId;
  int? _selectedSpotId;
  String _notes = '';

  final List<String> _fishSpecies = [
    'Ponty', 'Amur', 'Csuka', 'Harcsa', 'Süllő', 'Kárász', 'Dévérkeszeg', 'Egyéb'
  ];

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final provider = Provider.of<FishingProvider>(context, listen: false);
      
      // Szabályellenőrzés
      final warning = provider.validateCatch(_species, _length, DateTime.now());
      
      if (warning != null) {
        _showWarningDialog(warning, provider);
      } else {
        _performSave(provider);
      }
    }
  }

  void _showWarningDialog(String message, FishingProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Figyelem! ⚠️', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        content: Text("$message\n\nBiztosan rögzíteni szeretnéd a fogást?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Mégse')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _performSave(provider);
            }, 
            child: const Text('Igen, rögzítsd')
          ),
        ],
      ),
    );
  }

  void _performSave(FishingProvider provider) {
    final newCatch = Catch(
      species: _species,
      weight: _weight,
      length: _length,
      bait: _bait,
      baitRecipeId: _selectedRecipeId,
      dateTime: DateTime.now(),
      spotId: _selectedSpotId!,
      notes: _notes,
    );
    provider.addCatch(newCatch);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fogás sikeresen mentve!', style: TextStyle(fontSize: 18)), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FishingProvider>(context);
    final spots = provider.spots;
    final recipes = provider.baitRecipes;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text('Mit fogtál?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _species,
            decoration: const InputDecoration(border: OutlineInputBorder()),
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
                      decoration: const InputDecoration(border: OutlineInputBorder(), suffixText: 'kg'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (val) => (val == null || val.isEmpty) ? 'Írd be!' : null,
                      onSaved: (val) => _weight = double.parse(val!.replaceAll(',', '.')),
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
                      decoration: const InputDecoration(border: OutlineInputBorder(), suffixText: 'cm'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (val) => (val == null || val.isEmpty) ? 'Írd be!' : null,
                      onSaved: (val) => _length = double.parse(val!.replaceAll(',', '.')),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Csali típusa / leírása', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          TextFormField(
            style: const TextStyle(fontSize: 20),
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'pl. Kukorica, Bojli'),
            validator: (val) => (val == null || val.isEmpty) ? 'Mi volt a csali?' : null,
            onSaved: (val) => _bait = val!,
          ),
          const SizedBox(height: 24),
          const Text('Csalirecept kiválasztása (opcionális)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          DropdownButtonFormField<int?>(
            value: _selectedRecipeId,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Válassz receptet'),
            items: [
              const DropdownMenuItem<int?>(value: null, child: Text('Nincs recept')),
              ...recipes.map((r) => DropdownMenuItem<int?>(value: r.id, child: Text(r.name))),
            ],
            onChanged: (val) => setState(() => _selectedRecipeId = val),
          ),
          const SizedBox(height: 24),
          const Text('Hol fogtad?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: _selectedSpotId,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Válassz helyszínt'),
            items: spots.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name, style: const TextStyle(fontSize: 18)))).toList(),
            validator: (val) => val == null ? 'Válassz helyet!' : null,
            onChanged: (val) => setState(() => _selectedSpotId = val),
          ),
          const SizedBox(height: 24),
          const Text('Megjegyzés', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          TextFormField(
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Pár szó a fogásról...'),
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
            onPressed: _saveForm,
            child: const Text('FOGÁS MENTÉSE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
