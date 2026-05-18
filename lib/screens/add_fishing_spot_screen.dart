import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
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
  String _notes = '';
  bool _isGettingLocation = false;
  double? _lat;
  double? _lng;

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'A helyszolgáltatás ki van kapcsolva.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Helyszín hozzáférés megtagadva.';
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      
      setState(() {
        _lat = position.latitude;
        _lng = position.longitude;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Koordináták rögzítve!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hiba: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => _isGettingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Új horgászhely')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            const Text('Horgászvíz neve', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            TextFormField(
              style: const TextStyle(fontSize: 22),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'pl. Balaton, Duna szakasz',
              ),
              validator: (val) => (val == null || val.isEmpty) ? 'Add meg a nevet!' : null,
              onSaved: (val) => _name = val!,
            ),
            const SizedBox(height: 24),
            const Text('Jegyzetek', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            TextFormField(
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Mélység, akadók, etetés helye...',
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              onSaved: (val) => _notes = val ?? '',
            ),
            const SizedBox(height: 32),
            
            // Helyszín gomb
            OutlinedButton.icon(
              onPressed: _isGettingLocation ? null : _getCurrentLocation,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: _isGettingLocation 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.my_location, size: 28),
              label: Text(
                _lat == null ? 'PONTOS HELY RÖGZÍTÉSE' : 'HELYSZÍN FRISSÍTÉSE',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (_lat != null) ...[
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Koordináták: ${_lat!.toStringAsFixed(5)}, ${_lng!.toStringAsFixed(5)}',
                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ],
            
            const SizedBox(height: 48),
            
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
                  
                  final newSpot = FishingSpot(
                    name: _name,
                    notes: _notes,
                    latitude: _lat,
                    longitude: _lng,
                    createdAt: DateTime.now(),
                  );
                  
                  Provider.of<FishingProvider>(context, listen: false).addSpot(newSpot);
                  Navigator.pop(context);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Horgászhely mentve!', style: TextStyle(fontSize: 18)),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('HELYSZÍN MENTÉSE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
