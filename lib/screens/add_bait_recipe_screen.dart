import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bait_recipe.dart';
import '../providers/fishing_provider.dart';

class AddBaitRecipeScreen extends StatefulWidget {
  const AddBaitRecipeScreen({super.key});

  @override
  State<AddBaitRecipeScreen> createState() => _AddBaitRecipeScreenState();
}

class _AddBaitRecipeScreenState extends State<AddBaitRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  final List<TextEditingController> _ingredientControllers = [TextEditingController()];

  void _addIngredientField() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  void _saveRecipe() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final ingredients = _ingredientControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      if (ingredients.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Legalább egy összetevőt adj meg!')),
        );
        return;
      }

      final newRecipe = BaitRecipe(
        name: _name,
        description: _description,
        ingredients: ingredients,
      );

      Provider.of<FishingProvider>(context, listen: false).addBaitRecipe(newRecipe);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Új recept rögzítése')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Recept neve', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            TextFormField(
              style: const TextStyle(fontSize: 20),
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'pl. Tavaszi Pontyos Mix'),
              validator: (val) => (val == null || val.isEmpty) ? 'Adj meg egy nevet!' : null,
              onSaved: (val) => _name = val!,
            ),
            const SizedBox(height: 24),
            const Text('Összetevők', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            ...List.generate(_ingredientControllers.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ingredientControllers[index],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: '${index + 1}. összetevő',
                        ),
                      ),
                    ),
                    if (index > 0)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () => setState(() => _ingredientControllers.removeAt(index)),
                      ),
                  ],
                ),
              );
            }),
            TextButton.icon(
              onPressed: _addIngredientField,
              icon: const Icon(Icons.add),
              label: const Text('Új összetevő hozzáadása'),
            ),
            const SizedBox(height: 24),
            const Text('Elkészítés / Tippek', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Hogyan készíted el? Mikor vált be?'),
              onSaved: (val) => _description = val ?? '',
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                backgroundColor: Colors.brown.shade600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _saveRecipe,
              child: const Text('RECEPT MENTÉSE', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
