import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/recipe_item.dart';
import '../utils/recipes_provider.dart';

class NewRecipePage extends StatefulWidget {
  const NewRecipePage({super.key});

  static const routeName = '/newRecipe';

  @override
  State<NewRecipePage> createState() => _NewRecipePageState();
}

class _NewRecipePageState extends State<NewRecipePage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _recipeTypeController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();

  Uint8List _imagePath = Uint8List(0);

  @override
  void dispose() {
    _titleController.dispose();
    _recipeTypeController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('New Recipe'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    FormBuilderImagePicker(
                      previewAutoSizeWidth: true,
                      transformImageWidget:
                          (context, displayImage) =>
                              SizedBox.expand(child: displayImage),
                      fit: BoxFit.fitWidth,
                      name: 'Recipe Photo',
                      showDecoration: true,
                      decoration: InputDecoration(border: InputBorder.none),
                      maxImages: 1,
                      onChanged: _onSelectPicture,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      bottomSheetPadding: EdgeInsets.fromLTRB(
                        12,
                        12,
                        12,
                        MediaQuery.of(context).viewPadding.bottom,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a picture.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _titleController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Recipe Name',
                        labelText: 'Recipe Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter recipe\'s name.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownMenu(
                      controller: _recipeTypeController,
                      width: double.infinity,
                      requestFocusOnTap: true,
                      label: Text('Recipe Type'),
                      inputDecorationTheme: InputDecorationTheme(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      initialSelection: 0,
                      dropdownMenuEntries:
                          context
                              .read<RecipesProvider>()
                              .recipeTypes
                              .map(
                                (e) => DropdownMenuEntry(
                                  value: e.id,
                                  label: e.type,
                                ),
                              )
                              .toList(),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _ingredientsController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Ingredients',
                        labelText: 'Ingredients',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the ingredients.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _stepsController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 4,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Steps',
                        labelText: 'Steps',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the steps.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onSaveRecipe,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).buttonTheme.colorScheme!.primary,
                  foregroundColor:
                      Theme.of(context).colorScheme.onInverseSurface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Save Recipe',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSelectPicture(List<dynamic>? images) async {
    if (images!.isNotEmpty) {
      final bytes = await (images.first as XFile).readAsBytes();
      _imagePath = bytes;
    } else {
      _imagePath = Uint8List(0);
    }
  }

  void _onSaveRecipe() {
    if (_formKey.currentState!.validate() && _imagePath.isNotEmpty) {
      log('entries passed vibe check');
      final newRecipe = RecipeItem(
        imagePath: _imagePath,
        title: _titleController.text.trim(),
        recipeType: _recipeTypeController.text.trim(),
        ingredients: _ingredientsController.text.trim(),
        steps: _stepsController.text.trim(),
      );
      context.read<RecipesProvider>().addRecipe(newRecipe);
      context.pop();
    }
  }
}
