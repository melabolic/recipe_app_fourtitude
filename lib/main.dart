import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../database/database_helper.dart';
import '../models/recipe_item.dart';
import '../screens/edit_recipe_page.dart';
import '../screens/home_page.dart';
import '../screens/new_recipe_page.dart';
import '../screens/recipe_details_page.dart';
import '../utils/recipes_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.db;

  runApp(
    ChangeNotifierProvider(
      create:
          (context) =>
              RecipesProvider()
                // ..populateRecipesFromDB()
                ..getRecipeTypes()
                ..populateDummyData(),
      child: RecipeApp(),
    ),
  );
}

class RecipeApp extends StatelessWidget {
  RecipeApp({super.key});

  final _router = GoRouter(
    routes: [
      GoRoute(
        path: HomePage.routeName,
        builder: (_, __) => const HomePage(),
        routes: [
          GoRoute(
            path: RecipeDetailsPage.routeName,
            builder: (_, state) {
              RecipeItem recipe = state.extra as RecipeItem;
              return RecipeDetailsPage(recipe: recipe);
            },
          ),
          GoRoute(
            path: NewRecipePage.routeName,
            builder: (_, __) => NewRecipePage(),
          ),
          GoRoute(
            path: EditRecipePage.routeName,
            builder: (_, state) {
              RecipeItem recipe = state.extra as RecipeItem;
              return EditRecipePage(recipe: recipe);
            },
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Recipe App Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      routerConfig: _router,
    );
  }
}
