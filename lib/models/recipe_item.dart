import 'dart:typed_data';

class RecipeItem {
  final int? id;
  // imagePath here is stored as a base64 string
  final Uint8List imagePath;
  final String title;
  final String recipeType;
  final String ingredients;
  final String steps;

  const RecipeItem({
    this.id,
    required this.imagePath,
    required this.title,
    required this.recipeType,
    required this.ingredients,
    required this.steps,
  });

  RecipeItem.fromMap(Map<String, dynamic> response)
    : id = response['id'],
      imagePath = response['image_path'],
      title = response['title'],
      recipeType = response['recipe_type'],
      ingredients = response['ingredients'],
      steps = response['steps'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image_path': imagePath,
      'title': title,
      'recipe_type': recipeType,
      'ingredients': ingredients,
      'steps': steps,
    };
  }

  @override
  String toString() {
    return 'RecipeItem{id: $id, imagePath: $imagePath, title: $title, recipeType: $recipeType, ingredients: $ingredients, steps: $steps}';
  }
}
