import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app_fourtitude_jw/screens/new_recipe_page.dart';
import 'package:recipe_app_fourtitude_jw/utils/recipes_provider.dart';

import '../models/recipe_item.dart';
import '../models/recipe_type.dart';
import 'recipe_details_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('My Recipe App'),
        actions: [
          IconButton(
            onPressed: () => _onFilterRecipes(context),
            icon: Icon(Icons.filter_alt),
          ),
        ],
      ),
      body: Consumer<RecipesProvider>(
        builder: (context, instance, child) {
          if (instance.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (instance.recipes.isEmpty) {
            return Center(child: Text('No recipes found.'));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
              ),
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + MediaQuery.of(context).viewPadding.bottom,
              ),
              itemCount: instance.recipes.length,
              itemBuilder: (context, index) {
                final recipeData = instance.recipes[index];

                return InkWell(
                  onTap: () => _onClickRecipe(context, instance.recipes[index]),
                  borderRadius: BorderRadius.circular(8),
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.memory(
                            recipeData.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Center(
                            child: Text(
                              recipeData.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddRecipe(context),
        tooltip: 'Add a Recipe',
        shape: CircleBorder(),
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onFilterRecipes(BuildContext context) {
    final recipeTypes = context.read<RecipesProvider>().recipeTypes;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            24,
            18,
            24,
            MediaQuery.of(context).viewPadding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Filter:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 12),
              ...List.generate(recipeTypes.length, (index) {
                return TextButton(
                  child: Text(
                    recipeTypes[index].type,
                    style:
                        (context.read<RecipesProvider>().selectedRecipeType ==
                                recipeTypes[index])
                            ? TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            )
                            : TextStyle(fontSize: 16),
                  ),
                  onPressed: () => _onSelectFilter(context, recipeTypes[index]),
                );
              }),
              TextButton.icon(
                onPressed: () => _onClearFilters(context),
                label: Text(
                  'Clear Filters',
                  style: TextStyle(color: Colors.red),
                ),
                icon: Icon(Icons.clear, color: Colors.red),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onClickRecipe(BuildContext context, RecipeItem item) {
    context.go(RecipeDetailsPage.routeName, extra: item);
  }

  void _onAddRecipe(BuildContext context) {
    context.go(NewRecipePage.routeName);
  }

  void _onSelectFilter(BuildContext context, RecipeType type) {
    context.read<RecipesProvider>().filterRecipesByType(r: type);
    context.pop();
  }

  void _onClearFilters(BuildContext context) {
    context.read<RecipesProvider>().filterRecipesByType();
    context.pop();
  }
}
