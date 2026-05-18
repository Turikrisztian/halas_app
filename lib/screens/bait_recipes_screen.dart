import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fishing_provider.dart';
import '../models/bait_recipe.dart';
import 'add_bait_recipe_screen.dart';

class BaitRecipesScreen extends StatelessWidget {
  const BaitRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Digitális Szerelékesláda'),
      ),
      body: Consumer<FishingProvider>(
        builder: (context, provider, child) {
          final recipes = provider.baitRecipes;

          if (recipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'Üres a szerelékesládád.',
                    style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                  const Text('Kattints a + gombra új receptért!', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.brown.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.waves_rounded, color: Colors.brown),
                  ),
                  title: Text(
                    recipe.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      recipe.ingredients.join(', '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showRecipeDetails(context, recipe),
                  onLongPress: () => _confirmDelete(context, provider, recipe),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBaitRecipeScreen()),
          );
        },
        backgroundColor: Colors.brown.shade600,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded, size: 40),
      ),
    );
  }

  void _confirmDelete(BuildContext context, FishingProvider provider, BaitRecipe recipe) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Recept törlése?'),
        content: Text('Biztosan törölni szeretnéd a(z) "${recipe.name}" receptet?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Mégse')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              provider.deleteBaitRecipe(recipe.id!);
              Navigator.pop(ctx);
            },
            child: const Text('Törlés'),
          ),
        ],
      ),
    );
  }

  void _showRecipeDetails(BuildContext context, BaitRecipe recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recipe.name, style: Theme.of(context).textTheme.headlineMedium),
            const Divider(thickness: 2),
            const SizedBox(height: 16),
            const Text(
              'Összetevők:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recipe.ingredients.map((ing) => Chip(
                label: Text(ing, style: const TextStyle(fontSize: 16)),
                backgroundColor: Colors.brown.shade50,
                side: BorderSide(color: Colors.brown.shade100),
              )).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Leírás / Alkalmazás:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                recipe.description.isEmpty ? 'Nincs leírás.' : recipe.description,
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
