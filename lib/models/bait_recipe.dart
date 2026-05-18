class BaitRecipe {
  final int? id;
  final String name;
  final String description;
  final List<String> ingredients;

  BaitRecipe({
    this.id,
    required this.name,
    required this.description,
    required this.ingredients,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ingredients': ingredients.join('|'), // Store as pipe-separated string in SQLite
    };
  }

  factory BaitRecipe.fromMap(Map<String, dynamic> map) {
    return BaitRecipe(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      ingredients: (map['ingredients'] as String).split('|'),
    );
  }
}
