import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/recipe_item.dart';
import '../screens/edit_recipe_page.dart';
import '../utils/recipes_provider.dart';

class RecipeDetailsPage extends StatefulWidget {
  const RecipeDetailsPage({super.key, required this.recipe});

  final RecipeItem recipe;

  static const routeName = '/recipeDetails';

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  late RecipeItem recipe;

  @override
  void initState() {
    super.initState();
    recipe = widget.recipe;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () => _onEditRecipe(widget.recipe),
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _onDeleteRecipe(widget.recipe.id),
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2,
              child: Image.memory(recipe.imagePath, fit: BoxFit.fitWidth),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                recipe.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Chip(label: Text(recipe.recipeType)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text('Ingredients', style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(recipe.ingredients),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Steps', style: TextStyle(fontSize: 20)),
            ),
            Padding(padding: EdgeInsets.all(16.0), child: Text(recipe.steps)),
            SizedBox(height: MediaQuery.of(context).viewPadding.bottom),
          ],
        ),
      ),
    );
  }

  void _onEditRecipe(RecipeItem r) async {
    var updated = await context.push<RecipeItem?>(
      EditRecipePage.routeName,
      extra: r,
    );
    if (updated != null) {
      setState(() => recipe = updated);
    }
  }

  void _onDeleteRecipe(int? id) {
    if (id != null) {
      context.read<RecipesProvider>().deleteRecipe(id);
      context.pop();
    }
  }
}
