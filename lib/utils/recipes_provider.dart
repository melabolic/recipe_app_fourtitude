import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipe_app_fourtitude_jw/database/database_helper.dart';
import 'package:recipe_app_fourtitude_jw/models/recipe_type.dart';

import '../models/recipe_item.dart';

class RecipesProvider extends ChangeNotifier {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  List<RecipeItem> recipes = [];
  List<RecipeType> recipeTypes = [];
  RecipeType? selectedRecipeType;
  bool isLoading = false;

  void populateRecipesFromDB() async {
    isLoading = true;

    recipes = await dbHelper.getAllRecipes();
    isLoading = false;
    notifyListeners();
  }

  void getRecipeTypes() async {
    final rawData = await rootBundle.loadString('assets/data/recipeTypes.json');
    final decodedStr = jsonDecode(rawData);
    for (var i = 0; i < decodedStr.length; i++) {
      recipeTypes.add(RecipeType(id: i, type: decodedStr[i]));
    }
  }

  // populating my own data
  void populateDummyData() async {
    log('pre-populating with own data ${recipes.length}');

    await dbHelper.deleteAllRecipes();
    recipes.clear();

    log('recipes should be 0: ${recipes.length}');

    ByteData bytes = await rootBundle.load(
      'assets/images/unsplash_image_1.jpg',
    );
    final dummyImagePath = bytes.buffer.asUint8List();

    recipes = List.generate(10, (index) {
      return RecipeItem(
        id: index,
        imagePath: dummyImagePath,
        title: 'Test $index',
        recipeType: recipeTypes[index % 7].type,
        ingredients: 'Demo',
        steps: 'Steps x$index',
      );
    });

    log('adding populated data to table');
    for (var r in recipes) {
      await dbHelper.addRecipe(r);
    }
    log('recipes: ${recipes.length}');
    notifyListeners();
  }

  void filterRecipesByType({RecipeType? r}) async {
    selectedRecipeType = r;
    recipes = await dbHelper.filterRecipes(recipeType: r?.type);
    notifyListeners();
  }

  void addRecipe(RecipeItem r) {
    recipes.add(r);
    dbHelper.addRecipe(r);
    notifyListeners();
  }

  void deleteRecipe(int id) {
    log('attempting to delete id: $id');
    recipes.removeWhere((e) => e.id == id);
    dbHelper.deleteRecipe(id);
    notifyListeners();
  }

  void updateRecipe(RecipeItem r) {
    var index = recipes.indexWhere((e) => e.id == r.id);
    recipes[index] = r;
    dbHelper.updateRecipe(r);
    notifyListeners();
  }
}
