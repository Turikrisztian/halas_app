import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fishing_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<FishingProvider>(context, listen: false);
    _nameController.text = provider.userName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beállítások')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Profil adatok',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Horgász neve',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
              hintText: 'Hogyan látszódj a versenyeken?',
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              if (_nameController.text.trim().isNotEmpty) {
                Provider.of<FishingProvider>(context, listen: false)
                    .setUserName(_nameController.text.trim());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Név elmentve!')),
                );
              }
            },
            child: const Text('MENTÉS', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 48),
          const Divider(),
          const SizedBox(height: 24),
          const Text(
            'Alkalmazás információ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Verzió'),
            trailing: Text('1.2.0'),
          ),
          const ListTile(
            leading: Icon(Icons.security),
            title: Text('Adatvédelem'),
            subtitle: Text('Minden adat kizárólag a telefonon tárolódik.'),
          ),
        ],
      ),
    );
  }
}
