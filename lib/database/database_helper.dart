import 'dart:developer';

import 'package:path/path.dart';
import 'package:recipe_app_fourtitude_jw/models/recipe_item.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final String _dbName = 'RecipesDatabase.db';
  static final int _dbVersion = 1;
  static final String tableName = 'recipes_table';

  // creating a singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _db;
  Future<Database> get db async => _db ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    log('initializing database');
    final path = join(await getDatabasesPath(), _dbName);
    var db = await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    return await db.execute('''
            CREATE TABLE $tableName ( 
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            image_path BLOB, 
            title TEXT NOT NULL, 
            recipe_type TEXT NOT NULL, 
            ingredients TEXT NOT NULL, 
            steps TEXT NOT NULL
            )
          ''');
  }

  Future<int> addRecipe(RecipeItem r) async {
    // log('attempting to add recipe: ${r.toString()}');
    Database db = await instance.db;
    return db.insert(tableName, r.toMap());
  }

  Future<int> updateRecipe(RecipeItem r) async {
    log('updating recipe ${r.id}');
    Database db = await instance.db;
    return db.update(tableName, r.toMap(), where: 'id = ?', whereArgs: [r.id]);
  }

  Future<int> deleteRecipe(int id) async {
    log('deleting recipe $id');
    Database db = await instance.db;
    return db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllRecipes() async {
    log('deleting all recipes');
    Database db = await instance.db;
    return db.delete(tableName);
  }

  Future<RecipeItem?> getRecipe(int id) async {
    Database db = await instance.db;
    List<Map<String, Object?>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return RecipeItem.fromMap(maps.first);
  }

  Future<List<RecipeItem>> getAllRecipes() async {
    Database db = await instance.db;
    List<Map<String, Object?>> maps = await db.query(tableName);
    log('there are ${maps.length} in the recipe table');
    return maps.map((e) => RecipeItem.fromMap(e)).toList();
  }

  Future<List<RecipeItem>> filterRecipes({String? recipeType}) async {
    Database db = await instance.db;

    List<Map<String, Object?>> maps;
    if (recipeType == null) {
      maps = await db.query(tableName);
    } else {
      maps = await db.query(
        tableName,
        where: 'recipe_type = ?',
        whereArgs: [recipeType],
      );
    }
    log('There are ${maps.length} recipes in the list');
    return maps.map((e) => RecipeItem.fromMap(e)).toList();
  }
}
